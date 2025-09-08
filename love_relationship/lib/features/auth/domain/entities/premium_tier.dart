enum PremiumTier { none, gold, diamond }

extension PremiumTierX on PremiumTier {
  bool get isPremium => this == PremiumTier.gold || this == PremiumTier.diamond;
  String get asString => switch (this) {
    PremiumTier.none => 'none',
    PremiumTier.gold => 'gold',
    PremiumTier.diamond => 'diamond',
  };

  static PremiumTier fromString(String? s) {
    switch (s) {
      case 'gold':
        return PremiumTier.gold;
      case 'diamond':
        return PremiumTier.diamond;
      default:
        return PremiumTier.none;
    }
  }
}
