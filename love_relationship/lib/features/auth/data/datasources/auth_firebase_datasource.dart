import 'package:firebase_auth/firebase_auth.dart' as fb;

abstract class AuthFirebaseDatasource {
  Future<fb.User> loginWithEmail(String email, String senha);
}