import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

/// Repositório de autenticação. Amplify é a fonte única de sessão.
abstract class AuthRepository {
  /// Retorna o usuário atual se houver sessão válida. Null se não autenticado.
  Future<UserEntity?> getCurrentUser();

  /// Encerra a sessão.
  Future<void> logout();

  /// Retorna o access token JWT para uso em APIs. Null se não autenticado.
  Future<String?> getAccessToken();
}
