import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.primary) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary600,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.gray200,
            disabledForegroundColor: AppColors.gray400,
          ),
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: AppTextStyles.buttonText),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, size: 20),
              ],
            ],
          ),
        ),
      );
    } else if (type == ButtonType.secondary) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: Text(text, style: AppTextStyles.buttonText),
        ),
      );
    } else {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        child: Text(
          text,
          style: AppTextStyles.buttonText.copyWith(
            color: AppColors.primary600,
          ),
        ),
      );
    }
  }
}

enum ButtonType { primary, secondary, tertiary }