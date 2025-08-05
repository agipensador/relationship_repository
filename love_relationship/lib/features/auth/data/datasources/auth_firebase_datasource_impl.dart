import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_firebase_datasource.dart';
 
class AuthFirebaseDatasourceImpl implements AuthFirebaseDatasource  {
  final fb.FirebaseAuth firebaseAuth;

  AuthFirebaseDatasourceImpl(this.firebaseAuth);
  
  @override
  Future<fb.User> loginWithEmail(String email, String password) async{
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password);

    final user = result.user;
    if (user == null) throw AuthFailure('Usuário não encontrado');
    return user;
  }
}