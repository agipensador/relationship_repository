import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/ads_demo/ads_demo_page.dart' hide sl;
import 'package:love_relationship/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_event.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_bloc.dart';
import 'package:love_relationship/features/chat/presentation/pages/chat_page.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/home/home_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/home/home_event.dart';
import 'package:love_relationship/features/auth/presentation/pages/edit_user_page.dart';
import 'package:love_relationship/features/auth/presentation/pages/home_page.dart';
import 'package:love_relationship/features/games/presentation/bloc/games_bloc.dart';
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
            create: (_) => sl<HomeBloc>()..add(const HomeLoadCurrentUser()),
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
            create: (_) => sl<GamesBloc>(),
            child: const GamesPage(),
          ),
          item: ItemConfig(
            icon: const Icon(Icons.videogame_asset_outlined),
            title: 'Games',
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grayDefault,
          ),
        ),
        // ADS
        PersistentTabConfig(
          screen: const AdsDemoPage(),
          item: ItemConfig(
            icon: const Icon(Icons.abc),
            title: 'Ads',
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grayDefault,
          ),
        ),
        // CHAT (substitui Create account na bottom nav)
        PersistentTabConfig(
          screen: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<ChatBloc>()..add(const ChatLoadRequested()),
              ),
              BlocProvider(create: (_) => sl<ChatMenuBloc>()),
            ],
            child: const ChatPage(),
          ),
          item: ItemConfig(
            icon: const Icon(Icons.chat_bubble_outline),
            title: 'Chat',
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grayDefault,
          ),
        ),
        // EDITAR
        PersistentTabConfig(
          screen: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<EditUserBloc>()..add(const EditUserLoad())),
              BlocProvider(create: (_) => sl<AuthBloc>()),
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
