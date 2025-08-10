import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/presentation/cubit/edit_user_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/register_cubit.dart';
import 'package:love_relationship/features/auth/presentation/pages/edit_user_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/home_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/login_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/register_page.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
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
      final user = settings.arguments as UserEntity; // vindo da Home
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<EditUserCubit>()..prefill(user), // joga nome atual
          child: EditUserPage(userEntity: user),
        ),
      );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}
