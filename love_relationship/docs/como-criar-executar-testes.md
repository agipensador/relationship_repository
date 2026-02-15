# Como criar e executar testes

Este guia explica como criar e executar testes no projeto Love Relationship.

## Executar testes

### Todos os testes

```bash
fvm flutter test
```

### Um arquivo específico

```bash
fvm flutter test test/widget_test.dart
fvm flutter test test/core/config/app_config_flavor_test.dart
```

### Um teste específico (por nome)

```bash
fvm flutter test --name "MyApp carrega"
```

### Com cobertura

```bash
fvm flutter test --coverage
```

O relatório de cobertura será gerado em `coverage/lcov.info`. Para visualizar:

```bash
# Instalar lcov (macOS: brew install lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Estrutura de testes

```
test/
├── widget_test.dart              # Teste do app principal (MyApp)
├── mocks/                        # Mocks reutilizáveis
│   ├── mock_storage_service.dart
│   └── mock_notification_service.dart
├── core/
│   └── config/
│       └── app_config_flavor_test.dart   # Teste de verificação de flavor
└── features/
    └── auth/
        └── presentation/
            └── pages/
                ├── login_page_test.dart
                └── register_page_test.dart
```

## Tipos de teste

### 1. Widget test (`testWidgets`)

Testa widgets e interações de UI.

```dart
testWidgets('descrição do teste', (WidgetTester tester) async {
  await tester.pumpWidget(MeuWidget());
  await tester.pumpAndSettle();

  expect(find.byKey(Key('meu_botao')), findsOneWidget);
  await tester.tap(find.byKey(Key('meu_botao')));
  await tester.pump();
});
```

### 2. Unit test (`test`)

Testa lógica isolada, sem UI.

```dart
test('descrição do teste', () {
  final resultado = minhaFuncao(entrada);
  expect(resultado, valorEsperado);
});
```

### 3. Teste com mocks (Mocktail)

Para isolar dependências:

```dart
class MockMeuServico extends Mock implements MeuServico {}

setUp(() {
  mockServico = MockMeuServico();
  when(() => mockServico.metodo(any())).thenAnswer((_) async => resultado);
  sl.registerSingleton<MeuServico>(mockServico);
});
```

## Como criar um novo teste

### 1. Widget test para uma página

1. Crie o arquivo em `test/features/<feature>/presentation/pages/<pagina>_test.dart`
2. Crie mocks necessários em `test/mocks/`
3. Use o padrão do `login_page_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMeuCubit extends Mock implements MeuCubit {}

void main() {
  late MockMeuCubit mockCubit;

  setUp(() {
    mockCubit = MockMeuCubit();
    when(() => mockCubit.state).thenReturn(EstadoInicial());
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(EstadoInicial()));
  });

  testWidgets('Minha página renderiza corretamente', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<MeuCubit>.value(
          value: mockCubit,
          child: const MinhaPagina(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MinhaPagina), findsOneWidget);
  });
}
```

### 2. Unit test para lógica/config

1. Crie o arquivo em `test/core/<modulo>/<arquivo>_test.dart` ou espelhando a estrutura de `lib/`
2. Exemplo (inspirado em `app_config_flavor_test.dart`):

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MeuModulo', () {
    test('comportamento esperado', () {
      // Arrange
      final entrada = ...;

      // Act
      final resultado = funcao(entrada);

      // Assert
      expect(resultado, valorEsperado);
    });
  });
}
```

### 3. Teste do app principal

O `widget_test.dart` testa o MyApp carregando a tela de login. Requer:

- `AppConfig.initialize(flavor)` antes de buildar
- Mocks em GetIt: `LoginCubit`, `StorageService`, `NotificationService`

## Boas práticas

1. **Nomenclatura**: `test/<caminho>/<nome>_test.dart` (ex: `login_page_test.dart`)
2. **Descrições claras**: Use frases que descrevam o comportamento esperado
3. **Mocks**: Centralize em `test/mocks/` para reutilizar
4. **Setup/Teardown**: Use `setUp` e `tearDown` para preparar e limpar estado
5. **Keys**: Use `Key` em widgets importantes para facilitar `find.byKey()`

## Testes existentes

| Arquivo | O que testa |
|---------|-------------|
| `widget_test.dart` | MyApp carrega e exibe a tela de login |
| `app_config_flavor_test.dart` | Configuração por flavor (dev, qa, prod) |
| `login_page_test.dart` | Renderização da página de login |
| `register_page_test.dart` | Renderização da página de registro |
