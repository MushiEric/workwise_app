import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final double? leadingWidth;
  final bool automaticallyImplyLeading;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final double height;
  final Widget? titleWidget;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.leadingWidth,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.bottom,
    this.height = kToolbarHeight,
    this.titleWidget,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title:
          titleWidget ??
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color:
                  foregroundColor ??
                  (isDark ? Colors.white : AppColors.white),
            ),
          ),
      actions: actions,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      leadingWidth: leadingWidth,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation,
      backgroundColor:
          backgroundColor ??
          (isDark ? const Color(0xFF0A0E21) : AppColors.primary),
      foregroundColor:
          foregroundColor ?? (isDark ? Colors.white : AppColors.primary),
      centerTitle: centerTitle,
      bottom: bottom,
    
    );
  }

  Widget? _buildBackButton(BuildContext context) {
    final canPop = Navigator.canPop(context);
    if (!canPop) return null;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 18,
        color: foregroundColor ??
            (isDark ? Colors.white70 : AppColors.white),
      ),
      // icon: Container(
      //   padding: const EdgeInsets.all(8),
      //   decoration: BoxDecoration(
      //     color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade100,
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      //   child: Icon(
      //     Icons.arrow_back_ios_new_rounded,
      //     size: 18,
      //     color: isDark ? Colors.white70 : Colors.grey.shade700,
      //   ),
      // ),
      onPressed: () => Navigator.pop(context),
      tooltip: 'Back',
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));
}
