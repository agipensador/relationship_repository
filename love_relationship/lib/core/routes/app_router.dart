import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/register_cubit.dart';
import 'package:love_relationship/features/auth/presentation/pages/login_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/register_page.dart';

import '../../features/auth/presentation/pages/home_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case '/':
      case '/login':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<LoginCubit>(),
              child: const LoginPage(),
            ),
          );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<RegisterCubit>(),
            child: const RegisterPage(),
          ),
        );
      case '/home':
        final user = settings.arguments as UserEntity;
        return MaterialPageRoute(
        builder: (_) => HomePage(user: user),
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
