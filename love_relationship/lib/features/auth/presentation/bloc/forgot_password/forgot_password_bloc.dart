import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:love_relationship/features/auth/presentation/bloc/forgot_password/forgot_password_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase usecase;

  ForgotPasswordBloc(this.usecase) : super(ForgotPasswordState.initial()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSendRequested>(_onSendRequested);
  }

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(email: event.email, error: null, sent: false));
  }

  Future<void> _onSendRequested(
    ForgotPasswordSendRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final email = state.email.trim();
    if (email.isEmpty) {
      emit(state.copyWith(
        error: AuthFailure(AuthErrorType.invalidCredentials),
      ));
      return;
    }

    emit(state.copyWith(loading: true, error: null, sent: false));
    final res = await usecase(email);
    res.fold(
      (f) => emit(state.copyWith(loading: false, error: f, sent: false)),
      (_) => emit(state.copyWith(loading: false, error: null, sent: true)),
    );
  }
}
