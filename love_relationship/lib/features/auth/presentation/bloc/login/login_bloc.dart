import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/core/validators/password_validator.dart';
import 'package:love_relationship/features/auth/domain/usecases/login_usecase.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_state.dart';
import 'package:love_relationship/features/notifications/domain/usecases/subscribe_topic_usecase.dart';
import 'package:love_relationship/features/notifications/domain/usecases/sync_fcm_token_usecase.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final SyncFcmTokenUseCase syncFcmToken;
  final SubscribeTopicUseCase subscribeTopic;

  LoginBloc(this.loginUseCase, this.syncFcmToken, this.subscribeTopic)
      : super(LoginState.initial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, error: null));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password, error: null));
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final email = state.email.trim();
    final password = state.password.trim();

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      emit(state.copyWith(
        loading: false,
        error: AuthFailure(AuthErrorType.invalidEmail),
      ));
      return;
    }

    if (password.isEmpty) {
      emit(state.copyWith(
        loading: false,
        error: AuthFailure(AuthErrorType.wrongPassword),
      ));
      return;
    }

    final passwordResult = PasswordValidator.validate(password);
    if (!passwordResult.isValid) {
      emit(state.copyWith(
        loading: false,
        error: AuthFailure(AuthErrorType.invalidPasswordFormat),
      ));
      return;
    }

    emit(state.copyWith(loading: true, error: null));
    final result = await loginUseCase(email, password);

    result.fold(
      (failure) => emit(state.copyWith(loading: false, error: failure)),
      (user) {
        emit(state.copyWith(loading: false, user: user, error: null));
        () async {
          try {
            await syncFcmToken();
            await subscribeTopic('broadcast');
          } catch (_) {}
        }();
      },
    );
  }
}
