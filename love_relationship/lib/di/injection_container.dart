import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:love_relationship/core/services/auth_session.dart';

// Services
import 'package:love_relationship/core/services/storage_service.dart';
import 'package:love_relationship/core/services/firebase_storage_service.dart';

// AUTH (login/register)
import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:love_relationship/features/auth/data/repositories/login_repository_impl.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';
import 'package:love_relationship/features/auth/domain/usecases/login_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/logout_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:love_relationship/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/register_cubit.dart';

// USER (profile)
import 'package:love_relationship/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:love_relationship/features/auth/data/datasources/user_remote_datasource_impl.dart';
import 'package:love_relationship/features/auth/data/repositories/user_repository_impl.dart';
import 'package:love_relationship/features/auth/domain/repositories/user_repository.dart';
import 'package:love_relationship/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/watch_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/edit_user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ========= EXTERNOS =========
  if (!sl.isRegistered<fb.FirebaseAuth>()) {
    sl.registerLazySingleton<fb.FirebaseAuth>(() => fb.FirebaseAuth.instance);
  }
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }
  if (!sl.isRegistered<FirebaseStorage>()) {
    sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  }

  // ========= SERVICES =========
  if (!sl.isRegistered<StorageService>()) {
    sl.registerLazySingleton<StorageService>(
      () => FirebaseStorageService(sl<FirebaseStorage>()),
    );
  }

  // ========= DATASOURCES =========
  // Auth (email/senha, etc.)
  if (!sl.isRegistered<AuthDatasource>()) {
    sl.registerLazySingleton<AuthDatasource>(
      () => FirebaseAuthDatasource(
        sl<fb.FirebaseAuth>(),
        sl<FirebaseFirestore>(),
      ),
    );
  }
  // User profile (Firestore)
  if (!sl.isRegistered<UserRemoteDataSource>()) {
    sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl<FirebaseFirestore>()),
    );
  }

  // ========= REPOSITORIES =========
  if (!sl.isRegistered<LoginRepository>()) {
    sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(sl<AuthDatasource>()),
    );
  }
  if (!sl.isRegistered<UserRepository>()) {
    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(sl<UserRemoteDataSource>()),
    );
  }

  // ========= USECASES =========
  // Auth
  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<LoginRepository>()),
    );
  }
  if (!sl.isRegistered<RegisterUserUsecase>()) {
    sl.registerLazySingleton<RegisterUserUsecase>(
      () => RegisterUserUsecase(sl<LoginRepository>()),
    );
  }
  if (!sl.isRegistered<AuthSession>()) {
    sl.registerLazySingleton<AuthSession>(() => FirebaseAuthSession(sl()));
  }

  // User
  if (!sl.isRegistered<GetUserProfileUsecase>()) {
    sl.registerLazySingleton<GetUserProfileUsecase>(
      () => GetUserProfileUsecase(sl<UserRepository>()),
    );
  }
  if (!sl.isRegistered<WatchUserProfileUsecase>()) {
    sl.registerLazySingleton<WatchUserProfileUsecase>(
      () => WatchUserProfileUsecase(sl<UserRepository>()),
    );
  }
  if (!sl.isRegistered<UpdateUserProfileUsecase>()) {
    sl.registerLazySingleton<UpdateUserProfileUsecase>(
      () => UpdateUserProfileUsecase(sl<UserRepository>()),
    );
  }
  if (!sl.isRegistered<LogoutUsecase>()) {
    sl.registerLazySingleton(() => LogoutUsecase(sl<LoginRepository>()));
  }

  // ========= CUBITS =========
  if (!sl.isRegistered<LoginCubit>()) {
    sl.registerFactory<LoginCubit>(() => LoginCubit(sl<LoginUseCase>()));
  }
  if (!sl.isRegistered<RegisterCubit>()) {
    sl.registerFactory<RegisterCubit>(
      () => RegisterCubit(sl<RegisterUserUsecase>()),
    );
  }
  if (!sl.isRegistered<HomeCubit>()) {
    sl.registerFactory<HomeCubit>(
      () => HomeCubit(
        sl<GetUserProfileUsecase>(),
        sl<WatchUserProfileUsecase>(),
        sl<AuthSession>(),
      ),
    );
  }
  if (!sl.isRegistered<EditUserCubit>()) {
    sl.registerFactory<EditUserCubit>(
      () => EditUserCubit(
        sl<AuthSession>(),
        sl<GetUserProfileUsecase>(),
        sl<UpdateUserProfileUsecase>(),
      ),
    );
  }
  if (!sl.isRegistered<AuthCubit>()) {
    sl.registerFactory(() => AuthCubit(sl<LogoutUsecase>()));
  }
}
