import 'package:equatable/equatable.dart';
import 'package:love_relationship/features/games/domain/entities/game_entity.dart';

enum GamesViewMode { grid, carousel }

class GamesState extends Equatable {
  final bool loading;
  final List<GameEntity> items;
  final GamesViewMode mode;
  final String? error;

  const GamesState({
    required this.loading,
    required this.items,
    required this.mode,
    this.error,
  });

  factory GamesState.initial() =>
      const GamesState(loading: true, items: [], mode: GamesViewMode.grid);

  GamesState copyWith({
    bool? loading,
    List<GameEntity>? items,
    GamesViewMode? mode,
    String? error,
  }) {
    return GamesState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      mode: mode ?? this.mode,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, items, mode, error];
}
