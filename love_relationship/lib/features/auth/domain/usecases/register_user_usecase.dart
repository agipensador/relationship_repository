import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';

class RegisterUserUsecase {
  final LoginRepository loginRepository;

  RegisterUserUsecase(this.loginRepository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await loginRepository.registerUser(email: email, password: password, name: name);
  }
}
