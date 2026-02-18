import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/app_colors.dart';

/// A stunning, reusable modal sheet for the ERP app
class AppModal {
  /// Show a bottom sheet with various styles
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    List<Widget>? actions,
    bool showCloseButton = true,
    bool isDismissible = true,
    double? height,
    EdgeInsets padding = const EdgeInsets.all(24),
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Widget? headerWidget,
    List<Widget>? bottomWidgets,
    bool useSafeArea = true,
    bool expandContent = false,
    AnimationStyle? animationStyle,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      // animationStyle: animationStyle ?? AnimationStyle(
      //   duration: const Duration(milliseconds: 400),
      //   curve: Curves.easeOutCubic,
      // ),
      builder: (context) => _AppModalContent(
        title: title,
        subtitle: subtitle,
        icon: icon,
        iconColor: iconColor,
        content: content,
        actions: actions,
        showCloseButton: showCloseButton,
        height: height,
        padding: padding,
        backgroundColor: backgroundColor,
        backgroundGradient: backgroundGradient,
        headerWidget: headerWidget,
        bottomWidgets: bottomWidgets,
        useSafeArea: useSafeArea,
        expandContent: expandContent,
      ),
    );
  }

  /// Show an information modal
  static Future<T?> showInfo<T>({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    IconData icon = Icons.info_rounded,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return show<T>(
      context: context,
      title: title,
      icon: icon,
      iconColor: primaryColor,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
            fontSize: 15,
          ),
        ),
      ),
      actions: [
        if (buttonText != null)
          ElevatedButton(
            onPressed: onButtonPressed ?? () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }

  /// Show a success modal
  static Future<T?> showSuccess<T>({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return show<T>(
      context: context,
      title: title,
      icon: Icons.check_circle_rounded,
      iconColor: Colors.green,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
      actions: [
        if (buttonText != null)
          ElevatedButton(
            onPressed: onButtonPressed ?? () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }

  /// Show a warning/confirmation modal
  static Future<T?> showConfirmation<T>({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    String? cancelText,
    IconData icon = Icons.warning_rounded,
    Color? confirmColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmButtonColor = confirmColor ?? Colors.red;

    return show<T>(
      context: context,
      title: title,
      icon: icon,
      iconColor: confirmButtonColor,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
            fontSize: 15,
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  cancelText ?? 'Cancel',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmButtonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  confirmText,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Show a form modal
  static Future<T?> showForm<T>({
    required BuildContext context,
    required String title,
    required Widget form,
    required VoidCallback onSubmit,
    String submitText = 'Submit',
    String? cancelText,
    bool isLoading = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return show<T>(
      context: context,
      title: title,
      expandContent: true,
      content: form,
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  cancelText ?? 'Cancel',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(submitText),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Show a menu modal with options
  static Future<T?> showMenu<T>({
    required BuildContext context,
    required String title,
    required List<AppModalMenuItem> items,
    String? subtitle,
  }) {
    return show<T>(
      context: context,
      title: title,
      subtitle: subtitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) => _buildMenuItem(context, item)).toList(),
      ),
    );
  }

  static Widget _buildMenuItem(BuildContext context, AppModalMenuItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            item.onTap?.call();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (item.iconColor ?? primaryColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.iconColor ?? primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2634),
                            ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show a full-screen modal
  static Future<T?> showFullScreen<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool showCloseButton = true,
    Color? backgroundColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: _AppModalFullScreen(
          title: title,
          content: content,
          actions: actions,
          showCloseButton: showCloseButton,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}

/// Menu item for AppModal menu
class AppModalMenuItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const AppModalMenuItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onTap,
  });
}

// Private widget for modal content
class _AppModalContent extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final double? height;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Widget? headerWidget;
  final List<Widget>? bottomWidgets;
  final bool useSafeArea;
  final bool expandContent;

  const _AppModalContent({
    required this.title,
    required this.content,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.actions,
    this.showCloseButton = true,
    this.height,
    this.padding = const EdgeInsets.all(24),
    this.backgroundColor,
    this.backgroundGradient,
    this.headerWidget,
    this.bottomWidgets,
    this.useSafeArea = true,
    this.expandContent = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final modalBackgroundColor =
        backgroundColor ?? (isDark ? const Color(0xFF151A2E) : Colors.white);
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Container(
        height: height ?? (expandContent ? mediaQuery.size.height * 0.9 : null),
        constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.95),
        decoration: BoxDecoration(
          color: modalBackgroundColor,
          gradient: backgroundGradient,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: useSafeArea
            ? SafeArea(
                top: false,
                bottom: true,
                child: _buildContent(context, bottomPadding),
              )
            : _buildContent(context, bottomPadding),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double bottomPadding) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag Handle
        Container(
          margin: const EdgeInsets.only(top: 12),
          child: Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),

        // Header
        if (headerWidget != null)
          headerWidget!
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (iconColor ?? primaryColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A2634),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showCloseButton)
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Close',
                    ),
                  ),
              ],
            ),
          ),

        // Content
        if (expandContent)
          Expanded(
            child: SingleChildScrollView(padding: padding, child: content),
          )
        else
          Flexible(
            child: SingleChildScrollView(padding: padding, child: content),
          ),

        // Bottom Widgets (before actions)
        if (bottomWidgets != null) ...bottomWidgets!,

        // Actions
        if (actions != null) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 24, bottomPadding + 16),
            child: Column(children: actions!),
          ),
        ] else if (bottomPadding > 0) ...[
          SizedBox(height: bottomPadding),
        ],
      ],
    );
  }
}

// Full screen modal
class _AppModalFullScreen extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final Color? backgroundColor;

  const _AppModalFullScreen({
    required this.title,
    required this.content,
    this.actions,
    this.showCloseButton = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modalBackgroundColor =
        backgroundColor ??
        (isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC));

    return Scaffold(
      backgroundColor: modalBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showCloseButton
            ? IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDark ? Colors.white : const Color(0xFF1A2634),
          ),
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: content,
    );
  }
}

/// Extension for easy access
extension AppModalExtension on BuildContext {
  Future<T?> showAppModal<T>({
    required String title,
    required Widget content,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    List<Widget>? actions,
    bool showCloseButton = true,
    bool isDismissible = true,
    double? height,
    EdgeInsets padding = const EdgeInsets.all(24),
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Widget? headerWidget,
    List<Widget>? bottomWidgets,
    bool useSafeArea = true,
    bool expandContent = false,
  }) {
    return AppModal.show(
      context: this,
      title: title,
      content: content,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      actions: actions,
      showCloseButton: showCloseButton,
      isDismissible: isDismissible,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      headerWidget: headerWidget,
      bottomWidgets: bottomWidgets,
      useSafeArea: useSafeArea,
      expandContent: expandContent,
    );
  }

  Future<T?> showInfoModal<T>({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    IconData icon = Icons.info_rounded,
  }) {
    return AppModal.showInfo(
      context: this,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      icon: icon,
    );
  }

  Future<T?> showSuccessModal<T>({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return AppModal.showSuccess(
      context: this,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }

  Future<T?> showConfirmationModal<T>({
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    String? cancelText,
    IconData icon = Icons.warning_rounded,
    Color? confirmColor,
  }) {
    return AppModal.showConfirmation(
      context: this,
      title: title,
      message: message,
      confirmText: confirmText,
      onConfirm: onConfirm,
      cancelText: cancelText,
      icon: icon,
      confirmColor: confirmColor,
    );
  }

  Future<T?> showFormModal<T>({
    required String title,
    required Widget form,
    required VoidCallback onSubmit,
    String submitText = 'Submit',
    String? cancelText,
    bool isLoading = false,
  }) {
    return AppModal.showForm(
      context: this,
      title: title,
      form: form,
      onSubmit: onSubmit,
      submitText: submitText,
      cancelText: cancelText,
      isLoading: isLoading,
    );
  }

  Future<T?> showMenuModal<T>({
    required String title,
    required List<AppModalMenuItem> items,
    String? subtitle,
  }) {
    return AppModal.showMenu(
      context: this,
      title: title,
      items: items,
      subtitle: subtitle,
    );
  }
}
