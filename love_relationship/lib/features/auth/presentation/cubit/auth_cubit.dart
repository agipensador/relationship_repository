import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/usecases/logout_usecase.dart';

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

class AuthCubit extends Cubit<AuthState> {
  final LogoutUsecase logoutUsecase;

  AuthCubit(this.logoutUsecase) : super(const AuthState());

  Future<void> logout() async {
    emit(state.copyWith(isLoggingOut: true, error: null, loggedOut: false));
    try {
      await logoutUsecase();
      emit(const AuthState(isLoggingOut: false, loggedOut: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoggingOut: false,
          error: e.toString(),
          loggedOut: false,
        ),
      );
    }
  }
}
