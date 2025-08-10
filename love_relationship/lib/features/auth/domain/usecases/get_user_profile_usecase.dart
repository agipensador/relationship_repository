import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/user_repository.dart';

class GetUserProfileUsecase {
  final UserRepository userRepository;
  GetUserProfileUsecase(this.userRepository);

  Future<Either<Failure, UserEntity>> call(String uid) => userRepository.getById(uid);
}