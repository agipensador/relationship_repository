import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';

class ConfirmResetPasswordUseCase {
  final LoginRepository repository;
  ConfirmResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return repository.confirmResetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }
}
