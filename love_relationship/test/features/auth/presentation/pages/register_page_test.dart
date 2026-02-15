import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_relationship/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/register/register_state.dart';
import 'package:love_relationship/features/auth/presentation/pages/register_page.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterBloc extends Mock implements RegisterBloc {}

void main(){
  late MockRegisterBloc mockRegisterBloc;

  setUp(() {
    mockRegisterBloc = MockRegisterBloc();
    when(() => mockRegisterBloc.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<RegisterBloc>(
        create: (_) => mockRegisterBloc,
        child: Scaffold(body: const RegisterPage()),
      ),
    );
  }

  testWidgets('Renderização de RegisterPage', (tester) async {

    when(() => mockRegisterBloc.state).thenReturn(const RegisterState());
    when(() => mockRegisterBloc.stream)
        .thenAnswer((_) => Stream.value(const RegisterState()));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('register_button')), findsOneWidget);
    expect(find.text('Criar Conta'), findsAtLeastNWidgets(1));
    expect(find.text('Voltar'), findsOneWidget);
  });
}