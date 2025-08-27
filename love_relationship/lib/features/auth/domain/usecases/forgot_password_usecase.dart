import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';

class ForgotPasswordUseCase {
  final LoginRepository repository;
  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) {
    return repository.forgotPassword(email);
  }
}
