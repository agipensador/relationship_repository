import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_bloc.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_event.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_menu_state.dart';

/// Painel do menu que desliza da esquerda dentro do chat.
/// Fica aberto até: selecionar item, tocar Fechar, ou arrastar para fechar.
class ChatMenuPanel extends StatelessWidget {
  const ChatMenuPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMenuBloc, ChatMenuState>(
      buildWhen: (p, c) => p.isOpen != c.isOpen,
      builder: (context, state) {
        if (!state.isOpen) return const SizedBox.shrink();

        return Stack(
          children: [
            // Barreira invisível - toque fecha
            Positioned.fill(
              child: GestureDetector(
                onTap: () => context.read<ChatMenuBloc>().add(const ChatMenuClosed()),
                child: Container(color: Colors.black26),
              ),
            ),
            // Menu deslizante da esquerda
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragEnd: (d) {
                  if (d.primaryVelocity != null && d.primaryVelocity! < -100) {
                    context.read<ChatMenuBloc>().add(const ChatMenuClosed());
                  }
                },
                child: Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    right: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Fechar x - primeiro item
                        ListTile(
                          leading: const Icon(Icons.close),
                          title: const Text('Fechar'),
                          onTap: () {
                            context.read<ChatMenuBloc>().add(const ChatMenuClosed());
                          },
                        ),
                        const Divider(height: 1),
                        // Itens do menu
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
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
