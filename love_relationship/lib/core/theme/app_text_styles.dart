import 'package:flutter/material.dart';
import 'package:love_relationship/core/theme/app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'Roboto'; // Aqui muda a fonte de todo APP

  static TextStyle get title => TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.blackDefault,
      fontFamily: fontFamily,
    );

  static TextStyle get subtitle => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.blackDefault,
        fontFamily: fontFamily,
      );

  static TextStyle body(BuildContext context){
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
    fontSize: 16,
    color: isDark ? AppColors.blackDefault : Colors.white,
    fontFamily: fontFamily,
  );
  }

  static TextStyle textClicable(BuildContext context, {bool hiperlink = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 16,
      color: isDark ? Colors.white : AppColors.primary,
      fontFamily: fontFamily,
      decoration: hiperlink ? TextDecoration.underline : TextDecoration.none,
      decorationThickness: 2,
      decorationColor: isDark ? Colors.white : AppColors.primary
    );
  }

  static TextStyle get primaryButtonText => TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontFamily: fontFamily,
    );

  static TextStyle get secondaryButtonText => TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontFamily: fontFamily,
    );

  static TextStyle get caption => TextStyle(
        fontSize: 14,
        color: AppColors.blackDefault.withValues(alpha: 0.7),
        fontFamily: fontFamily,
      );

}