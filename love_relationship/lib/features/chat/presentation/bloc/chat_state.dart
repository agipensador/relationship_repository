import 'package:equatable/equatable.dart';
import 'package:love_relationship/features/chat/domain/entities/chat_message.dart';

class ChatState extends Equatable {
  final bool loading;
  final String? userName;
  /// Nome do parceiro exibido no header do chat.
  /// TODO ALTERAR PARA O NOME DO PARCEIRO, QUE VIRÁ DO BANCO;
  /// DEPOIS O PRÓPRIO USUÁRIO PODE ESCOLHER UM NOME.
  final String partnerName;
  final List<ChatMessage> messages;

  const ChatState({
    this.loading = true,
    this.userName,
    this.partnerName = 'Valéria',
    this.messages = const [],
  });

  factory ChatState.initial() => const ChatState();

  ChatState copyWith({
    bool? loading,
    String? userName,
    String? partnerName,
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      loading: loading ?? this.loading,
      userName: userName ?? this.userName,
      partnerName: partnerName ?? this.partnerName,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [loading, userName, partnerName, messages];
}
