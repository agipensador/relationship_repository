import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Disparado ao iniciar o app (bootstrap). Verifica sessão no Amplify.
final class AuthAppStarted extends AuthEvent {
  const AuthAppStarted();
}

/// Disparado quando o usuário solicita logout.
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
