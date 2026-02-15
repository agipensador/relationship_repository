import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/games/domain/usecases/get_games_usecase.dart';
import 'package:love_relationship/features/games/presentation/bloc/games_event.dart';
import 'package:love_relationship/features/games/presentation/cubit/games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final GetGamesUsecase _getGames;

  GamesBloc(this._getGames) : super(GamesState.initial()) {
    on<GamesLoadRequested>(_onLoad);
    on<GamesToggleViewRequested>(_onToggleView);
    add(const GamesLoadRequested());
  }

  Future<void> _onLoad(
    GamesLoadRequested event,
    Emitter<GamesState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final list = await _getGames();
      emit(state.copyWith(loading: false, items: list));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onToggleView(
    GamesToggleViewRequested event,
    Emitter<GamesState> emit,
  ) {
    final next = state.mode == GamesViewMode.grid
        ? GamesViewMode.carousel
        : GamesViewMode.grid;
    emit(state.copyWith(mode: next));
  }
}
