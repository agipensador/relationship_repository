import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_relationship/core/services/storage_service.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_state.dart';
import 'package:love_relationship/features/auth/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mock_storage_service.dart';

class MockLoginCubit extends Mock implements LoginCubit {}

void main() {
  late LoginCubit mockLoginCubit;
  final mockStorageService = MockStorageService();

  setUp((){
    mockLoginCubit = MockLoginCubit();
    when(() => mockLoginCubit.close()).thenAnswer((_) async {});

    // Aqui apenas defino o Mock fake da imagem, para dar continuidade no auth_image_header
    when(() => mockStorageService.getImageUrl(any()))
      .thenAnswer((_) async => '');

    sl.registerSingleton<StorageService>(mockStorageService);

  });

  Future<Widget> createWidgetUnderTest()async{
  // Widget createWidgetUnderTest(){

    return MaterialApp(
      home: BlocProvider<LoginCubit>.value(
        value: mockLoginCubit,
        child:const Scaffold(body: LoginPage()),
      ),
    );
  }

  testWidgets('Renderização de LoginPage', (tester) async {
    when(() => mockLoginCubit.state).thenReturn(LoginState.initial());
    when(() => mockLoginCubit.stream)
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