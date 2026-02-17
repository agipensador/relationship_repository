import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/ads/bloc/premium_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/navigation/app_shell.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/home/home_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/home/home_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:love_relationship/features/auth/presentation/pages/edit_user_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/home_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/login_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/register_page.dart';
import 'package:love_relationship/features/splash/presentation/pages/splash_page.dart';
import 'package:love_relationship/features/chat/presentation/pages/mensagem_futuro_page.dart';
import 'package:love_relationship/features/chat/presentation/pages/mensagem_proximidade_page.dart';
import 'package:love_relationship/features/games/presentation/bloc/games_bloc.dart';
import 'package:love_relationship/features/games/presentation/pages/games_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // SPLASH (inicial)
      case AppStrings.splashRoute:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      // LOGIN
      case AppStrings.loginRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<LoginBloc>(),
            child: const LoginPage(),
          ),
        );
      // REGISTRAR
      case AppStrings.registerRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<RegisterBloc>(),
            child: const RegisterPage(),
          ),
        );
      // HOME
      case AppStrings.homeRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<HomeBloc>()..add(const HomeLoadCurrentUser()),
            child: const HomePage(),
          ),
        );
      // EDITAR USUARIO
      case AppStrings.editUserRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<EditUserBloc>()..add(const EditUserLoad())),
              BlocProvider(create: (_) => sl<AuthBloc>()),
            ],
            child: const EditUserPage(),
          ),
        );
      // ESQUECI SENHA
      case AppStrings.forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ForgotPasswordBloc>(),
            child: const ForgotPasswordPage(),
          ),
        );
      // BOTTOM NAV
      case AppStrings.shellRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<PremiumBloc>.value(value: sl<PremiumBloc>()),
            ],
            child: AppShell(),
          ),
        );
      // CHAT MENU - Mensagem proximidade
      case AppStrings.chatMensagemProximidadeRoute:
        return MaterialPageRoute(
          builder: (_) => const MensagemProximidadePage(),
        );
      // CHAT MENU - Mensagem futuro
      case AppStrings.chatMensagemFuturoRoute:
        return MaterialPageRoute(
          builder: (_) => const MensagemFuturoPage(),
        );
      // GAMES
      case AppStrings.gamesRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<GamesBloc>(),
            child: const GamesPage(),
          ),
        );
      // SE ROTA NÃO ENCONTRADA
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text('Rota não encontrada, estamos trabalhando nisto!'),
                  SizedBox(height: 12),
                  Text('Volte para página anterior'),
                ],
              ),
            ),
          ),
        );
    }
  }
}
