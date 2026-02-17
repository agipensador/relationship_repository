import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:love_relationship/features/auth/data/models/user_model.dart';
import 'package:love_relationship/features/auth/domain/entities/premium_tier.dart';

/// Datasource de perfil de usuário usando atributos do Cognito.
/// O atributo custom:tier deve estar configurado no User Pool para premium.
class CognitoUserRemoteDataSource implements UserRemoteDataSource {
  static const _tierKey = CognitoUserAttributeKey.custom('tier');

  Future<AuthUser> _getCurrentUser() async {
    return Amplify.Auth.getCurrentUser();
  }

  Future<List<AuthUserAttribute>> _fetchAttrs() async {
    return Amplify.Auth.fetchUserAttributes();
  }

  String? _attr(List<AuthUserAttribute> attrs, AuthUserAttributeKey key) {
    return attrs.where((a) => a.userAttributeKey == key).firstOrNull?.value;
  }

  @override
  Future<UserModel> getById(String uid) async {
    final user = await _getCurrentUser();
    if (user.userId != uid) {
      if (kDebugMode) {
        debugPrint(
            '[CognitoUserRemoteDataSource] getById($uid): usuário diferente do atual');
      }
      throw ServerFailure(
        ServerErrorType.unknown,
        message: 'Usuário não encontrado',
      );
    }
    final attrs = await _fetchAttrs();
    return UserModel(
      id: user.userId,
      name: _attr(attrs, AuthUserAttributeKey.name) ?? '',
      email: _attr(attrs, AuthUserAttributeKey.email) ?? '',
      tier: PremiumTierX.fromString(_attr(attrs, _tierKey)),
    );
  }

  @override
  Future<UserModel> create(UserModel user) async {
    // No Cognito o usuário já existe após sign up. Apenas garantir atributos.
    return update(user);
  }

  @override
  Future<UserModel> update(UserModel user) async {
    final current = await _getCurrentUser();
    if (current.userId != user.id) {
      throw ServerFailure(ServerErrorType.updateUserError);
    }

    await Amplify.Auth.updateUserAttribute(
      userAttributeKey: AuthUserAttributeKey.name,
      value: user.name ?? '',
    );

    // custom:tier - requer permissão no App Client do Cognito
    try {
      await Amplify.Auth.updateUserAttribute(
        userAttributeKey: _tierKey,
        value: user.tier.asString,
      );
    } catch (_) {
      // Se custom:tier não existir, ignora
    }

    return getById(user.id);
  }

  @override
  Stream<UserModel> watchById(String uid) async* {
    // Cognito não tem real-time como Firestore. Emite estado atual.
    // Para atualizações em tempo real, usar API Gateway + subscriptions no futuro.
    yield await getById(uid);
  }
}
