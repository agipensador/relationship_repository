import 'package:equatable/equatable.dart';
import 'package:love_relationship/features/auth/domain/entities/premium_tier.dart';

sealed class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object?> get props => [];
}

final class PremiumLoadRequested extends PremiumEvent {
  const PremiumLoadRequested();
}

final class PremiumSetTierRequested extends PremiumEvent {
  final PremiumTier tier;

  const PremiumSetTierRequested(this.tier);

  @override
  List<Object?> get props => [tier];
}
