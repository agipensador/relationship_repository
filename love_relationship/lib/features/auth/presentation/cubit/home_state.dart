import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class HomeState {
  final bool loading;
  final String? error;
  final bool ready;
  final UserEntity? user;

  const HomeState({
    this.loading = true,
    this.ready = false,
    this.error,
    this.user,
  });

  factory HomeState.initial() => const HomeState();

  HomeState copyWith({
    bool? loading,
    bool? ready,
    String? error,
    UserEntity? user,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      ready: ready ?? this.ready,
      error: error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [loading, ready, user, error];
}
