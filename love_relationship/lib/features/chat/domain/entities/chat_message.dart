/// Entidade de mensagem do chat.
class ChatMessage {
  final String text;
  final bool isFromCurrentUser;

  const ChatMessage({
    required this.text,
    required this.isFromCurrentUser,
  });
}
