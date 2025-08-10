import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getById(String uid);
  Future<Either<Failure, UserEntity>> create(UserEntity user);
  Future<Either<Failure, UserEntity>> update(UserEntity user);
  Stream<Either<Failure, UserEntity>> watchById(String uid);
}