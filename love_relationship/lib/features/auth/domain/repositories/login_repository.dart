import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> loginWithEmail(String email, String senha);
}