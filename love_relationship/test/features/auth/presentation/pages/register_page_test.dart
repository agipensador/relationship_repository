import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_relationship/features/auth/presentation/cubit/register_cubit.dart';
import 'package:love_relationship/features/auth/presentation/pages/register_page.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterCubit extends Mock implements RegisterCubit {}

void main(){
  late MockRegisterCubit mockRegisterCubit;

  setUp((){
    mockRegisterCubit = MockRegisterCubit();  
    when(() => mockRegisterCubit.close()).thenAnswer((_) async {});
  });

    Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<RegisterCubit>(
        create: (_) => mockRegisterCubit,
        child: Scaffold(body: const RegisterPage()),
      ),
    );
  }

  testWidgets('Renderização de RegisterPage', (tester) async {

      when(() => mockRegisterCubit.state).thenReturn(RegisterInitial());
      when(() => mockRegisterCubit.stream)
      .thenAnswer((_) => Stream.value(RegisterInitial()));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('register_button')), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
    expect(find.text('Voltar'), findsOneWidget);
  });
}