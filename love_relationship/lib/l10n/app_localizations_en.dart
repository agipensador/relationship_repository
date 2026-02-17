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
  String get emailSentForgotPassword => 'Email sent to';

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

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get wrongPassword => 'Incorrect password';

  @override
  String get emailConfirmationRequired => 'Check your email to confirm your account';

  @override
  String get loginTitle => 'Login';

  @override
  String get invalidConfirmationCode => 'Invalid or expired code. Please request a new one.';

  @override
  String get checkSpam => 'If you don\'t find the email, check your spam folder.';

  @override
  String get passwordResetSuccess => 'Password changed successfully!';

  @override
  String get send => 'Send';

  @override
  String get enterCodeAndNewPassword => 'Enter the code received by email and set your new password.';

  @override
  String get confirmationCodeHint => 'Verification code';

  @override
  String get newPasswordHint => 'New password';

  @override
  String get confirmPasswordHint => 'Confirm new password';

  @override
  String get confirmPasswordReset => 'Change password';

  @override
  String get invalidPasswordFormat => 'Password must have: minimum 8 characters, uppercase letter, lowercase letter, special character and number.';

  @override
  String get passwordRequirementMinLength => 'Minimum 8 characters';

  @override
  String get passwordRequirementUppercase => 'Uppercase letter';

  @override
  String get passwordRequirementLowercase => 'Lowercase letter';

  @override
  String get passwordRequirementSpecial => 'Special character';

  @override
  String get passwordRequirementNumber => 'Number';
}
