import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/usecases/confirm_reset_password_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:love_relationship/features/auth/presentation/bloc/forgot_password/forgot_password_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ConfirmResetPasswordUseCase confirmResetPasswordUseCase;

  ForgotPasswordBloc(this.forgotPasswordUseCase, this.confirmResetPasswordUseCase)
      : super(ForgotPasswordState.initial()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSendRequested>(_onSendRequested);
    on<ForgotPasswordCodeChanged>(_onCodeChanged);
    on<ForgotPasswordNewPasswordChanged>(_onNewPasswordChanged);
    on<ForgotPasswordConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ForgotPasswordConfirmRequested>(_onConfirmRequested);
  }

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(email: event.email, error: null, sent: false));
  }

  void _onCodeChanged(
    ForgotPasswordCodeChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(code: event.code, error: null));
  }

  void _onNewPasswordChanged(
    ForgotPasswordNewPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(newPassword: event.newPassword, error: null));
  }

  void _onConfirmPasswordChanged(
    ForgotPasswordConfirmPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(confirmPassword: event.confirmPassword, error: null));
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
    final res = await forgotPasswordUseCase(email);
    res.fold(
      (f) => emit(state.copyWith(loading: false, error: f, sent: false)),
      (_) => emit(state.copyWith(loading: false, error: null, sent: true)),
    );
  }

  Future<void> _onConfirmRequested(
    ForgotPasswordConfirmRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final code = state.code.trim();
    final newPassword = state.newPassword;
    final confirmPassword = state.confirmPassword;
    final email = state.email.trim();

    if (code.isEmpty) {
      emit(state.copyWith(
        error: AuthFailure(AuthErrorType.invalidConfirmationCode, message: 'Informe o código recebido por e-mail'),
      ));
      return;
    }

    if (newPassword.length < 8) {
      emit(state.copyWith(
        error: AuthFailure(AuthErrorType.wrongPassword, message: 'A senha deve ter no mínimo 8 caracteres'),
      ));
      return;
    }

    if (newPassword != confirmPassword) {
      emit(state.copyWith(
        error: AuthFailure(AuthErrorType.wrongPassword, message: 'As senhas não coincidem'),
      ));
      return;
    }

    emit(state.copyWith(loading: true, error: null));
    final res = await confirmResetPasswordUseCase(
      email: email,
      code: code,
      newPassword: newPassword,
    );
    res.fold(
      (f) => emit(state.copyWith(loading: false, error: f)),
      (_) => emit(state.copyWith(loading: false, passwordReset: true)),
    );
  }
}
