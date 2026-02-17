import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/chat/domain/entities/chat_menu_item.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_bloc.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_event.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_state.dart';

/// Drawer do menu lateral do chat (abre ao arrastar da esquerda para direita).
class ChatMenuDrawer extends StatelessWidget {
  const ChatMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMenuBloc, ChatMenuState>(
      builder: (context, state) {
        return Drawer(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header com "Fechar x"
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Fechar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<ChatMenuBloc>().add(const ChatMenuClosed());
                        },
                        tooltip: 'Fechar',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Lista de itens
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return _ChatMenuItemTile(
                        item: item,
                        onTap: () {
                          Navigator.pop(context);
                          context.read<ChatMenuBloc>().add(const ChatMenuClosed());
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

class _ChatMenuItemTile extends StatelessWidget {
  final ChatMenuItem item;
  final VoidCallback onTap;

  const _ChatMenuItemTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      leading: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
