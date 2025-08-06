import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository{
  final AuthDatasource datasource;
  LoginRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail(String email, String password)async {
    try{
      final user = await datasource.login(email: email, password: password);
      return Right(user);
    } on AuthFailure catch (e) {
      return Left(e); // erro já tratado no datasource
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: ${e.toString()}'));
    }
  }


  @override
  Future<Either<Failure, UserEntity>> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await datasource.register(email: email, password: password, name: name);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Erro ao registrar usuário: $e'));
    }
  }
}