import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/app_colors.dart';

/// A comprehensive custom button widget for the entire app
class AppButton extends StatelessWidget {
  /// Button variants
  final AppButtonVariant variant;

  /// Button size
  final AppButtonSize size;

  /// Button text
  final String? text;

  /// Optional icon
  final IconData? icon;

  /// Icon position (left or right)
  final IconPosition iconPosition;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button is full width
  final bool fullWidth;

  /// Custom width (if not full width)
  final double? width;

  /// Custom height (overrides size)
  final double? height;

  /// Custom background color (overrides variant)
  final Color? backgroundColor;

  /// Custom text color (overrides variant)
  final Color? textColor;

  /// Custom border color
  final Color? borderColor;

  /// Custom elevation
  final double? elevation;

  /// Border radius
  final double borderRadius;

  /// Optional child widget (overrides text)
  final Widget? child;

  /// Optional prefix widget
  final Widget? prefix;

  /// Optional suffix widget
  final Widget? suffix;

  /// Additional padding
  final EdgeInsets? padding;

  /// Whether to show a shadow
  final bool hasShadow;

  /// Custom shadow color
  final Color? shadowColor;

  /// Haptic feedback on tap
  final bool hapticFeedback;

  /// Tooltip message
  final String? tooltip;

  const AppButton({
    super.key,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.text,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.elevation,
    this.borderRadius = 12,
    this.child,
    this.prefix,
    this.suffix,
    this.padding,
    this.hasShadow = false,
    this.shadowColor,
    this.hapticFeedback = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final buttonStyle = _getButtonStyle(context, isDark, primaryColor);

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handlePressed,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: _getSplashColor(primaryColor).withOpacity(0.2),
        highlightColor: _getSplashColor(primaryColor).withOpacity(0.1),
        child: Ink(
          decoration: buttonStyle,
          child: Container(
            width: fullWidth ? double.infinity : width,
            height: height ?? _getHeight(),
            padding: padding ?? _getPadding(),
            child: _buildContent(context, isDark, primaryColor),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  void _handlePressed() {
    if (onPressed == null || isLoading) return;

    if (hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    onPressed!();
  }

  Widget _buildContent(BuildContext context, bool isDark, Color primaryColor) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: _getLoaderSize(),
          height: _getLoaderSize(),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getLoaderColor(isDark, primaryColor),
            ),
          ),
        ),
      );
    }

    if (child != null) return child!;

    final textStyle = _getTextStyle(context, isDark, primaryColor);

    final textWidget = text != null
        ? Text(text!, style: textStyle, textAlign: TextAlign.center)
        : const SizedBox.shrink();

    if (icon == null && prefix == null && suffix == null) {
      return Center(child: textWidget);
    }

    final children = <Widget>[];

    // Add prefix
    if (prefix != null) {
      children.add(prefix!);
    } else if (icon != null && iconPosition == IconPosition.left) {
      children.add(
        Icon(
          icon,
          size: _getIconSize(),
          color: _getIconColor(isDark, primaryColor),
        ),
      );
    }

    // Add text
    if (text != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(width: 8));
      }
      children.add(textWidget);
    }

    // Add suffix
    if (suffix != null) {
      if (children.isNotEmpty) children.add(const SizedBox(width: 8));
      children.add(suffix!);
    } else if (icon != null && iconPosition == IconPosition.right) {
      if (children.isNotEmpty) children.add(const SizedBox(width: 8));
      children.add(
        Icon(
          icon,
          size: _getIconSize(),
          color: _getIconColor(isDark, primaryColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  BoxDecoration _getButtonStyle(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    final isEnabled = onPressed != null && !isLoading;
    final bgColor = backgroundColor ?? _getBackgroundColor(primaryColor);
    final borderColor =
        this.borderColor ?? _getBorderColor(context, isDark, primaryColor);

    return BoxDecoration(
      color: isEnabled ? bgColor : bgColor.withOpacity(0.5),
      borderRadius: BorderRadius.circular(borderRadius),
      border: borderColor != null
          ? Border.all(color: borderColor, width: 1)
          : null,
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color:
                    shadowColor ??
                    (isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1)),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
          : (elevation != null
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: elevation! * 2,
                      offset: Offset(0, elevation!),
                    ),
                  ]
                : null),
    );
  }

  Color _getBackgroundColor(Color primaryColor) {
    switch (variant) {
      case AppButtonVariant.primary:
        return primaryColor;
      case AppButtonVariant.secondary:
        return Colors.transparent;
      case AppButtonVariant.success:
        return Colors.green;
      case AppButtonVariant.danger:
        return Colors.red;
      case AppButtonVariant.warning:
        return Colors.orange;
      case AppButtonVariant.info:
        return Colors.blue;
      case AppButtonVariant.light:
        return Colors.grey.shade100;
      case AppButtonVariant.dark:
        return const Color(0xFF1A2634);
      case AppButtonVariant.outline:
        return Colors.transparent;
      case AppButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color? _getBorderColor(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    switch (variant) {
      case AppButtonVariant.outline:
        return primaryColor;
      case AppButtonVariant.text:
        return null;
      case AppButtonVariant.secondary:
        return isDark ? Colors.white24 : Colors.grey.shade300;
      default:
        return null;
    }
  }

  Color _getSplashColor(Color primaryColor) {
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return primaryColor;
      case AppButtonVariant.success:
        return Colors.white;
      case AppButtonVariant.danger:
        return Colors.white;
      case AppButtonVariant.warning:
        return Colors.white;
      case AppButtonVariant.info:
        return Colors.white;
      case AppButtonVariant.light:
        return Colors.grey.shade600;
      case AppButtonVariant.dark:
        return Colors.white;
      case AppButtonVariant.outline:
        return primaryColor;
      case AppButtonVariant.text:
        return primaryColor;
    }
  }

  TextStyle _getTextStyle(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    final baseStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ) ??
        const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.3);

    switch (size) {
      case AppButtonSize.small:
        return baseStyle.copyWith(fontSize: 13);
      case AppButtonSize.medium:
        return baseStyle.copyWith(fontSize: 15);
      case AppButtonSize.large:
        return baseStyle.copyWith(fontSize: 16);
    }
  }

  Color _getTextColor(bool isDark, Color primaryColor) {
    if (textColor != null) return textColor!;

    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.success:
      case AppButtonVariant.danger:
      case AppButtonVariant.warning:
      case AppButtonVariant.info:
      case AppButtonVariant.dark:
        return Colors.white;
      case AppButtonVariant.secondary:
      case AppButtonVariant.light:
        return isDark ? Colors.white : const Color(0xFF1A2634);
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return primaryColor;
    }
  }

  Color _getIconColor(bool isDark, Color primaryColor) {
    if (textColor != null) return textColor!;
    return _getTextColor(isDark, primaryColor);
  }

  Color _getLoaderColor(bool isDark, Color primaryColor) {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.success:
      case AppButtonVariant.danger:
      case AppButtonVariant.warning:
      case AppButtonVariant.info:
      case AppButtonVariant.dark:
        return Colors.white;
      case AppButtonVariant.secondary:
      case AppButtonVariant.light:
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return primaryColor;
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 44;
      case AppButtonSize.large:
        return 54;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 20;
    }
  }

  double _getLoaderSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}

/// Button variants
enum AppButtonVariant {
  primary,
  secondary,
  success,
  danger,
  warning,
  info,
  light,
  dark,
  outline,
  text,
}

/// Button sizes
enum AppButtonSize { small, medium, large }

/// Icon position
enum IconPosition { left, right }

/// Icon button component
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final bool isLoading;
  final String? tooltip;
  final bool hasShadow;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 44,
    this.iconSize = 20,
    this.borderRadius = 12,
    this.isLoading = false,
    this.tooltip,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final isEnabled = onPressed != null && !isLoading;

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: (color ?? primaryColor).withOpacity(0.2),
        highlightColor: (color ?? primaryColor).withOpacity(0.1),
        child: Ink(
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                (isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: hasShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          color ?? primaryColor,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      size: iconSize,
                      color:
                          color ??
                          (isDark ? Colors.white70 : Colors.grey.shade700),
                    ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// Button group component
class AppButtonGroup extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;
  final bool expands;

  const AppButtonGroup({
    super.key,
    required this.children,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.spacing = 8,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        children: _buildChildren(children, spacing, expands),
      );
    } else {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        children: _buildChildren(children, spacing, expands),
      );
    }
  }

  List<Widget> _buildChildren(
    List<Widget> children,
    double spacing,
    bool expands,
  ) {
    final list = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0) {
        if (direction == Axis.horizontal) {
          list.add(SizedBox(width: spacing));
        } else {
          list.add(SizedBox(height: spacing));
        }
      }

      if (expands) {
        list.add(Expanded(child: children[i]));
      } else {
        list.add(children[i]);
      }
    }
    return list;
  }
}

/// Extension for easy access
extension AppButtonExtension on BuildContext {
  Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool fullWidth = false,
    double? width,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      variant: AppButtonVariant.primary,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      width: width,
      size: size,
    );
  }

  Widget secondaryButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool fullWidth = false,
    double? width,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      variant: AppButtonVariant.secondary,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      width: width,
      size: size,
    );
  }

  Widget dangerButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool fullWidth = false,
    double? width,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      variant: AppButtonVariant.danger,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      width: width,
      size: size,
    );
  }

  Widget successButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool fullWidth = false,
    double? width,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      variant: AppButtonVariant.success,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      width: width,
      size: size,
    );
  }

  Widget outlineButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool fullWidth = false,
    double? width,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      variant: AppButtonVariant.outline,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      width: width,
      size: size,
    );
  }

  Widget textButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      variant: AppButtonVariant.text,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      size: size,
    );
  }
}
