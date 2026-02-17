import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:love_relationship/core/config/app_config.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/notifications/notification_service.dart';
import 'package:love_relationship/core/theme/app_theme.dart';
import 'package:love_relationship/l10n/app_localizations.dart';

import 'core/routes/app_router.dart';
import 'di/injection_container.dart';

Future<void> _configureAmplify() async {
  final configJson = await rootBundle.loadString('amplify_outputs.json');
  await Amplify.addPlugin(AmplifyAuthCognito());
  await Amplify.configure(configJson);
}

/// Inicialização comum para todos os flavors (dev, qa, prod)
Future<void> mainCommon() async {
  try {
    if (kDebugMode) {
      debugPrint('[mainCommon] Inicializando Amplify...');
      debugPrint('[mainCommon] Flavor atual: ${AppConfig.instance.flavor.name}');
    }
    await _configureAmplify();
    if (kDebugMode) {
      debugPrint('[mainCommon] Amplify inicializado com sucesso');
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('[mainCommon] Erro ao inicializar Amplify: $e');
      debugPrint('[mainCommon] Stack trace: $stackTrace');
    }
  }

  await init();

  await sl<NotificationService>().initCore();
  if (kDebugMode) {
    debugPrint('GetIt registrations: ${sl.allReadySync()}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: config.appName,
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppStrings.splashRoute,
    );
  }
}
