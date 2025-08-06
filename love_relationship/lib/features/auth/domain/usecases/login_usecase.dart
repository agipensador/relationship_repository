import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String senha){
    return repository.loginWithEmail(email, senha);
  }

}