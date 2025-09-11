import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/data/models/user_model.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class FirebaseAuthDatasource implements AuthDatasource {
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDatasource(this._firebaseAuth, this._firestore);

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  }) async {
    //Cria email e senha no Firebase
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user == null) throw AuthFailure(AuthErrorType.unauthenticated);

    await user.updateDisplayName(name);
    await user.reload();

    print('gio: register $name');

    // Salvar no Firestore
    final userModel = UserModel(id: user.uid, name: name, email: email);
    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

    return userModel;
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) throw AuthFailure(AuthErrorType.userNotFound);
      print('gio: login ${user.displayName}');

      await user.reload();
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
    } on fb.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthFailure(AuthErrorType.invalidEmail, message: e.message);
        case 'wrong-password':
          throw AuthFailure(AuthErrorType.wrongPassword, message: e.message);
        case 'missing-password':
          throw AuthFailure(AuthErrorType.wrongPassword, message: e.message);
        case 'invalid-credential':
          // Firebase pode retornar esse código genérico para email/senha inválidos
          throw AuthFailure(AuthErrorType.wrongPassword, message: e.message);
        case 'user-not-found':
          throw AuthFailure(AuthErrorType.userNotFound, message: e.message);
        case 'network-request-failed':
          throw ServerFailure(ServerErrorType.network, message: e.message);
        default:
          throw AuthFailure(AuthErrorType.unknown, message: e.message);
      }
    } on FirebaseException {
      throw ServerFailure(ServerErrorType.network);
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      // e.code: 'user-not-found', 'invalid-email', etc.
      switch (e.code) {
        case 'user-not-found':
          throw AuthFailure(AuthErrorType.userNotFound);
        case 'invalid-email':
          throw AuthFailure(AuthErrorType.invalidEmail);
        default:
          throw AuthFailure(AuthErrorType.unknown);
      }
    } on FirebaseException {
      throw ServerFailure(ServerErrorType.network);
    } catch (_) {
      throw ServerFailure(ServerErrorType.unknown);
    }
  }
}
