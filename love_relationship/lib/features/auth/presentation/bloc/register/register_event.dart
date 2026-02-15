import 'package:equatable/equatable.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

final class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
