import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:love_relationship/features/auth/data/models/user_model.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, UserEntity>> getById(String uid) async {
    try {
      final model = await remote.getById(uid);
      return Right(model); // Model herda de Entity
    } catch (e) {
      // TODO CRIAR TIPO DE FALHA ESPECÍFICA SOBRE BUSCAR USUARIO
      return Left(
        ServerFailure(
          ServerErrorType.unknown,
          message: 'Falha ao buscar usuário',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> create(UserEntity user) async {
    try {
      final model = UserModel(
        id: user.id,
        name: user.name ?? '',
        email: user.email,
        tier: user.tier,
      );
      final created = await remote.create(model);
      return Right(created);
    } catch (e) {
      return Left(
        ServerFailure(
          ServerErrorType.createUserError,
          message: 'Falha ao criar usuário',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> update(UserEntity user) async {
    try {
      final model = UserModel(
        id: user.id,
        name: user.name ?? '',
        email: user.email,
        tier: user.tier,
      );
      final updated = await remote.update(model);
      return Right(updated);
    } catch (e) {
      return Left(
        ServerFailure(
          ServerErrorType.updateUserError,
          message: 'Falha ao atualizar usuário',
        ),
      );
    }
  }

  @override
  Stream<Either<Failure, UserEntity>> watchById(String uid) {
    return remote
        .watchById(uid)
        .map<Either<Failure, UserEntity>>(
          (model) => Right(model),
          // TODO CRIAR TIPO DE FALHA ESPECÍFICA SOBRE OBSERVAR USUARIO
        )
        .handleError(
          (e) => Left(
            ServerFailure(
              ServerErrorType.unknown,
              message: 'Falha ao observar usuário',
            ),
          ),
        );
  }
}
