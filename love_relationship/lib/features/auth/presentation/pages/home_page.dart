import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/ads/ad_ids.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/core/ads/repositories/ads_repository.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/notifications/notification_service.dart';
import 'package:love_relationship/features/auth/presentation/bloc/home/home_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/home/home_state.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ads = sl<AdsRepository>();
  final ids = sl<AdIds>();

  @override
  void initState() {
    super.initState();

    // ADS
    // final isPremium = sl<PremiumCubit>().state.isPremium;
    // if (!isPremium) {
    //   // sem await para não travar UI
    //   ads.loadInterstitial(ids.interstitialHome);
    //   ads.loadRewarded(ids.reward);
    // }
    // sl.registerLazySingleton<AdsFacade>(
    //   () => AdsFacade(sl<AdsRepository>(), sl<PremiumCubit>()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (prev, curr) => !prev.ready && curr.ready,
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.welcome)),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) return Center(child: Text(state.error!));
            final user = state.user;
            if (user == null) return Center(child: Text(l10n.userNotFound));

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lottie heartbeat above greeting
                  SizedBox(
                    height: 180,
                    child: Lottie.asset(
                      'assets/lottie/a2_logo.json',
                      repeat: true,
                      animate: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Olá, ${user.name}!'),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: l10n.editUser,
                    onPressed: () async {
                      Navigator.pushNamed(context, AppStrings.editUserRoute);
                    },
                  ),
                  SizedBox(height: 12),
                  PrimaryButton(
                    text: 'Testar Notificação Local',
                    onPressed: () async {
                      final ok = await sl<NotificationService>().showLocal(
                        title: 'Teste',
                        body: 'Local notification',
                      );
                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Falha ao exibir notificação'),
                          ),
                        );
                      }
                    },
                  ),
                  // ADS
                  // INTERSTICIAL EXEMPLO
                  // PrimaryButton(
                  //   text: 'Ir para EditUSer(INTERSTICIAL)',
                  //   onPressed: () async {
                  //     // tenta interstitial (não bloqueia a navegação se falhar)
                  //     await sl<AdsFacade>().maybeShowInterstitial(
                  //       sl<AdIds>().interstitialHome,
                  //     );

                  //     // segue o fluxo normal da sua tela
                  //     if (!mounted) return;
                  //     Navigator.pushNamed(context, AppStrings.editUserRoute);
                  //   },
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
