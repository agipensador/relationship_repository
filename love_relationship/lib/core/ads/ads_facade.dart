import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:love_relationship/core/ads/repositories/ads_repository.dart';
import 'premium_cubit.dart';

final sl = GetIt.I;

class AdsFacade {
  final AdsRepository _ads;
  final PremiumCubit _premium;

  AdsFacade(this._ads, this._premium);

  bool get _isPremium => _premium.state.isPremium;

  /// Tenta exibir interstitial:
  /// - se premium -> false
  /// - se não pronto -> tenta carregar e exibir
  /// - recarrega após exibir
  Future<bool> maybeShowInterstitial(String adUnitId) async {
    if (_isPremium) return false;

    if (!_ads.isInterstitialReady) {
      await _ads.loadInterstitial(adUnitId);
    }
    final shown = await _ads.showInterstitial();
    if (shown) {
      // prepara próxima
      await _ads.loadInterstitial(adUnitId);
    }
    return shown;
  }

  /// Tenta exibir rewarded e dispara callback quando ganhar a recompensa.
  Future<bool> maybeShowRewarded(
    String adUnitId, {
    required Future<void> Function(AdWithoutView ad, RewardItem reward)
    onRewarded,
  }) async {
    if (_isPremium) return false;

    if (!_ads.isRewardedReady) {
      await _ads.loadRewarded(adUnitId);
    }
    final shown = await _ads.showRewarded(onRewarded: onRewarded);
    if (shown) {
      await _ads.loadRewarded(adUnitId);
    }
    return shown;
  }
}
