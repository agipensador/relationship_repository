import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/services/auth_session.dart';
import 'package:love_relationship/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:love_relationship/features/chat/domain/entities/chat_message.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_event.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AuthSession authSession;
  final GetUserProfileUsecase getUserProfileUsecase;

  ChatBloc(this.authSession, this.getUserProfileUsecase)
      : super(ChatState.initial()) {
    on<ChatLoadRequested>(_onLoadRequested);
    on<ChatMessageSent>(_onMessageSent);
  }

  Future<void> _onLoadRequested(
    ChatLoadRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    try {
      final uid = authSession.requireUid();
      final result = await getUserProfileUsecase(uid);

      result.fold(
        (_) => emit(state.copyWith(
          loading: false,
          userName: 'Usuário',
          messages: _buildInitialMessages('Usuário'),
        )),
        (user) {
          final name = user.name ?? 'Usuário';
          emit(state.copyWith(
            loading: false,
            userName: name,
            messages: _buildInitialMessages(name),
          ));
        },
      );
    } catch (_) {
      emit(state.copyWith(
        loading: false,
        userName: 'Usuário',
        messages: _buildInitialMessages('Usuário'),
      ));
    }
  }

  List<ChatMessage> _buildInitialMessages(String userName) {
    final now = DateTime.now();
    return [
      // Esquerda: mensagem da outra pessoa
      ChatMessage(
        text: 'Olá $userName',
        isFromCurrentUser: false,
        timestamp: now.subtract(const Duration(minutes: 2)),
      ),
      // Direita: mensagem do usuário atual
      ChatMessage(
        text: 'Olá mundo!',
        isFromCurrentUser: true,
        timestamp: now,
      ),
    ];
  }

  void _onMessageSent(ChatMessageSent event, Emitter<ChatState> emit) {
    final text = event.text.trim();
    if (text.isEmpty) return;

    // TODO ENVIAR PARA CHAT NA API
    final newMessage = ChatMessage(
      text: text,
      isFromCurrentUser: true,
      timestamp: DateTime.now(),
    );
    emit(state.copyWith(
      messages: [...state.messages, newMessage],
    ));
  }
}
