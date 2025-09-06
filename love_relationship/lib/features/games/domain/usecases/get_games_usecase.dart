import 'package:love_relationship/features/games/domain/entities/game_entity.dart';

class GetGamesUsecase {
  // TODO no futuro, injete um repo. Agora, retorna estático.
  Future<List<GameEntity>> call() async {
    return [
      GameEntity(
        id: 'truth',
        title: 'Verdade ou Consequência',
        assetSvg: 'game_truth.svg',
      ),
      GameEntity(id: 'memory', title: 'Memória', assetSvg: 'game_memory.svg'),
      GameEntity(
        id: 'kiss',
        title: 'Beijo ou Lambo',
        assetSvg: 'game_kiss.svg',
      ),
      GameEntity(
        id: 'poses',
        title: 'Jogo das Posições',
        assetSvg: 'game_poses.svg',
      ),
    ];
  }
}
