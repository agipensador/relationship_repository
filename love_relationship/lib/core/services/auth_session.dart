import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:love_relationship/core/error/failure.dart';

abstract class AuthSession {
  String? currentUidOrNull();
  String requireUid(); // Lança se não autenticado
  Stream<String?> uidChanges();
}

class FirebaseAuthSession implements AuthSession {
  final fb.FirebaseAuth _auth;
  FirebaseAuthSession(this._auth);

  @override
  String? currentUidOrNull() => _auth.currentUser?.uid;

  @override
  String requireUid() {
    final uid = fb.FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw AuthFailure(AuthErrorType.unauthenticated);
    }
    return uid;
  }

  @override
  Stream<String?> uidChanges() => _auth.userChanges().map((user) => user?.uid);
}