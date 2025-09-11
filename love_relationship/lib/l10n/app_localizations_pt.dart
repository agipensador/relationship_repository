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
  String get invalidEmail => 'O e-mail informado está errado';

  @override
  String get wrongPassword => 'A senha informada está errada';

  @override
  String get loginTitle => 'Login';
}
