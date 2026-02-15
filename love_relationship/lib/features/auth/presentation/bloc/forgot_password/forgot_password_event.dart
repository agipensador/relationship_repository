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
