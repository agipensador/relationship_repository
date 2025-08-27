import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/navigation/app_shell.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/edit_user_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/register_cubit.dart';
import 'package:love_relationship/features/auth/presentation/pages/edit_user_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/home_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/login_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/register_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case AppStrings.loginRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<LoginCubit>(),
            child: const LoginPage(),
          ),
        );
      case AppStrings.registerRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<RegisterCubit>(),
            child: const RegisterPage(),
          ),
        );
      case AppStrings.homeRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<HomeCubit>()..loadCurrentUser(),
            child: const HomePage(),
          ),
        );
      case AppStrings.editUserRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<EditUserCubit>()..load()),
              BlocProvider(create: (_) => sl<AuthCubit>()), // <— aqui
            ],
            child: const EditUserPage(),
          ),
        );
      case AppStrings.forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ForgotPasswordCubit>(),
            child: const ForgotPasswordPage(),
          ),
        );

      case AppStrings.shellRoute:
        return MaterialPageRoute(builder: (_) => const AppShell());
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
