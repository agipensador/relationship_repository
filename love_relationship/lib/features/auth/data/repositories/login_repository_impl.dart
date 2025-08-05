import 'package:dartz/dartz.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:love_relationship/features/auth/domain/entities/user.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository{
  final AuthFirebaseDatasource datasource;
  LoginRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, User>> loginWithEmail(String email, String password)async {
    try{
      final user = await datasource.loginWithEmail(email, password);
      return Right(
        User(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName,
        ),
      );
    } on AuthFailure catch (e) {
      return Left(e); // erro já tratado no datasource
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: ${e.toString()}'));
    }
  }
}