import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/usecases/check_auth_session_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/logout_usecase.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_status.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthSessionUseCase checkAuthSessionUseCase;
  final LogoutUsecase logoutUsecase;

  AuthBloc(this.checkAuthSessionUseCase, this.logoutUsecase)
      : super(const AuthState()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final user = await checkAuthSessionUseCase();
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          error: null,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          error: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      await logoutUsecase();
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        error: e.toString(),
      ));
    }
  }
}
