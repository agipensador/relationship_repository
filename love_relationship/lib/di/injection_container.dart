import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:love_relationship/core/ads/ad_ids.dart';
import 'package:love_relationship/core/network/network_module.dart';
import 'package:love_relationship/core/network/rest_api.dart';
import 'package:love_relationship/core/ads/ads_service.dart';
import 'package:love_relationship/core/ads/bloc/premium_bloc.dart';
import 'package:love_relationship/core/ads/bloc/premium_event.dart';
import 'package:love_relationship/core/ads/repositories/ads_repository.dart';
import 'package:love_relationship/core/notifications/notification_service.dart';
import 'package:love_relationship/core/services/auth_session.dart';
import 'package:love_relationship/core/services/storage_service.dart';
import 'package:love_relationship/core/services/stub_storage_service.dart';
import 'package:love_relationship/core/services/amplify_auth_session.dart';

// AUTH (login/register)
import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/data/datasources/amplify_auth_datasource.dart';
import 'package:love_relationship/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:love_relationship/features/auth/domain/repositories/auth_repository.dart';
import 'package:love_relationship/features/auth/domain/usecases/check_auth_session_usecase.dart';
import 'package:love_relationship/features/auth/data/datasources/cognito_user_remote_datasource.dart';
import 'package:love_relationship/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:love_relationship/features/auth/data/repositories/login_repository_impl.dart';
import 'package:love_relationship/features/auth/domain/repositories/login_repository.dart';
import 'package:love_relationship/features/auth/domain/usecases/confirm_reset_password_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/login_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/logout_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:love_relationship/features/auth/data/repositories/user_repository_impl.dart';
import 'package:love_relationship/features/auth/domain/repositories/user_repository.dart';
import 'package:love_relationship/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/watch_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/home/home_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_bloc.dart';
import 'package:love_relationship/features/chat/data/repositories/chat_partner_name_repository_impl.dart';
import 'package:love_relationship/features/chat/domain/repositories/chat_partner_name_repository.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_bloc.dart';
import 'package:love_relationship/features/games/domain/usecases/get_games_usecase.dart';
import 'package:love_relationship/features/games/presentation/bloc/games_bloc.dart';
import 'package:love_relationship/features/notifications/data/repositories/stub_notification_repository.dart';
import 'package:love_relationship/features/notifications/domain/repositories/notification_repository.dart';
import 'package:love_relationship/features/notifications/domain/usecases/subscribe_topic_usecase.dart';
import 'package:love_relationship/features/notifications/domain/usecases/sync_fcm_token_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ========= DATASOURCES =========
  if (!sl.isRegistered<AuthDatasource>()) {
    sl.registerLazySingleton<AuthDatasource>(() => AmplifyAuthDatasource());
  }

  // ========= AUTH REPOSITORY =========
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthDatasource>()),
    );
  }

  // ========= NETWORK (Dio + Retrofit) =========
  NetworkModule.configureAuth(sl<AuthRepository>());
  if (!sl.isRegistered<RestClient>()) {
    sl.registerLazySingleton<RestClient>(
      () => NetworkModule.getRestClientInstance(),
    );
  }

  // ========= SERVICES =========
  if (!sl.isRegistered<StorageService>()) {
    sl.registerLazySingleton<StorageService>(() => StubStorageService());
  }

  if (!sl.isRegistered<UserRemoteDataSource>()) {
    sl.registerLazySingleton<UserRemoteDataSource>(
      () => CognitoUserRemoteDataSource(),
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
    sl.registerLazySingleton<AuthSession>(() => AmplifyAuthSession());
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
  if (!sl.isRegistered<ChatPartnerNameRepository>()) {
    sl.registerLazySingleton<ChatPartnerNameRepository>(
      () => ChatPartnerNameRepositoryImpl(),
    );
  }
  if (!sl.isRegistered<CheckAuthSessionUseCase>()) {
    sl.registerLazySingleton<CheckAuthSessionUseCase>(
      () => CheckAuthSessionUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<LogoutUsecase>()) {
    sl.registerLazySingleton(() => LogoutUsecase(sl<AuthRepository>()));
  }

  // ========= BLOCS =========
  if (!sl.isRegistered<RegisterBloc>()) {
    sl.registerFactory<RegisterBloc>(
      () => RegisterBloc(sl<RegisterUserUsecase>()),
    );
  }
  if (!sl.isRegistered<HomeBloc>()) {
    sl.registerFactory<HomeBloc>(
      () => HomeBloc(
        sl<GetUserProfileUsecase>(),
        sl<WatchUserProfileUsecase>(),
        sl<AuthSession>(),
      ),
    );
  }
  if (!sl.isRegistered<EditUserBloc>()) {
    sl.registerFactory<EditUserBloc>(
      () => EditUserBloc(
        sl<AuthSession>(),
        sl<GetUserProfileUsecase>(),
        sl<UpdateUserProfileUsecase>(),
      ),
    );
  }
  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory(() => AuthBloc(
          sl<CheckAuthSessionUseCase>(),
          sl<LogoutUsecase>(),
        ));
  }

  if (!sl.isRegistered<ForgotPasswordUseCase>()) {
    sl.registerLazySingleton(
      () => ForgotPasswordUseCase(sl<LoginRepository>()),
    );
  }
  if (!sl.isRegistered<ConfirmResetPasswordUseCase>()) {
    sl.registerLazySingleton(
      () => ConfirmResetPasswordUseCase(sl<LoginRepository>()),
    );
  }

  if (!sl.isRegistered<ForgotPasswordBloc>()) {
    sl.registerFactory(() => ForgotPasswordBloc(
          sl<ForgotPasswordUseCase>(),
          sl<ConfirmResetPasswordUseCase>(),
        ));
  }

  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
  sl.registerLazySingleton(() => NotificationService(sl()));

  sl.registerLazySingleton<NotificationRepository>(
    () => StubNotificationRepository(),
  );

  sl.registerLazySingleton(
    () => SyncFcmTokenUseCase(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton(
    () => SubscribeTopicUseCase(sl<NotificationRepository>()),
  );

  sl.registerFactory(
    () => LoginBloc(
      sl<LoginUseCase>(),
      sl<SyncFcmTokenUseCase>(),
      sl<SubscribeTopicUseCase>(),
    ),
  );

  sl.registerLazySingleton(() => GetGamesUsecase());
  sl.registerFactory(() => GamesBloc(sl()));

  sl.registerFactory(() => ChatBloc(
        sl<AuthSession>(),
        sl<GetUserProfileUsecase>(),
        sl<ChatPartnerNameRepository>(),
      ));
  sl.registerFactory(() => ChatMenuBloc());

  // ADS
  sl.registerLazySingleton<AdIds>(() => AdIdsProd());
  sl.registerLazySingleton<AdsRepository>(() => AdsService());
  await sl<AdsRepository>().init();

  // PREMIUM
  sl.registerSingleton<PremiumBloc>(
    PremiumBloc(sl<UserRepository>(), sl<AuthSession>())
      ..add(const PremiumLoadRequested()),
  );
}
