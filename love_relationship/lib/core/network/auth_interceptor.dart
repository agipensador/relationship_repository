import 'package:dio/dio.dart';
import 'package:love_relationship/features/auth/domain/repositories/auth_repository.dart';

/// Interceptor que adiciona o token JWT no header Authorization.
class AuthInterceptor extends Interceptor {
  final AuthRepository authRepository;

  AuthInterceptor(this.authRepository);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await authRepository.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Ignora erro ao obter token
    }
    handler.next(options);
  }
}
