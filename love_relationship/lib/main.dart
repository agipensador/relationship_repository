import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/theme/app_theme.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'core/routes/app_router.dart';
import 'di/injection_container.dart';
import 'package:love_relationship/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init(); // injeção com GetIt
  print('GetIt registrations: ${sl.allReadySync()}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Always About Love - A2',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppStrings.loginRoute,
    );
  }
}
