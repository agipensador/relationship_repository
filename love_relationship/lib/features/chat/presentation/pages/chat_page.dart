import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_event.dart';
import 'package:love_relationship/features/chat/presentation/bloc/chat_state.dart';
import 'package:love_relationship/features/chat/presentation/constants/chat_ui_constants.dart';
import 'package:love_relationship/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:love_relationship/features/chat/presentation/widgets/chat_menu_content.dart';
import 'package:love_relationship/features/chat/presentation/widgets/chat_message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late   final ScrollController _menuScrollController = ScrollController(
    initialScrollOffset: ChatUiConstants.menuWidth,
  );
  double _timestampRevealOffset = 0;
  /// true = esquerda (menu), false = direita (hora), null = não arrastando
  bool? _dragOnLeftHalf;

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
        ChatUiConstants.menuWidth,
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
    final target = offset < ChatUiConstants.menuWidth / 2 ? 0.0 : ChatUiConstants.menuWidth;
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
      backgroundColor: AppColors.brutalistBackground,
      appBar: const ChatAppBar(),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.brutalistPrimary,
                strokeWidth: 4,
              ),
            );
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
                    width: ChatUiConstants.menuWidth + w,
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
                                child: LayoutBuilder(
                                  builder: (context, listConstraints) {
                                    final areaWidth = listConstraints.maxWidth;
                                    return GestureDetector(
                                      onHorizontalDragStart: (d) {
                                        final box = context.findRenderObject() as RenderBox?;
                                        if (box != null) {
                                          final local = box.globalToLocal(d.globalPosition);
                                          setState(() {
                                            _dragOnLeftHalf = local.dx < (areaWidth / 2);
                                          });
                                        }
                                      },
                                  onHorizontalDragUpdate: (d) {
                                    if (_dragOnLeftHalf == null) return;
                                    setState(() {
                                      if (_dragOnLeftHalf!) {
                                        if (_menuScrollController.hasClients) {
                                          final newOffset = (_menuScrollController.offset - d.delta.dx)
                                              .clamp(0.0, ChatUiConstants.menuWidth);
                                          _menuScrollController.jumpTo(newOffset);
                                        }
                                      } else {
                                        _timestampRevealOffset -= d.delta.dx;
                                        _timestampRevealOffset = _timestampRevealOffset
                                            .clamp(0.0, ChatUiConstants.timestampWidth);
                                      }
                                    });
                                  },
                                  onHorizontalDragEnd: (_) {
                                    _dragOnLeftHalf = null;
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
                                          return ChatMessageBubble(
                                            message: msg.text,
                                            isFromCurrentUser: msg.isFromCurrentUser,
                                            timestamp: msg.timestamp,
                                            timestampRevealOffset: _timestampRevealOffset,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: AppColors.brutalistBackground,
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColors.brutalistBorder,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: SafeArea(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _messageController,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.brutalistText,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'DIGITE AQUI',
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.brutalistText
                                                  .withOpacity(0.5),
                                            ),
                                            filled: true,
                                            fillColor: AppColors.brutalistSurface,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(24),
                                              borderSide: const BorderSide(
                                                color: AppColors.brutalistBorder,
                                                width: 2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(24),
                                              borderSide: const BorderSide(
                                                color: AppColors.brutalistBorder,
                                                width: 2,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(24),
                                              borderSide: const BorderSide(
                                                color: AppColors.brutalistBorder,
                                                width: 2,
                                              ),
                                            ),
                                            contentPadding: const EdgeInsets
                                                .symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                          ),
                                          maxLines: 3,
                                          minLines: 1,
                                          textInputAction: TextInputAction.send,
                                          onSubmitted: (_) => _sendMessage(),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Material(
                                        color: AppColors.brutalistAccent,
                                        child: InkWell(
                                          onTap: _sendMessage,
                                          child: Container(
                                            width: 52,
                                            height: 52,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: AppColors.brutalistBorder,
                                                  width: 2,
                                                ),
                                                left: BorderSide(
                                                  color: AppColors.brutalistBorder,
                                                  width: 2,
                                                ),
                                                right: BorderSide(
                                                  color: AppColors.brutalistBorder,
                                                  width: 2,
                                                ),
                                                bottom: BorderSide(
                                                  color: AppColors.brutalistBorder,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.arrow_upward,
                                              color: AppColors.brutalistText,
                                              size: 24,
                                            ),
                                          ),
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
