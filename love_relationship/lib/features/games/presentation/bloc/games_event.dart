import 'package:equatable/equatable.dart';

sealed class GamesEvent extends Equatable {
  const GamesEvent();

  @override
  List<Object?> get props => [];
}

final class GamesLoadRequested extends GamesEvent {
  const GamesLoadRequested();
}

final class GamesToggleViewRequested extends GamesEvent {
  const GamesToggleViewRequested();
}
