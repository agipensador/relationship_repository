import 'package:equatable/equatable.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeLoadCurrentUser extends HomeEvent {
  const HomeLoadCurrentUser();
}

final class HomeUserReceived extends HomeEvent {
  final UserEntity user;

  const HomeUserReceived(this.user);

  @override
  List<Object?> get props => [user];
}

final class HomeUserError extends HomeEvent {
  final String message;

  const HomeUserError(this.message);

  @override
  List<Object?> get props => [message];
}
