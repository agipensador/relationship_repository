import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginState.initial());

  void onEmailChanged(String v) => emit(state.copyWith(email: v, error: null));
  void onPasswordChanged(String v) => emit(state.copyWith(password: v, error: null));

  Future<void> login() async {
    emit(state.copyWith(loading: true, error: null));
    final result = await loginUseCase(state.email.trim(), state.password.trim());

    result.fold(
      (failure) => emit(state.copyWith(loading: false, error: failure)),
      (user) => emit(state.copyWith(loading: false, user: user, error: null)));
  }
}