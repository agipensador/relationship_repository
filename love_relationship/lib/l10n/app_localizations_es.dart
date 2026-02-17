// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get btnAccess => 'Iniciar sesión';

  @override
  String get btnRegister => 'Sign up';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get back => 'Volver';

  @override
  String get emailHint => 'Correo';

  @override
  String get passwordHint => 'Contraseña';

  @override
  String get emailSentForgotPassword => 'Correo electrónico enviado a';

  @override
  String get forgotPassword => 'Has olvidado tu contraseña';

  @override
  String get nameHint => 'Nombre';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get editUser => 'Editar usuario';

  @override
  String get save => 'Guardar';

  @override
  String get editNameHint => 'Editar nombre';

  @override
  String get savedSuccess => 'Guardado con éxito';

  @override
  String get saveError => 'Error al guardar';

  @override
  String get userNotFound => 'Usuario no encontrado';

  @override
  String get createUserError => 'Error al crear usuario';

  @override
  String get unauthenticatedUser => 'Usuario no autenticado';

  @override
  String get errorRegisteringUser => 'Error al registrar usuario';

  @override
  String get serverError => 'Oops, error con nuestro servicio. Inténtalo de nuevo';

  @override
  String get serverErrorNetwork => 'Ups, problemas de conexión a Internet';

  @override
  String get serverErrorTimeout => 'Ups, tiempo de respuesta excedido...';

  @override
  String get serverErrorUpdateUser => 'Error al actualizar usuario';

  @override
  String get invalidCredentials => 'Credenciales no válidas';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get wrongPassword => 'Incorrect password';

  @override
  String get emailConfirmationRequired => 'Check your email to confirm your account';

  @override
  String get loginTitle => 'Login';

  @override
  String get invalidConfirmationCode => 'Código inválido o expirado. Solicite uno nuevo.';

  @override
  String get checkSpam => 'Si no encuentra el correo, revise la carpeta de spam.';

  @override
  String get passwordResetSuccess => '¡Contraseña cambiada con éxito!';

  @override
  String get send => 'Enviar';

  @override
  String get enterCodeAndNewPassword => 'Ingrese el código recibido por correo y establezca su nueva contraseña.';

  @override
  String get confirmationCodeHint => 'Código de verificación';

  @override
  String get newPasswordHint => 'Nueva contraseña';

  @override
  String get confirmPasswordHint => 'Confirmar nueva contraseña';

  @override
  String get confirmPasswordReset => 'Cambiar contraseña';

  @override
  String get invalidPasswordFormat => 'La contraseña debe tener: mínimo 8 caracteres, letra mayúscula, letra minúscula, carácter especial y número.';

  @override
  String get passwordRequirementMinLength => 'Mínimo 8 caracteres';

  @override
  String get passwordRequirementUppercase => 'Letra mayúscula';

  @override
  String get passwordRequirementLowercase => 'Letra minúscula';

  @override
  String get passwordRequirementSpecial => 'Carácter especial';

  @override
  String get passwordRequirementNumber => 'Número';
}
