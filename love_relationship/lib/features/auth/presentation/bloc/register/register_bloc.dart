import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:love_relationship/features/auth/presentation/bloc/register/register_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/register/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUsecase _registerUserUsecase;

  RegisterBloc(this._registerUserUsecase) : super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, clearRegisteredUser: true));

    final result = await _registerUserUsecase(
      email: event.email,
      name: event.name,
      password: event.password,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message, clearRegisteredUser: true)),
      (user) => emit(state.copyWith(isLoading: false, registeredUser: user)),
    );
  }
}
