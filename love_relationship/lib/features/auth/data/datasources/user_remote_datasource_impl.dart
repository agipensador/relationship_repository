import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:love_relationship/features/auth/data/models/user_model.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  UserRemoteDataSourceImpl(this.firestore);

  CollectionReference get _col => firestore.collection('users');

  @override
  Future<UserModel> getById(String uid) async {
    final doc = await _col.doc(uid).get();
    if (!doc.exists) throw ServerFailure('Usuário não encontrado');
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  @override
  Future<UserModel> create(UserModel user) async {
    await _col.doc(user.id).set(user.toMap());
    return user;
  }

  @override
  Future<UserModel> update(UserModel user) async {
    await _col.doc(user.id).update(user.toMap());
    return user;
  }

  @override
  Stream<UserModel> watchById(String uid) {
    return _col.doc(uid).snapshots().map((snap) {
      if (!snap.exists) throw ServerFailure('Usuário não encontrado');
      return UserModel.fromMap(snap.data() as Map<String, dynamic>, snap.id);
    });
  }
}
