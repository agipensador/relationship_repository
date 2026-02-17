import 'package:equatable/equatable.dart';
import 'package:love_relationship/features/chat/domain/entities/chat_menu_item.dart';

class ChatMenuState extends Equatable {
  final bool isOpen;
  final String? selectedRoute;
  final List<ChatMenuItem> items;

  const ChatMenuState({
    this.isOpen = false,
    this.selectedRoute,
    this.items = const [],
  });

  factory ChatMenuState.initial() => const ChatMenuState();

  ChatMenuState copyWith({
    bool? isOpen,
    String? selectedRoute,
    List<ChatMenuItem>? items,
  }) {
    return ChatMenuState(
      isOpen: isOpen ?? this.isOpen,
      selectedRoute: selectedRoute ?? this.selectedRoute,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [isOpen, selectedRoute, items];
}
