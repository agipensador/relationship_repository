import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

abstract class AuthDatasource {
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({required String email, required String password, required String name});
}