// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get btnAccess => 'Log in';

  @override
  String get btnRegister => 'Sign up';

  @override
  String get createAccount => 'Create account';

  @override
  String get back => 'Back';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get nameHint => 'Name';

  @override
  String get welcome => 'Welcome';

  @override
  String get editUser => 'Edit user';

  @override
  String get save => 'Save';

  @override
  String get editNameHint => 'Edit name';

  @override
  String get savedSuccess => 'Saved successfully';

  @override
  String get saveError => 'Error saving';

  @override
  String get userNotFound => 'User not found';

  @override
  String get createUserError => 'Error creating user';

  @override
  String get unauthenticatedUser => 'Unauthenticated user';

  @override
  String get errorRegisteringUser => 'Error registering user';

  @override
  String get serverError => 'Oops, there was an error with our service. Please try again';

  @override
  String get serverErrorNetwork => 'Oops, internet connection problems';

  @override
  String get serverErrorTimeout => 'Oops, response time exceeded...';

  @override
  String get serverErrorUpdateUser => 'Error updating user';

  @override
  String get invalidCredentials => 'Invalid Credentials';
}
