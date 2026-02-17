import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final AuthDatasource datasource;
  LoginRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      final user = await datasource.login(email: email, password: password);
      return Right(user);
    } on AuthFailure catch (e) {
      return Left(e); // erro já tratado no datasource
    } catch (e) {
      return Left(
        ServerFailure(ServerErrorType.unknown, message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await datasource.register(
        email: email,
        password: password,
        name: name,
      );
      return Right(user);
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure(ServerErrorType.createUserError, message: e.toString()),
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await datasource.logout();
    } catch (e) {
      // todo mapear failure
      rethrow; // podemos mapear pra Failure se quiser
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await datasource.forgotPassword(email);
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(ServerErrorType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await datasource.confirmResetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(ServerErrorType.unknown));
    }
  }
}
