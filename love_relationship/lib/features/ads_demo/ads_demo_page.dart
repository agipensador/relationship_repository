import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:love_relationship/core/ads/ad_ids.dart';
import 'package:love_relationship/core/ads/premium_cubit.dart';
import 'package:love_relationship/core/ads/repositories/ads_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.I;

class AdsDemoPage extends StatefulWidget {
  const AdsDemoPage({super.key});

  @override
  State<AdsDemoPage> createState() => _AdsDemoPageState();
}

class _AdsDemoPageState extends State<AdsDemoPage> {
  BannerAd? _bannerTop;
  BannerAd? _bannerBottom;
  int _rewardClicks = 0;

  @override
  void initState() {
    super.initState();
    _loadCounters();
    _prepareAds();
  }

  Future<void> _loadCounters() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() => _rewardClicks = sharedPrefs.getInt('reward_clicks') ?? 0);
  }

  Future<void> _incRewardClicks() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    _rewardClicks++;
    await sharedPrefs.setInt('reward_clicks', _rewardClicks);
    setState(() {});
  }

  Future<void> _prepareAds() async {
    final premium = sl<PremiumCubit>().state.isPremium;
    if (premium) return;

    final ids = sl<AdIds>();
    final ads = sl<AdsRepository>();

    // carrega banners
    _bannerTop = await ads.loadBanner(ids.bannerTopHome, adSize: AdSize.banner);
    _bannerBottom = await ads.loadBanner(
      ids.bannerBottomHome,
      adSize: AdSize.banner,
    );

    // prepara intersticial / rewards
    await ads.loadInterstitial(ids.interstitialHome);
    await ads.loadRewarded(ids.reward);

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bannerTop?.dispose();
    _bannerBottom?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ids = sl<AdIds>();
    final adsRepository = sl<AdsRepository>();

    return Scaffold(
      body: BlocBuilder<PremiumCubit, PremiumState>(
        buildWhen: (previous, current) =>
            previous.isPremium != current.isPremium,
        builder: (context, premiumState) {
          final isPremium = premiumState.isPremium;

          return SafeArea(
            child: Column(
              children: [
                //switch Premium global
                ListTile(
                  title: const Text('Usuário Premium'),
                  trailing: Switch(
                    value: isPremium,
                    onChanged: (value) async {
                      await context.read<PremiumCubit>().set(value);
                      // saiu do premium -> pode preparar (carregar) anúncios
                      if (!value) {
                        await _prepareAds(); // Se desativar premium, carrega anuncios
                      }
                      // virou premium -> limpe e oculte anúncios
                      _bannerTop?.dispose();
                      _bannerTop = null;
                      _bannerBottom?.dispose();
                      _bannerBottom = null;
                      // setState(() {}); // força atualizar
                    },
                  ),
                ),

                // Banner Top
                // SE FOR O ÚNICO AD NA PÁGINA
                BlocBuilder<PremiumCubit, PremiumState>(
                  builder: (context, state) {
                    if (state.isPremium) return const SizedBox.shrink();
                    return Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: _bannerTop?.size.height.toDouble() ?? 0,
                      child: _bannerTop == null
                          ? const SizedBox.shrink()
                          : AdWidget(ad: _bannerTop!),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Botões
                //SE TIVER MAIS
                if (!isPremium)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Reward
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: adsRepository.isRewardedReady
                                ? () async {
                                    final ok = await adsRepository.showRewarded(
                                      onRewarded: (ad, reward) async {
                                        await _incRewardClicks();
                                        // Aqui pode dar créditos, liberar feature, premiações...
                                      },
                                    );
                                    // Recarrega para a próxima
                                    await adsRepository.loadRewarded(
                                      ids.reward,
                                    );
                                  }
                                : null,
                            child: Text('Awarded $_rewardClicks'),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Interstitial
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: adsRepository.isInterstitialReady
                                ? () async {
                                    await adsRepository.showInterstitial();
                                    await adsRepository.loadInterstitial(
                                      ids.interstitialHome,
                                    );
                                  }
                                : null,
                            child: const Text('Intersticial'),
                          ),
                        ),

                        // Banner Bottom
                        if (!isPremium)
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            height: _bannerBottom?.size.height.toDouble() ?? 0,
                            child: _bannerBottom == null
                                ? const SizedBox.shrink()
                                : AdWidget(ad: _bannerBottom!),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
