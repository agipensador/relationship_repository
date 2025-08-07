import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/data/models/user_model.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
 
class FirebaseAuthDatasource implements AuthDatasource  {
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
      final result = await _firebaseAuth
        .createUserWithEmailAndPassword(
          email: email, password: password);
      //Cria/atualiza o nome baseado no usuario criado
      // await result.user?.updateDisplayName(name);

      final user = result.user;
      if (user == null) throw AuthFailure(AppStrings.createUserError);

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
    required String password}) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password);

    final user = result.user;
    if (user == null) throw AuthFailure(AppStrings.userNotFound);
    print('gio: login ${user.displayName}');

    await user.reload();
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}