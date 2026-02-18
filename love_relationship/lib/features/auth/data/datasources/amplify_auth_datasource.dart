import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/data/datasources/auth_datasource.dart';
import 'package:love_relationship/features/auth/data/models/user_model.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class AmplifyAuthDatasource implements AuthDatasource {
  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
            AuthUserAttributeKey.name: name,
          },
        ),
      );

      // Cognito com verificação de email: isSignUpComplete = false até confirmar
      // O usuário foi criado com sucesso; deve verificar o e-mail
      if (!result.isSignUpComplete) {
        throw AuthFailure(
          AuthErrorType.emailConfirmationRequired,
          message: 'Verifique seu e-mail para confirmar a conta',
        );
      }

      final userId = result.userId;
      if (userId == null) throw AuthFailure(AuthErrorType.unauthenticated);

      return UserModel(id: userId, name: name, email: email);
    } on AuthException catch (e) {
      _mapAuthException(e);
    } catch (e) {
      throw AuthFailure(AuthErrorType.unknown, message: 'Ocorreu um erro ao criar a conta. Tente novamente.');
    }
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return _doLogin(email, password, retryAfterSignOut: false);
  }

  Future<UserEntity> _doLogin(
    String email,
    String password, {
    required bool retryAfterSignOut,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      // Usar nextStep.signInStep para verificar conclusão do login
      final step = result.nextStep.signInStep;
      if (step != AuthSignInStep.done) {
        switch (step) {
          case AuthSignInStep.confirmSignUp:
            throw AuthFailure(
              AuthErrorType.emailConfirmationRequired,
              message: 'Confirme seu e-mail antes de fazer login',
            );
          case AuthSignInStep.resetPassword:
            throw AuthFailure(
              AuthErrorType.wrongPassword,
              message: 'É necessário redefinir sua senha. Use "Esqueci a senha".',
            );
          default:
            throw AuthFailure(
              AuthErrorType.emailConfirmationRequired,
              message: 'Complete a verificação antes de fazer login',
            );
        }
      }

      final user = await Amplify.Auth.getCurrentUser();
      final userId = user.userId;

      final attrs = await Amplify.Auth.fetchUserAttributes();
      final emailAttr = attrs
          .where((a) => a.userAttributeKey == AuthUserAttributeKey.email)
          .firstOrNull;
      final nameAttr = attrs
          .where((a) => a.userAttributeKey == AuthUserAttributeKey.name)
          .firstOrNull;

      return UserModel(
        id: userId,
        name: nameAttr?.value ?? email.split('@').first,
        email: emailAttr?.value ?? email,
      );
    } on InvalidStateException catch (e) {
      // "A user is already signed in" -> desconectar e tentar novamente
      if (!retryAfterSignOut &&
          e.message.contains('A user is already signed in')) {
        await Amplify.Auth.signOut();
        return _doLogin(email, password, retryAfterSignOut: true);
      }
      _mapAuthException(e);
    } on AuthException catch (e) {
      _mapAuthException(e);
    } catch (e) {
      throw AuthFailure(
        AuthErrorType.unknown,
        message: 'Ocorreu um erro ao fazer login. Tente novamente.',
      );
    }
  }

  @override
  Future<void> logout() async {
    await Amplify.Auth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final attrs = await Amplify.Auth.fetchUserAttributes();
      final emailAttr = attrs
          .where((a) => a.userAttributeKey == AuthUserAttributeKey.email)
          .firstOrNull;
      final nameAttr = attrs
          .where((a) => a.userAttributeKey == AuthUserAttributeKey.name)
          .firstOrNull;
      return UserModel(
        id: user.userId,
        name: nameAttr?.value ?? '',
        email: emailAttr?.value ?? '',
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final session = await cognitoPlugin.fetchAuthSession();
      final tokens = session.userPoolTokensResult.value;
      return tokens.accessToken.raw;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
    } on AuthException catch (e) {
      _mapAuthException(e);
    } catch (e) {
      throw ServerFailure(ServerErrorType.unknown);
    }
  }

  @override
  Future<void> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: code,
      );
    } on AuthException catch (e) {
      _mapAuthException(e);
    } catch (e) {
      throw ServerFailure(ServerErrorType.unknown);
    }
  }

  Never _mapAuthException(AuthException e) {
    final msg = e.message;
    // Verificar tipo de exceção primeiro (Amplify usa subclasses)
    if (e is AuthNotAuthorizedException) {
      throw AuthFailure(AuthErrorType.wrongPassword, message: 'Senha incorreta');
    }
    // Fallback: verificar mensagem
    if (msg.contains('UserNotFoundException') ||
        msg.contains('user-not-found') ||
        msg.contains('User does not exist')) {
      throw AuthFailure(AuthErrorType.userNotFound, message: 'Usuário não encontrado');
    }
    if (msg.contains('UserNotConfirmedException') ||
        msg.contains('User is not confirmed')) {
      throw AuthFailure(
        AuthErrorType.emailConfirmationRequired,
        message: 'Confirme seu e-mail antes de fazer login',
      );
    }
    if (msg.contains('InvalidParameterException') ||
        msg.contains('invalid-email')) {
      throw AuthFailure(AuthErrorType.invalidEmail, message: 'Email inválido');
    }
    if (msg.contains('NotAuthorizedException') ||
        msg.contains('wrong-password') ||
        msg.contains('Incorrect username') ||
        msg.contains('Incorrect password')) {
      throw AuthFailure(AuthErrorType.wrongPassword, message: 'Senha incorreta');
    }
    if (msg.contains('UsernameExistsException') ||
        msg.contains('email-already-in-use')) {
      throw AuthFailure(AuthErrorType.emailAlreadyInUse, message: 'Este email já está em uso');
    }
    if (msg.contains('CodeMismatchException') ||
        msg.contains('Invalid verification code') ||
        msg.contains('code mismatch')) {
      throw AuthFailure(
        AuthErrorType.invalidConfirmationCode,
        message: 'Código inválido ou expirado. Solicite um novo código.',
      );
    }
    if (msg.contains('ExpiredCodeException') || msg.contains('expired')) {
      throw AuthFailure(
        AuthErrorType.invalidConfirmationCode,
        message: 'Código expirado. Solicite um novo código.',
      );
    }
    if (msg.contains('NetworkException') || msg.contains('network')) {
      throw ServerFailure(ServerErrorType.network, message: 'Problemas de conexão. Tente novamente.');
    }
    throw AuthFailure(AuthErrorType.unknown, message: e.message);
  }
}
