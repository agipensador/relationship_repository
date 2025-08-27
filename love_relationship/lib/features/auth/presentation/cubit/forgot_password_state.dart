import 'package:equatable/equatable.dart';
import 'package:love_relationship/core/error/failure.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final bool loading;
  final bool sent; // sucesso
  final Failure? error;

  const ForgotPasswordState({
    this.email = '',
    this.loading = false,
    this.sent = false,
    this.error,
  });

  factory ForgotPasswordState.initial() => const ForgotPasswordState();

  ForgotPasswordState copyWith({
    String? email,
    bool? loading,
    bool? sent,
    Failure? error,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      loading: loading ?? this.loading,
      sent: sent ?? this.sent,
      error: error,
    );
  }

  @override
  List<Object?> get props => [email, loading, sent, error];
}
