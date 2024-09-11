import 'dart:convert';
import 'package:task_ecom_app/core/constant/strings.dart';
import 'package:task_ecom_app/data/data_sources/remote/user_remote_data_source.dart';
import 'package:task_ecom_app/data/models/user/authentication_response_model.dart';
import 'package:task_ecom_app/domain/usecases/user/sign_in_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late UserRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = UserRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('signIn', () {
    test(
        'should perform a POST request to the correct URL with the given parameters',
        () async {
      /// Arrange
      const fakeParams = SignInParams();
      const expectedUrl = '$baseUrl/authentication/local/sign-in';
      final fakeResponse = fixture('user/authentication_response.json');
      when(() => mockHttpClient.post(
            Uri.parse(expectedUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({}),
          )).thenAnswer((_) async => http.Response(fakeResponse, 200));

      /// Act
      final result = await dataSource.signIn(fakeParams);

      /// Assert
      verify(() => mockHttpClient.post(
            Uri.parse(expectedUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({}),
          ));
      expect(result, isA<AuthenticationResponseModel>());
    });
  });
}
