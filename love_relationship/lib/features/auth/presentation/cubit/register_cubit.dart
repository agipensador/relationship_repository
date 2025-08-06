import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/usecases/register_user_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState>  {
  final RegisterUserUsecase _registerUserUsecase;

  RegisterCubit(this._registerUserUsecase) : super(const RegisterState());

  Future<UserEntity?> register({
    required String nameRC,
    required String emailRC,
    required String passwordRC,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _registerUserUsecase(
      email: emailRC, name: nameRC, password: passwordRC);

    return result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
        return null;
      },
      (user) {
        emit(state.copyWith(isLoading: false));
        return user;
      }
    );
  }
}