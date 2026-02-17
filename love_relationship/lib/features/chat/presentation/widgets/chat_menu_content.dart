import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
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
          decoration: const BoxDecoration(
            color: AppColors.brutalistBackground,
            border: Border(
              right: BorderSide(
                color: AppColors.brutalistBorder,
                width: 4,
              ),
            ),
          ),
          child: SafeArea(
            right: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.close,
                    color: AppColors.brutalistText,
                  ),
                  title: const Text(
                    'FECHAR',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppColors.brutalistText,
                    ),
                  ),
                  onTap: onClose,
                ),
                Divider(height: 1, color: AppColors.brutalistBorder, thickness: 2),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.brutalistText,
                          ),
                        ),
                        leading: const Icon(
                          Icons.chevron_right,
                          color: AppColors.brutalistText,
                        ),
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
