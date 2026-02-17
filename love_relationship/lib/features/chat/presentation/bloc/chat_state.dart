import 'package:equatable/equatable.dart';
import 'package:love_relationship/features/chat/domain/entities/chat_message.dart';

class ChatState extends Equatable {
  final bool loading;
  final String? userName;
  final List<ChatMessage> messages;

  const ChatState({
    this.loading = true,
    this.userName,
    this.messages = const [],
  });

  factory ChatState.initial() => const ChatState();

  ChatState copyWith({
    bool? loading,
    String? userName,
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      loading: loading ?? this.loading,
      userName: userName ?? this.userName,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [loading, userName, messages];
}
