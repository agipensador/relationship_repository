import 'package:love_relationship/features/auth/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getById(String uid);
  Future<UserModel> create(UserModel user);
  Future<UserModel> update(UserModel user);
  Stream<UserModel> watchById(String uid);
}
