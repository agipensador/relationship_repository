class AuthState {
  final bool isLoggingOut;
  final bool loggedOut;
  final String? error;

  const AuthState({
    this.isLoggingOut = false,
    this.loggedOut = false,
    this.error,
  });

  AuthState copyWith({bool? isLoggingOut, bool? loggedOut, String? error}) {
    return AuthState(
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      loggedOut: loggedOut ?? this.loggedOut,
      error: error,
    );
  }
}
