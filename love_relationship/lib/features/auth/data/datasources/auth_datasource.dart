import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

abstract class AuthDatasource {
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logout();

  /// Retorna o usuário atual se houver sessão. Null se não autenticado.
  Future<UserEntity?> getCurrentUser();

  /// Retorna o access token JWT. Null se não autenticado.
  Future<String?> getAccessToken();

  Future<void> forgotPassword(String email);

  Future<void> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
