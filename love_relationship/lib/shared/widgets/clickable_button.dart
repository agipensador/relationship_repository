import 'package:flutter/material.dart';
import 'package:love_relationship/core/theme/app_text_styles.dart';

class TextClickableButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TextClickableButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: AppTextStyles.textClicable(context)),
    );
  }
}
