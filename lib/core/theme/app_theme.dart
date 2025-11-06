import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary600,
        secondary: AppColors.secondary600,
        tertiary: AppColors.accent600,
        surface: AppColors.white,
        error: AppColors.error600,
      ),
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        headlineMedium: AppTextStyles.h3,
        titleLarge: AppTextStyles.h4,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.buttonText,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary600,
          foregroundColor: AppColors.white,
          textStyle: AppTextStyles.buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary600,
          side: const BorderSide(color: AppColors.primary600, width: 2),
          textStyle: AppTextStyles.buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error600, width: 2),
        ),
        labelStyle: AppTextStyles.label,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray400),
      ),
    );
  }
}
