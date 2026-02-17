import 'package:equatable/equatable.dart';

sealed class ChatMenuEvent extends Equatable {
  const ChatMenuEvent();

  @override
  List<Object?> get props => [];
}

final class ChatMenuOpened extends ChatMenuEvent {
  const ChatMenuOpened();
}

final class ChatMenuClosed extends ChatMenuEvent {
  const ChatMenuClosed();
}

final class ChatMenuItemSelected extends ChatMenuEvent {
  final String route;

  const ChatMenuItemSelected(this.route);

  @override
  List<Object?> get props => [route];
}
