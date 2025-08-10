import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class HomeState {
  final bool loading;
  final String? error;
  final UserEntity? user;

  const HomeState({this.loading = true, this.error, this.user});

  factory HomeState.initial() => const HomeState();

  HomeState copyWith({bool? loading, String? error, UserEntity? user}) {
    return HomeState(
      loading: loading ?? this.loading,
      error: error,
      user: user ?? this.user,
    );
  }
}
