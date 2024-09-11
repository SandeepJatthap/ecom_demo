import 'package:task_ecom_app/core/error/failures.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_ecom_app/data/models/user/user_model.dart';
import '../../../domain/usecases/user/sign_in_usecase.dart';
import '../../models/user/authentication_response_model.dart';

abstract class UserRemoteDataSource {
  Future<AuthenticationResponseModel> signIn(SignInParams params);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthenticationResponseModel> signIn(SignInParams params) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      var user = await FirebaseAuth.instance.signInWithCredential(credential);
      return AuthenticationResponseModel(
          token: user.user!.refreshToken??'',
          user: UserModel(
              id: user.user?.uid ?? "",
              firstName: user.user?.displayName ?? '',
              lastName: '',
              image: user.user?.photoURL,
              email: user.user?.email ?? ''));
    } on Exception catch (e,s) {
      throw CredentialFailure();
    }
  }
}
