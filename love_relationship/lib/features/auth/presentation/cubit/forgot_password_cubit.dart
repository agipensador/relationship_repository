import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../../../core/error/failure.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase usecase;
  ForgotPasswordCubit(this.usecase) : super(ForgotPasswordState.initial());

  void onEmailChanged(String v) {
    emit(state.copyWith(email: v, error: null, sent: false));
  }

  Future<void> send() async {
    final email = state.email.trim();
    if (email.isEmpty) {
      emit(
        state.copyWith(error: AuthFailure(AuthErrorType.invalidCredentials)),
      );
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
