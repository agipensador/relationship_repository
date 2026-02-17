// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get btnAccess => 'Entrar';

  @override
  String get btnRegister => 'Sign up';

  @override
  String get createAccount => 'Criar Conta';

  @override
  String get back => 'Voltar';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Senha';

  @override
  String get emailSentForgotPassword => 'Email enviado para';

  @override
  String get forgotPassword => 'Esqueci a senha';

  @override
  String get nameHint => 'Nome';

  @override
  String get welcome => 'Bem vindo';

  @override
  String get editUser => 'Editar Usuário';

  @override
  String get save => 'Salvar';

  @override
  String get editNameHint => 'Editar Nome';

  @override
  String get savedSuccess => 'Salvo com sucesso';

  @override
  String get saveError => 'Erro ao salvar';

  @override
  String get userNotFound => 'Usuário não encontrado';

  @override
  String get createUserError => 'Erro ao criar usuário';

  @override
  String get unauthenticatedUser => 'Usuário não autenticado';

  @override
  String get errorRegisteringUser => 'Erro ao registrar usuário';

  @override
  String get serverError => 'Ops, erro em nosso serviço. Tente novamente';

  @override
  String get serverErrorNetwork => 'Ops, problemas de conexão com internet';

  @override
  String get serverErrorTimeout => 'Ops, tempo de resposta excedido...';

  @override
  String get serverErrorUpdateUser => 'Erro ao atualizar usuário';

  @override
  String get invalidCredentials => 'Credenciais inválidas';

  @override
  String get invalidEmail => 'Email inválido';

  @override
  String get wrongPassword => 'Senha incorreta';

  @override
  String get emailConfirmationRequired => 'Verifique seu e-mail para confirmar a conta';

  @override
  String get loginTitle => 'Login';

  @override
  String get invalidConfirmationCode => 'Código inválido ou expirado. Solicite um novo código.';

  @override
  String get checkSpam => 'Caso não encontre o e-mail, verifique a caixa de spam.';

  @override
  String get passwordResetSuccess => 'Senha alterada com sucesso!';

  @override
  String get send => 'Enviar';

  @override
  String get enterCodeAndNewPassword => 'Informe o código recebido por e-mail e defina sua nova senha.';

  @override
  String get confirmationCodeHint => 'Código de verificação';

  @override
  String get newPasswordHint => 'Nova senha';

  @override
  String get confirmPasswordHint => 'Confirmar nova senha';

  @override
  String get confirmPasswordReset => 'Alterar senha';

  @override
  String get invalidPasswordFormat => 'A senha deve ter: mínimo 8 caracteres, letra maiúscula, letra minúscula, caractere especial e número.';

  @override
  String get passwordRequirementMinLength => 'Mínimo 8 caracteres';

  @override
  String get passwordRequirementUppercase => 'Letra maiúscula';

  @override
  String get passwordRequirementLowercase => 'Letra minúscula';

  @override
  String get passwordRequirementSpecial => 'Caractere especial';

  @override
  String get passwordRequirementNumber => 'Número';
}
