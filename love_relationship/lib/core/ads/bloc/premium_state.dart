import 'package:love_relationship/features/auth/domain/entities/premium_tier.dart';

class PremiumState {
  final bool loading;
  final PremiumTier premiumTier;

  const PremiumState({
    this.loading = false,
    this.premiumTier = PremiumTier.none,
  });

  bool get isPremium => premiumTier.isPremium;

  PremiumState copyWith({bool? loading, PremiumTier? premiumTier}) =>
      PremiumState(
        loading: loading ?? this.loading,
        premiumTier: premiumTier ?? this.premiumTier,
      );
}
