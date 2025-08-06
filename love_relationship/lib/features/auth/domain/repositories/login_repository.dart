import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserEntity>> loginWithEmail(
    String email,
    String password);

  Future<Either<Failure, UserEntity>> registerUser({
    required String email,
    required String password,
    required String name,
  });
}