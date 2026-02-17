import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_bloc.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_state.dart';

/// Conteúdo do menu que aparece à esquerda, empurrando o chat.
/// Usado dentro do layout deslizante (não overlay).
class ChatMenuContent extends StatelessWidget {
  final VoidCallback onClose;

  const ChatMenuContent({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMenuBloc, ChatMenuState>(
      builder: (context, state) {
        return Container(
          width: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: SafeArea(
            right: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Fechar'),
                  onTap: onClose,
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(item.title),
                        leading: const Icon(Icons.chevron_right),
                        onTap: () {
                          onClose();
                          Navigator.pushNamed(context, item.route);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
