import 'package:flutter/material.dart';
import 'package:love_relationship/core/helpers/theme_helper.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Future<void> Function() onPressed;

  const PrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDark(context);
    final background = isDark ? AppColors.primary : AppColors.primary;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        onPressed: () => onPressed(),
        child: Text(text, style: AppTextStyles.primaryButtonText),
      ),
    );
  }
}
