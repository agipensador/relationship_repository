import 'package:flutter/material.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/chat/presentation/constants/chat_ui_constants.dart';
import 'package:love_relationship/features/chat/utils/chat_formatters.dart';

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final bool isFromCurrentUser;
  final DateTime timestamp;
  final double timestampRevealOffset;

  const ChatMessageBubble({
    super.key,
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
        final timeStr = formatChatTime(timestamp);

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
                      width: ChatUiConstants.timestampWidth,
                      child: _TimestampText(text: timeStr),
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

  const _TimestampText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.brutalistText,
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
    return CustomPaint(
      painter: _BubbleTailPainter(isFromCurrentUser: isFromCurrentUser),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ChatUiConstants.maxBubbleWidth),
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.brutalistText,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Desenha o balão com perna (cauda) apontando para o lado de quem fala.
class _BubbleTailPainter extends CustomPainter {
  final bool isFromCurrentUser;

  _BubbleTailPainter({required this.isFromCurrentUser});

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 16.0;
    const tailWidth = 12.0;
    const tailHeight = 10.0;
    const borderWidth = 2.0;

    final fillColor = isFromCurrentUser
        ? AppColors.brutalistPrimary
        : AppColors.brutalistSurface;
    final borderColor = AppColors.brutalistBorder;

    final bodyHeight = size.height - tailHeight;
    final bodyRect = Rect.fromLTWH(0, 0, size.width, bodyHeight);

    // Triângulo encaixado no canto inferior (esquerdo ou direito)
    final tailPath = Path();
    if (isFromCurrentUser) {
      // Canto inferior direito: base na borda, ponta para baixo-direita
      final cornerX = size.width - radius;
      tailPath.moveTo(cornerX - tailWidth, bodyHeight);
      tailPath.lineTo(cornerX, bodyHeight);
      tailPath.lineTo(cornerX, bodyHeight + tailHeight);
      tailPath.close();
    } else {
      // Canto inferior esquerdo: base na borda, ponta para baixo-esquerda
      final cornerX = radius;
      tailPath.moveTo(cornerX, bodyHeight);
      tailPath.lineTo(cornerX + tailWidth, bodyHeight);
      tailPath.lineTo(cornerX, bodyHeight + tailHeight);
      tailPath.close();
    }

    // Balão: preenchimento branco ou vermelho
    canvas.drawPath(
      Path()..addRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(radius))),
      Paint()..color = fillColor,
    );

    // Triângulo: preenchimento e borda pretos
    canvas.drawPath(tailPath, Paint()..color = borderColor);
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawPath(tailPath, borderPaint);

    // Borda do balão
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(radius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) =>
      oldDelegate.isFromCurrentUser != isFromCurrentUser;
}
