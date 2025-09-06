import 'package:equatable/equatable.dart';

class GameEntity extends Equatable {
  final String id;
  final String title;
  final String assetSvg;

  GameEntity({required this.id, required this.title, required this.assetSvg});

  @override
  List<Object?> get props => [id, title, assetSvg];
}
