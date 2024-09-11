import 'package:dartz/dartz.dart';
import 'package:task_ecom_app/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/local/user_local_data_source.dart';
import '../data_sources/remote/user_remote_data_source.dart';
import '../models/user/authentication_response_model.dart';

typedef _DataSourceChooser = Future<AuthenticationResponseModel> Function();

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signIn(params) async {
    return await _authenticate(() {
      return remoteDataSource.signIn(params);
    });
  }

  Future<Either<Failure, User>> _authenticate(
    _DataSourceChooser getDataSource,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await getDataSource();
        localDataSource.saveToken(remoteResponse.token);
        localDataSource.saveUser(remoteResponse.user);
        return Right(remoteResponse.user);
      } on Failure catch (failure) {
        return Left(failure);
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
