import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/games/domain/usecases/get_games_usecase.dart';
import 'package:love_relationship/features/games/presentation/cubit/games_state.dart';

class GamesCubit extends Cubit<GamesState> {
  final GetGamesUsecase _getGames;

  GamesCubit(this._getGames) : super(GamesState.initial()) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final list = await _getGames();
      emit(state.copyWith(loading: false, items: list));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void toggleView() {
    final next = state.mode == GamesViewMode.grid
        ? GamesViewMode.carousel
        : GamesViewMode.grid;
    emit(state.copyWith(mode: next));
  }
}
