import 'package:equatable/equatable.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Carrega o chat (usuário atual para mensagem de boas-vindas).
final class ChatLoadRequested extends ChatEvent {
  const ChatLoadRequested();
}

/// Usuário enviou uma mensagem.
final class ChatMessageSent extends ChatEvent {
  final String text;

  const ChatMessageSent(this.text);

  @override
  List<Object?> get props => [text];
}

/// Usuário alterou o nome do parceiro no header.
final class ChatPartnerNameChanged extends ChatEvent {
  final String name;

  const ChatPartnerNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}
