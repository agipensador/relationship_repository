import 'package:equatable/equatable.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;

  const ForgotPasswordEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

final class ForgotPasswordSendRequested extends ForgotPasswordEvent {
  const ForgotPasswordSendRequested();
}

final class ForgotPasswordCodeChanged extends ForgotPasswordEvent {
  final String code;

  const ForgotPasswordCodeChanged(this.code);

  @override
  List<Object?> get props => [code];
}

final class ForgotPasswordNewPasswordChanged extends ForgotPasswordEvent {
  final String newPassword;

  const ForgotPasswordNewPasswordChanged(this.newPassword);

  @override
  List<Object?> get props => [newPassword];
}

final class ForgotPasswordConfirmPasswordChanged extends ForgotPasswordEvent {
  final String confirmPassword;

  const ForgotPasswordConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

final class ForgotPasswordConfirmRequested extends ForgotPasswordEvent {
  const ForgotPasswordConfirmRequested();
}
