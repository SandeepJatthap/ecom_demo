import 'package:task_ecom_app/core/error/failures.dart';
import 'package:task_ecom_app/core/network/network_info.dart';
import 'package:task_ecom_app/data/data_sources/local/user_local_data_source.dart';
import 'package:task_ecom_app/data/data_sources/remote/user_remote_data_source.dart';
import 'package:task_ecom_app/data/repositories/user_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/constant_objects.dart';

class MockRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockLocalDataSource extends Mock implements UserLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late UserRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreted', () {
    test(
      'should check if the device is online on signIn',
      () async {
        /// Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.signIn(tSignInParams)).thenAnswer(
            (invocation) => Future.value(tAuthenticationResponseModel));
        when(() => mockLocalDataSource.saveUser(tUserModel))
            .thenAnswer((invocation) => Future.value());
        when(() => mockLocalDataSource.saveToken('token'))
            .thenAnswer((invocation) => Future.value());

        /// Act
        repository.signIn(tSignInParams);

        /// Assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );
  });

  runTestsOnline(() {
    test(
      'should return user data data when the call to sign in source is successful',
      () async {
        /// Arrange
        when(() => mockRemoteDataSource.signIn(tSignInParams)).thenAnswer(
            (invocation) => Future.value(tAuthenticationResponseModel));
        when(() => mockLocalDataSource.saveUser(tUserModel))
            .thenAnswer((invocation) => Future.value());
        when(() => mockLocalDataSource.saveToken('token'))
            .thenAnswer((invocation) => Future.value());

        /// Act
        final actualResult = await repository.signIn(tSignInParams);

        /// Assert
        actualResult.fold(
          (left) => fail('test failed'),
          (right) => expect(right, tUserModel),
        );
      },
    );

    test(
      'should cache the user data locally when the call to sign in source is successful',
      () async {
        /// Arrange
        when(() => mockRemoteDataSource.signIn(tSignInParams)).thenAnswer(
            (invocation) => Future.value(tAuthenticationResponseModel));
        when(() => mockLocalDataSource.saveUser(tUserModel))
            .thenAnswer((invocation) => Future.value());
        when(() => mockLocalDataSource.saveToken('token'))
            .thenAnswer((invocation) => Future.value());

        /// Act
        await repository.signIn(tSignInParams);

        /// Assert
        verify(() => mockLocalDataSource.saveToken('token'));
        verify(() => mockLocalDataSource.saveUser(tUserModel));
      },
    );

    test(
      'should return server failure when the call to remote sign-in source is unsuccessful',
      () async {
        /// Arrange
        when(() => mockRemoteDataSource.signIn(tSignInParams))
            .thenThrow(ServerFailure());

        /// Act
        final result = await repository.signIn(tSignInParams);

        /// Assert
        result.fold(
          (left) => expect(left, ServerFailure()),
          (right) => fail('test failed'),
        );
      },
    );
  });
}
