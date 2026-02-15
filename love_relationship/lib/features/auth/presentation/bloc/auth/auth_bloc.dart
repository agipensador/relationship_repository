import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/usecases/logout_usecase.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogoutUsecase logoutUsecase;

  AuthBloc(this.logoutUsecase) : super(const AuthState()) {
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoggingOut: true, error: null, loggedOut: false));
    try {
      await logoutUsecase();
      emit(const AuthState(isLoggingOut: false, loggedOut: true));
    } catch (e) {
      emit(state.copyWith(
        isLoggingOut: false,
        error: e.toString(),
        loggedOut: false,
      ));
    }
  }
}
