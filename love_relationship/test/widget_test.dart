import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_relationship/core/config/app_config.dart';
import 'package:love_relationship/core/notifications/notification_service.dart';
import 'package:love_relationship/core/services/storage_service.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_state.dart';
import 'package:love_relationship/main_common.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/mock_notification_service.dart';
import 'mocks/mock_storage_service.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

void main() {
  late MockLoginBloc mockLoginBloc;
  late MockStorageService mockStorageService;
  late MockNotificationService mockNotificationService;

  setUpAll(() {
    registerFallbackValue(LoginState.initial());
  });

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    mockStorageService = MockStorageService();
    mockNotificationService = MockNotificationService();

    when(() => mockLoginBloc.close()).thenAnswer((_) async {});
    when(() => mockLoginBloc.state).thenReturn(LoginState.initial());
    when(() => mockLoginBloc.stream)
        .thenAnswer((_) => Stream.value(LoginState.initial()));

    when(() => mockStorageService.getImageUrl(any())).thenAnswer((_) async => '');
    when(() => mockNotificationService.requestPermissions())
        .thenAnswer((_) async {});

    if (sl.isRegistered<LoginBloc>()) {
      sl.unregister<LoginBloc>();
    }
    if (sl.isRegistered<StorageService>()) {
      sl.unregister<StorageService>();
    }
    if (sl.isRegistered<NotificationService>()) {
      sl.unregister<NotificationService>();
    }

    sl.registerFactory<LoginBloc>(() => mockLoginBloc);
    sl.registerSingleton<StorageService>(mockStorageService);
    sl.registerSingleton<NotificationService>(mockNotificationService);
  });

  tearDown(() async {
    if (sl.isRegistered<LoginBloc>()) {
      await sl.unregister<LoginBloc>();
    }
  });

  testWidgets('MyApp carrega e exibe a tela de login', (tester) async {
    AppConfig.initialize(AppFlavor.dev);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_button')), findsOneWidget);
  });
}
