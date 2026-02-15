# love_relationship

Relationship is always about love.

## Como rodar o projeto

O projeto usa **FVM** e **flavors** (dev, qa, prod). Use os comandos abaixo na raiz do projeto (mesmo nível do `pubspec.yaml`).

### Android

```bash
# DEV (use -d emulator-5554 se -d android não encontrar o emulador)
fvm flutter run --flavor dev --target lib/main_dev.dart -d android

# QA
fvm flutter run --flavor qa --target lib/main_qa.dart -d android

# PROD (release)
fvm flutter run --flavor prod --target lib/main_prd.dart -d android --release
```

### iOS

```bash
# DEV
fvm flutter run --flavor dev --target lib/main_dev.dart -d ios

# QA
fvm flutter run --flavor qa --target lib/main_qa.dart -d ios

# PROD (release)
fvm flutter run --flavor prod --target lib/main_prd.dart -d ios --release
```

### macOS

```bash
# DEV
fvm flutter run --flavor dev --target lib/main_dev.dart -d macos
```

