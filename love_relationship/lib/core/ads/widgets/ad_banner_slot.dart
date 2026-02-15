import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get_it/get_it.dart';
import 'package:love_relationship/core/ads/repositories/ads_repository.dart';
import 'package:love_relationship/core/ads/bloc/premium_bloc.dart';
import 'package:love_relationship/core/ads/bloc/premium_state.dart';

final sl = GetIt.I;

/// Widget de banner plug-and-play:
/// - Recebe o adUnitId (assim você troca o ID por página)
/// - Se premium: não carrega nem exibe
/// - Se não premium: carrega e exibe
class AdBannerSlot extends StatefulWidget {
  final String adUnitId;
  final AdSize size;
  final EdgeInsetsGeometry padding;

  const AdBannerSlot({
    super.key,
    required this.adUnitId,
    this.size = AdSize.banner,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<AdBannerSlot> createState() => _AdBannerSlotState();
}

class _AdBannerSlotState extends State<AdBannerSlot> {
  BannerAd? _ad;

  @override
  void initState() {
    super.initState();
    _maybeLoad();
  }

  Future<void> _maybeLoad() async {
    final isPremium = sl<PremiumBloc>().state.isPremium;
    if (isPremium) return; // não carrega

    final loaded = await sl<AdsRepository>().loadBanner(
      widget.adUnitId,
      adSize: widget.size,
    );
    if (!mounted) return;
    setState(() => _ad = loaded);
  }

  @override
  void didUpdateWidget(covariant AdBannerSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se o ID mudou (ou status premium mudou), recarrega
    if (oldWidget.adUnitId != widget.adUnitId) {
      _disposeAd();
      _maybeLoad();
    }
  }

  void _disposeAd() {
    _ad?.dispose();
    _ad = null;
  }

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumBloc, PremiumState>(
      buildWhen: (p, c) => p.isPremium != c.isPremium,
      builder: (context, state) {
        if (state.isPremium) {
          // garante não exibir (mesmo se já estava carregado)
          if (_ad != null) {
            _disposeAd();
          }
          return const SizedBox.shrink();
        }

        final height = _ad?.size.height.toDouble() ?? 0;
        if (height == 0) return const SizedBox.shrink();

        return Padding(
          padding: widget.padding,
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: _ad == null ? const SizedBox.shrink() : AdWidget(ad: _ad!),
          ),
        );
      },
    );
  }
}
