import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_firebase_datasource_impl.dart';
import 'package:love_relationship/features/auth/data/repositories/login_repository_impl.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';
import 'package:love_relationship/features/auth/domain/usecases/login_usecase.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async{
  // Cubit
  sl.registerFactory(() => LoginCubit(sl()));

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // Datasource
  sl.registerLazySingleton<AuthFirebaseDatasource>(() => AuthFirebaseDatasourceImpl(sl()));

  }

