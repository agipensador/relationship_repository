import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:love_relationship/core/ads/ad_ids.dart';
import 'package:love_relationship/core/ads/ads_service.dart';
import 'package:love_relationship/core/ads/premium_cubit.dart';
import 'package:love_relationship/core/ads/repositories/ads_repository.dart';
import 'package:love_relationship/core/notifications/notification_service.dart';
import 'package:love_relationship/core/services/auth_session.dart';

// Services
import 'package:love_relationship/core/services/storage_service.dart';
import 'package:love_relationship/core/services/firebase_storage_service.dart';

// AUTH (login/register)
import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:love_relationship/features/auth/data/repositories/login_repository_impl.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';
import 'package:love_relationship/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/login_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/logout_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:love_relationship/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/forgot_password_cubit.dart';
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
import 'package:love_relationship/features/games/domain/usecases/get_games_usecase.dart';
import 'package:love_relationship/features/games/presentation/cubit/games_cubit.dart';
import 'package:love_relationship/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:love_relationship/features/notifications/domain/repositories/notification_repository.dart';
import 'package:love_relationship/features/notifications/domain/usecases/subscribe_topic_usecase.dart';
import 'package:love_relationship/features/notifications/domain/usecases/sync_fcm_token_usecase.dart';

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

  // UseCase
  if (!sl.isRegistered<ForgotPasswordUseCase>()) {
    sl.registerLazySingleton(
      () => ForgotPasswordUseCase(sl<LoginRepository>()),
    );
  }

  // Cubit
  if (!sl.isRegistered<ForgotPasswordCubit>()) {
    sl.registerFactory(() => ForgotPasswordCubit(sl<ForgotPasswordUseCase>()));
  }

  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // await sl<NotificationService>().init();
  sl.registerLazySingleton(() => NotificationService(sl(), sl()));

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      sl<FirebaseMessaging>(),
      sl<FirebaseFirestore>(),
      sl<fb.FirebaseAuth>(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(
    () => SyncFcmTokenUseCase(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton(
    () => SubscribeTopicUseCase(sl<NotificationRepository>()),
  );

  // Cubit
  sl.registerFactory(
    () => LoginCubit(
      sl<LoginUseCase>(),
      sl<SyncFcmTokenUseCase>(),
      sl<SubscribeTopicUseCase>(),
    ),
  );

  // USE CASE
  sl.registerLazySingleton(() => GetGamesUsecase());

  // CUBIT
  sl.registerFactory(() => GamesCubit(sl()));

  // ADS
  // IDs (dev/prod)
  sl.registerLazySingleton<AdIds>(() => AdIdsProd());

  // Ads repo (SDK)
  sl.registerLazySingleton<AdsRepository>(() => AdsService());
  await sl<AdsRepository>().init();

  // PREMIUM
  sl.registerSingleton<PremiumCubit>(
    PremiumCubit(sl<UserRepository>(), sl<fb.FirebaseAuth>())..load(),
  );
}
