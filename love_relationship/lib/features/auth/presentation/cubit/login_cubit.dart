import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/entities/user.dart';
import 'package:love_relationship/features/auth/domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login(String email, String password) async{
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure('Preencha todos os campos'));
      return;
  }
    emit(LoginLoading());

    final result = await loginUseCase(email, password);

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (user) => emit(LoginSuccess(user))
    );
  }
}