import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/edit_user_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/register_cubit.dart';
import 'package:love_relationship/features/auth/presentation/pages/edit_user_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/home_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/register_page.dart';
import 'package:love_relationship/features/games/presentation/cubit/games_cubit.dart';
import 'package:love_relationship/features/games/presentation/pages/games_page.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PersistentTabView(
      tabs: [
        // HOME
        PersistentTabConfig(
          screen: BlocProvider(
            create: (_) => sl<HomeCubit>()..loadCurrentUser(),
            child: const HomePage(),
          ),
          item: ItemConfig(
            icon: const Icon(Icons.home_outlined),
            title: 'Home', // crie l10n.homeTitle se preferir
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grayDefault,
          ),
        ),
        // GAMES
        PersistentTabConfig(
          screen: BlocProvider(
            create: (_) => sl<GamesCubit>(),
            child: const GamesPage(),
          ),
          item: ItemConfig(
            icon: const Icon(Icons.videogame_asset_outlined),
            title: 'Games',
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grayDefault,
          ),
        ),
        // ADICIONAR PESSOA
        PersistentTabConfig(
          screen: BlocProvider(
            create: (_) => sl<RegisterCubit>(),
            child: const RegisterPage(),
          ),
          item: ItemConfig(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            title: l10n.btnRegister,
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grayDefault,
          ),
        ),
        // EDITAR
        PersistentTabConfig(
          screen: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<EditUserCubit>()..load()),
              BlocProvider(create: (_) => sl<AuthCubit>()),
            ],
            child: const EditUserPage(),
          ),
          item: ItemConfig(
            icon: const Icon(Icons.edit_outlined),
            title: l10n.editUser,
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grayDefault,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style12BottomNavBar(
        navBarConfig: navBarConfig,
        // Caso queira customizar cores é aqui:
        // navBarDecoration: ,
      ),
      // A lib já lida com back/stack por tab. Se quiser interceptar back:
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteDefault,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 200),
      ),
    );
  }
}
