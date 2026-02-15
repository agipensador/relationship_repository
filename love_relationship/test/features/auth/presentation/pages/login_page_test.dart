import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_relationship/core/notifications/notification_service.dart';
import 'package:love_relationship/core/services/storage_service.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_state.dart';
import 'package:love_relationship/features/auth/presentation/pages/login_page.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mock_notification_service.dart';
import '../../../../mocks/mock_storage_service.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

void main() {
  late LoginBloc mockLoginBloc;
  final mockStorageService = MockStorageService();
  final mockNotificationService = MockNotificationService();

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    when(() => mockLoginBloc.close()).thenAnswer((_) async {});
    when(() => mockStorageService.getImageUrl(any())).thenAnswer((_) async => '');
    when(() => mockNotificationService.requestPermissions()).thenAnswer((_) async {});

    if (sl.isRegistered<NotificationService>()) {
      sl.unregister<NotificationService>();
    }
    sl.registerSingleton<StorageService>(mockStorageService);
    sl.registerSingleton<NotificationService>(mockNotificationService);
  });

  Future<Widget> createWidgetUnderTest() async {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<LoginBloc>.value(
        value: mockLoginBloc,
        child: const Scaffold(body: LoginPage()),
      ),
    );
  }

  testWidgets('Renderização de LoginPage', (tester) async {
    when(() => mockLoginBloc.state).thenReturn(LoginState.initial());
    when(() => mockLoginBloc.stream)
        .thenAnswer((_) => Stream.value(LoginState.initial()));

    final widget = await createWidgetUnderTest(); // aguarda o Future<Widget>
    await tester.pumpWidget(widget); // agora é Widget
    // await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_button')), findsOneWidget);
    // expect(find.text(AppStrings.btnAccess), findsOneWidget);
    // expect(find.text(AppStrings.btnRegister), findsOneWidget);
    // expect(find.byType(AuthTextField), findsNWidgets(2));
    // expect(find.byType(PrimaryButton), findsNWidgets(1));
    // expect(find.byType(SecondaryButton), findsNWidgets(1));

  });
}