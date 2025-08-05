import 'package:flutter/material.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/core/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        fontFamily: AppTextStyles.fontFamily,
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundSecondary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.tertiary,
          foregroundColor: Colors.white,
        ),
        fontFamily: AppTextStyles.fontFamily,
        useMaterial3: true,
      );
}
