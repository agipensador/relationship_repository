import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? registeredUser;

  const RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.registeredUser,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserEntity? registeredUser,
    bool clearRegisteredUser = false,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      registeredUser: clearRegisteredUser ? null : (registeredUser ?? this.registeredUser),
    );
  }
}
