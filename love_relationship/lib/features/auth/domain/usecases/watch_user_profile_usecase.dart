import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/user_repository.dart';

class WatchUserProfileUsecase {
  final UserRepository userRepository;
  WatchUserProfileUsecase(this.userRepository);

  Stream<Either<Failure, UserEntity>> call(String uid) => userRepository.watchById(uid);

  }