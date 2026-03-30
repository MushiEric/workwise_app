// lib/core/widgets/app_button.dart
import 'package:flutter/material.dart';
import '../themes/app_typography.dart';
import '../themes/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? icon;
  final bool isOutlined;
  final bool isTextButton;
  final double? width;
  final double height;
  final bool isLoading;
  final bool enabled;
  final bool isSticky; // New flag added

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
    this.isOutlined = false,
    this.isTextButton = false,
    this.width,
    this.height = 48,
    this.isLoading = false,
    this.enabled = true,
    this.isSticky = false, // New flag with default false
  });

  factory AppButton.primary({
    required String text,
    required VoidCallback? onPressed,
    Widget? icon,
    double? width,
    bool isLoading = false,
    bool enabled = true,
    bool isSticky = false, // Added to factory constructor
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      textColor: AppColors.white,
      icon: icon,
      width: width,
      isLoading: isLoading,
      enabled: enabled,
      isSticky: isSticky, // Pass to main constructor
    );
  }

  factory AppButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    Widget? icon,
    double? width,
    bool isLoading = false,
    bool enabled = true,
    bool isSticky = false, // Added to factory constructor
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: AppColors.secondary,
      textColor: AppColors.black,
      icon: icon,
      width: width,
      isLoading: isLoading,
      enabled: enabled,
      isSticky: isSticky, // Pass to main constructor
    );
  }

  factory AppButton.outlined({
    required String text,
    required VoidCallback? onPressed,
    Color? color,
    Widget? icon,
    double? width,
    bool isLoading = false,
    bool enabled = true,
    bool isSticky = false, // Added to factory constructor
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isOutlined: true,
      backgroundColor: Colors.transparent,
      textColor: color ?? AppColors.primary,
      borderColor: color ?? AppColors.primary,
      icon: icon,
      width: width,
      isLoading: isLoading,
      enabled: enabled,
      isSticky: isSticky, // Pass to main constructor
    );
  }

  factory AppButton.text({
    required String text,
    required VoidCallback? onPressed,
    Color? color,
    Widget? icon,
    double? width,
    bool isLoading = false,
    bool enabled = true,
    bool isSticky = false, // Added to factory constructor
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isTextButton: true,
      backgroundColor: Colors.transparent,
      textColor: color ?? AppColors.primary,
      icon: icon,
      width: width,
      isLoading: isLoading,
      enabled: enabled,
      isSticky: isSticky, // Pass to main constructor
    );
  }

  @override
  Widget build(BuildContext context) {
    var effectiveTextColor = textColor;
    // Default to white text if the background is our primary blue (or similar)
    if (backgroundColor == AppColors.primary && effectiveTextColor == null) {
      effectiveTextColor = AppColors.white;
    }
    
    final bool isDisabled = !enabled || isLoading || onPressed == null;

    // If sticky, wrap with sticky container
    if (isSticky) {
      return Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: _buildButton(isDisabled, effectiveTextColor),
        ),
      );
    }

    // Original behavior (unchanged)
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: _buildButton(isDisabled, effectiveTextColor),
    );
  }

  Widget _buildButton(bool isDisabled, Color? effectiveTextColor) {
    if (isTextButton) {
      return TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: effectiveTextColor,
          disabledForegroundColor: effectiveTextColor?.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.buttonBorderRadius),
          ),
        ),
        child: _buildButtonContent(effectiveTextColor),
      );
    }

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          side: BorderSide(
            color: borderColor?.withOpacity(isDisabled ? 0.5 : 1.0) ?? AppColors.primary,
            width: 1.5,
          ),
          disabledForegroundColor: effectiveTextColor?.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.buttonBorderRadius),
          ),
        ),
        child: _buildButtonContent(effectiveTextColor),
      );
    }

    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: effectiveTextColor,
        disabledBackgroundColor: backgroundColor?.withOpacity(0.5),
        disabledForegroundColor: effectiveTextColor?.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTypography.buttonBorderRadius),
        ),
        elevation: 0,
      ),
      child: _buildButtonContent(effectiveTextColor),
    );
  }

  Widget _buildButtonContent(Color? effectiveTextColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            effectiveTextColor ?? AppColors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: effectiveTextColor,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: effectiveTextColor,
      ),
    );
  }
}