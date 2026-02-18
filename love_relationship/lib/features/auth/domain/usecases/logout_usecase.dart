import 'package:love_relationship/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository authRepository;
  LogoutUsecase(this.authRepository);

  Future<void> call() async {
    return authRepository.logout();
  }
}
