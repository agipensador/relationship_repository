import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:love_relationship/core/ads/repositories/ads_repository.dart';

class AdsService implements AdsRepository {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  @override
  Future<void> init() async {
    await MobileAds.instance.initialize();
    // Opcional: configure requestConfiguration (test devices)
    // await MobileAds.instance.updateRequestConfiguration(
    //   RequestConfiguration(testDeviceIds: ['YOUR_TEST_DEVICE_ID']),
    // );
  }

  // BANNER
  @override
  Future<BannerAd?> loadBanner(
    String adUnitId, {
    AdSize adSize = AdSize.banner,
  }) async {
    final completer = Completer<BannerAd?>();
    final ad = BannerAd(
      size: adSize,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) => completer.complete(ad as BannerAd),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          completer.complete(null);
        },
      ),
      request: const AdRequest(),
    )..load();
    return completer.future;
  }

  // INTERSTICIAL
  @override
  Future<void> loadInterstitial(String adUnitId) async {
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  @override
  bool get isInterstitialReady => _interstitialAd != null;

  @override
  Future<bool> showInterstitial() async {
    final ad = _interstitialAd;

    if (ad == null) return false;
    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        completer.complete(false);
      },
    );
    ad.show();
    return completer.future;
  }

  // REWARD
  @override
  Future<void> loadRewarded(String adUnitId) async {
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => _rewardedAd = null,
      ),
    );
  }

  @override
  bool get isRewardedReady => _rewardedAd != null;

  @override
  Future<bool> showRewarded({
    required void Function(AdWithoutView ad, RewardItem reward) onRewarded,
  }) async {
    final ad = _rewardedAd;
    if (ad == null) return false;
    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        completer.complete(false);
      },
    );
    ad.show(onUserEarnedReward: onRewarded);
    return completer.future;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
