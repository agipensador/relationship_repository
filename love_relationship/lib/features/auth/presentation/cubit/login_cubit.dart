import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/usecases/login_usecase.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_state.dart';
import 'package:love_relationship/features/notifications/domain/usecases/subscribe_topic_usecase.dart';
import 'package:love_relationship/features/notifications/domain/usecases/sync_fcm_token_usecase.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final SyncFcmTokenUseCase syncFcmToken;
  final SubscribeTopicUseCase subscribeTopic;

  LoginCubit(this.loginUseCase, this.syncFcmToken, this.subscribeTopic)
    : super(LoginState.initial());

  void onEmailChanged(String v) => emit(state.copyWith(email: v, error: null));
  void onPasswordChanged(String v) =>
      emit(state.copyWith(password: v, error: null));

  Future<void> login() async {
    final email = state.email.trim();
    final password = state.password.trim();

    // Validação básica de email antes de chamar o usecase
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      emit(state.copyWith(
        loading: false,
        error: AuthFailure(AuthErrorType.invalidEmail),
      ));
      return;
    }

    // Senha vazia: mostrar como senha incorreta (conforme solicitação)
    if (password.isEmpty) {
      emit(state.copyWith(
        loading: false,
        error: AuthFailure(AuthErrorType.wrongPassword),
      ));
      return;
    }

    emit(state.copyWith(loading: true, error: null));
    final result = await loginUseCase(email, password);

    result.fold(
      (failure) => emit(state.copyWith(loading: false, error: failure)),
      (user) {
        emit(state.copyWith(loading: false, user: user, error: null));

        // best-effort (não bloqueia o fluxo de UI)
        () async {
          try {
            await syncFcmToken();
            await subscribeTopic('broadcast');
          } catch (e) {
            // logue se quiser, mas não quebre a UX
          }
        }();
      },
    );
  }
}
