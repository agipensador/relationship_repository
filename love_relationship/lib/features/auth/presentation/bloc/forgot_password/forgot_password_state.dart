import 'package:equatable/equatable.dart';
import 'package:love_relationship/core/error/failure.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final String code;
  final String newPassword;
  final String confirmPassword;
  final bool loading;
  final bool sent;
  final bool passwordReset;
  final Failure? error;

  const ForgotPasswordState({
    this.email = '',
    this.code = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.loading = false,
    this.sent = false,
    this.passwordReset = false,
    this.error,
  });

  factory ForgotPasswordState.initial() => const ForgotPasswordState();

  ForgotPasswordState copyWith({
    String? email,
    String? code,
    String? newPassword,
    String? confirmPassword,
    bool? loading,
    bool? sent,
    bool? passwordReset,
    Failure? error,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      loading: loading ?? this.loading,
      sent: sent ?? this.sent,
      passwordReset: passwordReset ?? this.passwordReset,
      error: error,
    );
  }

  @override
  List<Object?> get props => [email, code, newPassword, confirmPassword, loading, sent, passwordReset, error];
}
