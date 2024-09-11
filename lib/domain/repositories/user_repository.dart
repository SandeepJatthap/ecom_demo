import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user/user.dart';
import '../usecases/user/sign_in_usecase.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> signIn(SignInParams params);
}
