import 'package:equatable/equatable.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class LoginState extends Equatable {
  final bool loading;
  final UserEntity? user;
  final Failure? error;
  final String email;
  final String password;

  const LoginState({
    this.loading = false,
    this.user,
    this.error,
    this.email = '',
    this.password = '',
  });

  factory LoginState.initial() => const LoginState();

  LoginState copyWith({
    UserEntity? user,
    bool? loading,
    Failure? error,
    String? email,
    String? password,
  }) {
    return LoginState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [loading, user, email, error, password];
}
