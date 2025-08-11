import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:love_relationship/core/constants/app_strings.dart';

abstract class AuthSession {
  String? currentUidOrNull();
  String requiredUid(); // Lança se não autenticado
  Stream<String?> uidChanges();
}

class FirebaseAuthSession implements AuthSession {
  final fb.FirebaseAuth _auth;
  FirebaseAuthSession(this._auth);

  @override
  String? currentUidOrNull() => _auth.currentUser?.uid;

  @override
  String requiredUid(){
    final uid = currentUidOrNull();
    if(uid == null) throw StateError(AppStrings.unauthenticatedUser);
    return uid; 
  }

  @override
  Stream<String?> uidChanges() => _auth.userChanges().map((user) => user?.uid);
}