import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class RegisterState {
  final bool isLoading;
  final Failure? error;
  final UserEntity? registeredUser;

  const RegisterState({
    this.isLoading = false,
    this.error,
    this.registeredUser,
  });

  RegisterState copyWith({
    bool? isLoading,
    Failure? error,
    UserEntity? registeredUser,
    bool clearRegisteredUser = false,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      registeredUser: clearRegisteredUser ? null : (registeredUser ?? this.registeredUser),
    );
  }
}
