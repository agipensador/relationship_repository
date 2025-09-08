import 'package:love_relationship/features/auth/domain/entities/premium_tier.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required String super.name,
    required super.email,
    super.tier = PremiumTier.none,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      tier: PremiumTierX.fromString(map['tier'] as String?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'tier': tier.asString,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Se quiser atualizar mantendo 'createdAt', pode ter um map parcial:
  Map<String, dynamic> toUpdateMap() {
    return {
      'name': name ?? '',
      'email': email,
      'tier': tier.asString,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
