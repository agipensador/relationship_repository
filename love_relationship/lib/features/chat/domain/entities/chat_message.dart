/// Entidade de mensagem do chat.
class ChatMessage {
  final String text;
  final bool isFromCurrentUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isFromCurrentUser,
    required this.timestamp,
  });
}
