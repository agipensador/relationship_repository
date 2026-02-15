# Como criar/alterar entre flavors

Este guia explica como os flavors (dev, qa, prod) funcionam e como criar ou alterar configurações por ambiente.

## Flavors disponíveis

| Flavor | Uso | Entry point |
|--------|-----|-------------|
| `dev` | Desenvolvimento local | `main_dev.dart` |
| `qa` | Homologação / testes | `main_qa.dart` |
| `prod` | Produção | `main_prd.dart` |

## Como rodar cada ambiente

```bash
# DEV
flutter run --flavor dev --target lib/main_dev.dart

# QA
flutter run --flavor qa --target lib/main_qa.dart

# PROD (release)
flutter run --flavor prod --target lib/main_prd.dart --release
```

Ou use os scripts na pasta `scripts/`:

```bash
./scripts/run_dev.sh
./scripts/run_qa.sh
./scripts/run_prod.sh
```

## Onde configurar

### 1. URLs da API (`lib/core/config/app_config.dart`)

A base URL é definida em `_getBaseUrl()`:

```dart
static String _getBaseUrl(AppFlavor flavor) {
  switch (flavor) {
    case AppFlavor.dev:
      return 'http://localhost:3000';
    case AppFlavor.qa:
      return 'https://api-qa.example.com';
    case AppFlavor.prod:
      return 'https://api.example.com';
  }
}
```

### 2. API Keys e outros valores

Use `_getApiKey()` ou crie novos métodos em `AppConfig` para valores que variam por ambiente.

### 3. Timeouts

`connectionTimeout` e `receiveTimeout` já variam por flavor em `AppConfig`.

## Adicionar um novo flavor

1. **Enum** – Adicione em `AppFlavor` em `app_config.dart`:

```dart
enum AppFlavor {
  dev,
  qa,
  prod,
  staging,  // novo
}
```

2. **Implemente** – Adicione os casos nos `switch` de `name`, `bundleIdSuffix`, `displayName`, `_getBaseUrl`, `_getApiKey`, etc.

3. **Entry point** – Crie `main_staging.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize(AppFlavor.staging);
  await mainCommon();
}
```

4. **Android** – Adicione o flavor em `android/app/build.gradle.kts`:

```kotlin
create("staging") {
  dimension = "environment"
  applicationIdSuffix = ".staging"
  versionNameSuffix = "-staging"
  resValue("string", "app_name", "Love Relationship (Staging)")
}
```

5. **iOS/macOS** – Os schemes `dev`, `qa` e `prod` já estão configurados. Para macOS, as build configurations (Debug-dev, Release-dev, etc.) e o Podfile já foram ajustados.

## Fluxo de inicialização

1. `main_dev.dart` (ou qa/prd) chama `AppConfig.initialize(AppFlavor.dev)`
2. `AppConfig` define `baseUrl`, `apiKey`, etc. conforme o flavor
3. `mainCommon()` é executado (Firebase, GetIt, etc.)
4. `NetworkModule` usa `AppConfig.instance.baseUrl` ao criar o `RestClient`

## Erro "The Xcode project does not define custom schemes"

Se você viu esse erro ao rodar com `--flavor`, significa que os schemes ainda não estavam configurados. O projeto já inclui:

- **macOS**: schemes `dev`, `qa`, `prod` com build configurations (Debug-dev, Release-dev, etc.)
- **iOS**: schemes `dev`, `qa`, `prod` em `ios/Runner.xcodeproj/xcshareddata/xcschemes/`

Para iOS, pode ser necessário adicionar as build configurations manualmente no Xcode (duplicar Debug/Release/Profile e nomear como Debug-dev, Release-dev, etc.) e atualizar o `ios/Podfile` da mesma forma que o `macos/Podfile`.

## Verificar o flavor atual

```dart
final flavor = AppConfig.instance.flavor;
final isDev = AppConfig.instance.isDev;
final baseUrl = AppConfig.instance.baseUrl;
```
