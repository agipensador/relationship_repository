import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:love_relationship/core/config/app_config.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/notifications/fcm_background_handler.dart';
import 'package:love_relationship/core/notifications/notification_service.dart';
import 'package:love_relationship/core/theme/app_theme.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:love_relationship/firebase_options.dart';

import 'core/routes/app_router.dart';
import 'di/injection_container.dart';

/// Inicialização comum para todos os flavors (dev, qa, prod)
Future<void> mainCommon() async {
  try {
    if (kDebugMode) {
      debugPrint('[mainCommon] Inicializando Firebase Core...');
      debugPrint('[mainCommon] Flavor atual: ${AppConfig.instance.flavor.name}');
    }
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Registra handler para mensagens em background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if (kDebugMode) {
      debugPrint('[mainCommon] Firebase Core inicializado com sucesso');
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('[mainCommon] Erro ao inicializar Firebase: $e');
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
      initialRoute: AppStrings.loginRoute,
    );
  }
}
