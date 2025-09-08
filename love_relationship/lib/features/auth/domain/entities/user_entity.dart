import 'package:love_relationship/features/auth/domain/entities/premium_tier.dart';

class UserEntity {
  final String id;
  final String email;
  final String? name;
  final PremiumTier tier;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.tier = PremiumTier.none,
  });

  bool get isPremium => tier.isPremium;

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    PremiumTier? tier,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      tier: tier ?? this.tier,
    );
  }
}
