import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/usecases/logout_usecase.dart';
import 'package:love_relationship/features/auth/presentation/cubit/auth_state.dart';

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
