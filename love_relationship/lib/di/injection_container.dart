import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:love_relationship/features/auth/data/repositories/login_repository_impl.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';
import 'package:love_relationship/features/auth/domain/usecases/login_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/register_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async{
  // Cubit
  sl.registerFactory(() => LoginCubit(sl()));

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUsecase(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));
  sl.registerFactory(() => RegisterCubit(sl()));

  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // Datasource
  // sl.registerLazySingleton<AuthDatasource>(() => FirebaseAuthDatasource(sl()));
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<AuthDatasource>(
    () => FirebaseAuthDatasource(
      sl<FirebaseAuth>(), 
      sl<FirebaseFirestore>(),
    ),
  );
}

