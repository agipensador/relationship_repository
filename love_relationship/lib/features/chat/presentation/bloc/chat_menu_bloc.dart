import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/features/chat/domain/entities/chat_menu_item.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_event.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_state.dart';

class ChatMenuBloc extends Bloc<ChatMenuEvent, ChatMenuState> {
  ChatMenuBloc() : super(_initialState) {
    on<ChatMenuOpened>(_onOpened);
    on<ChatMenuClosed>(_onClosed);
    on<ChatMenuItemSelected>(_onItemSelected);
  }

  static final List<ChatMenuItem> _menuItems = [
    ChatMenuItem(
      id: 'proximidade',
      title: 'Mensagem para quando estivermos perto',
      route: AppStrings.chatMensagemProximidadeRoute,
    ),
    ChatMenuItem(
      id: 'futuro',
      title: 'Mensagem pro futuro',
      route: AppStrings.chatMensagemFuturoRoute,
    ),
  ];

  static final ChatMenuState _initialState = ChatMenuState(
    items: _menuItems,
  );

  void _onOpened(ChatMenuOpened event, Emitter<ChatMenuState> emit) {
    emit(state.copyWith(isOpen: true));
  }

  void _onClosed(ChatMenuClosed event, Emitter<ChatMenuState> emit) {
    emit(state.copyWith(isOpen: false));
  }

  void _onItemSelected(ChatMenuItemSelected event, Emitter<ChatMenuState> emit) {
    emit(state.copyWith(selectedRoute: event.route));
  }
}
