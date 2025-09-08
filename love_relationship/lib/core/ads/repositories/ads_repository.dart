import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdsRepository {
  Future<void> init();

  // Banners
  Future<BannerAd?> loadBanner(String adUnitID, {AdSize adSize});

  // Interstitial
  Future<void> loadInterstitial(String adUnitId);
  bool get isInterstitialReady;
  Future<bool> showInterstitial();

  // Rewarded
  Future<void> loadRewarded(String adUnitId);
  bool get isRewardedReady;
  Future<bool> showRewarded({
    required void Function(AdWithoutView, RewardItem) onRewarded,
  });

  // Limpeza (opcional)
  void dispose();
}
