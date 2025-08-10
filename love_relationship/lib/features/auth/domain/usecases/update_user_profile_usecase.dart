import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/user_repository.dart';

class UpdateUserProfileUsecase {
  final UserRepository userRepository;
  UpdateUserProfileUsecase(this.userRepository);

  Future<Either<Failure, UserEntity>> call(UserEntity user) => userRepository.update(user);
}