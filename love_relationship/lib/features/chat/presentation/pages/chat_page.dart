import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_event.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_state.dart';
import 'package:love_relationship/features/chat/presentation/widgets/chat_menu_content.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ScrollController _menuScrollController = ScrollController(
    initialScrollOffset: _menuWidth,
  );
  static const _menuWidth = 280.0;
  static const _timestampWidth = 56.0;
  double _timestampRevealOffset = 0;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _menuScrollController.dispose();
    super.dispose();
  }

  void _closeMenu() {
    if (_menuScrollController.hasClients) {
      _menuScrollController.animateTo(
        _menuWidth,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _onTimestampDragEnd() {
    if (_timestampRevealOffset > 2) {
      setState(() => _timestampRevealOffset = 0);
    }
  }

  void _snapMenu() {
    if (!_menuScrollController.hasClients) return;
    final offset = _menuScrollController.offset;
    final target = offset < _menuWidth / 2 ? 0.0 : _menuWidth;
    // Evita loop: só anima se ainda não está no alvo (senão animateTo dispara
    // ScrollEnd de novo e entra em stack overflow)
    if ((offset - target).abs() > 2) {
      _menuScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(ChatMessageSent(text));
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              return NotificationListener<ScrollEndNotification>(
                onNotification: (_) {
                  _snapMenu();
                  return false;
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _menuScrollController,
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: _menuWidth + w,
                    height: h,
                    child: Row(
                      children: [
                        ChatMenuContent(onClose: _closeMenu),
                        SizedBox(
                          width: w,
                          height: h,
                          child: Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onHorizontalDragUpdate: (d) {
                                    setState(() {
                                      _timestampRevealOffset -= d.delta.dx;
                                      _timestampRevealOffset = _timestampRevealOffset
                                          .clamp(0.0, _timestampWidth);
                                    });
                                    if (_menuScrollController.hasClients) {
                                      final newOffset = (_menuScrollController.offset - d.delta.dx)
                                          .clamp(0.0, _menuWidth);
                                      _menuScrollController.jumpTo(newOffset);
                                    }
                                  },
                                  onHorizontalDragEnd: (_) {
                                    _onTimestampDragEnd();
                                    _snapMenu();
                                  },
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    itemCount: state.messages.length,
                                    itemBuilder: (context, index) {
                                      final msg = state.messages[index];
                                      return _MessageBubble(
                                        message: msg.text,
                                        isFromCurrentUser: msg.isFromCurrentUser,
                                        timestamp: msg.timestamp,
                                        timestampRevealOffset: _timestampRevealOffset,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, -2),
                                    ),
                                  ],
                                ),
                                child: SafeArea(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _messageController,
                                          decoration: InputDecoration(
                                            hintText: 'digite algo aqui',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 12,
                                            ),
                                          ),
                                          maxLines: 3,
                                          minLines: 1,
                                          textInputAction: TextInputAction.send,
                                          onSubmitted: (_) => _sendMessage(),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: _sendMessage,
                                        icon: const Icon(Icons.arrow_upward),
                                        style: IconButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Formata hora no estilo HH:mm
String _formatTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isFromCurrentUser;
  final DateTime timestamp;
  final double timestampRevealOffset;

  const _MessageBubble({
    required this.message,
    required this.isFromCurrentUser,
    required this.timestamp,
    this.timestampRevealOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;
        final timeStr = _formatTime(timestamp);

        final bubble = Align(
          alignment: isFromCurrentUser
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: _BubbleContent(
            message: message,
            isFromCurrentUser: isFromCurrentUser,
          ),
        );

        if (timestampRevealOffset > 0) {
          return Row(
            children: [
              Expanded(child: bubble),
              SizedBox(
                width: timestampRevealOffset,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 56,
                      child: _TimestampText(timeStr),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return SizedBox(width: viewportWidth, child: bubble);
      },
    );
  }
}

class _TimestampText extends StatelessWidget {
  final String text;

  const _TimestampText(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _BubbleContent extends StatelessWidget {
  final String message;
  final bool isFromCurrentUser;

  const _BubbleContent({
    required this.message,
    required this.isFromCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isFromCurrentUser
            ? AppColors.primary
            : Colors.grey.shade300,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isFromCurrentUser ? 16 : 4),
          bottomRight: Radius.circular(isFromCurrentUser ? 4 : 16),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isFromCurrentUser ? Colors.white : Colors.black87,
          fontSize: 15,
        ),
      ),
    );
  }
}
