import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';

class LogoutUsecase {
  final LoginRepository loginRepository;
  LogoutUsecase(this.loginRepository);

  Future<void> call() async {
    return await loginRepository.logout();
  }
}
