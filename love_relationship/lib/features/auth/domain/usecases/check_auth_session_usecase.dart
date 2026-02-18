import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/auth_repository.dart';

/// Verifica se existe sessão ativa no Amplify.
/// Retorna UserEntity? - null se não autenticado.
class CheckAuthSessionUseCase {
  final AuthRepository authRepository;

  CheckAuthSessionUseCase(this.authRepository);

  Future<UserEntity?> call() async {
    return authRepository.getCurrentUser();
  }
}
