import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity?> getCurrentUser() => datasource.getCurrentUser();

  @override
  Future<void> logout() => datasource.logout();

  @override
  Future<String?> getAccessToken() => datasource.getAccessToken();
}
