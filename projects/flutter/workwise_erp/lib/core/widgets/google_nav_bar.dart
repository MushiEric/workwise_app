import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

/// A small wrapper around the popular `google_nav_bar` package.
///
/// Use this for consistent bottom navigation styling across the app.
class AppGoogleNavBar extends StatelessWidget {
  /// The currently active tab index.
  final int selectedIndex;

  /// Called when a tab is selected.
  final ValueChanged<int> onTabChange;

  /// The items to render.
  final List<AppGoogleNavBarItem> items;

  /// Background for the entire bar.
  final Color? backgroundColor;

  /// Background for the selected tab.
  final Color? activeTabBackgroundColor;

  /// Color for icons/text when not selected.
  final Color? color;

  /// Color of the selected icon/text.
  final Color? activeColor;

  /// The padding within each tab.
  final EdgeInsetsGeometry? tabPadding;

  const AppGoogleNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.items,
    this.backgroundColor,
    this.activeTabBackgroundColor,
    this.color,
    this.activeColor,
    this.tabPadding,
  }) : assert(items.length >= 2, 'At least two items are required');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final defaultBg =
        theme.bottomAppBarTheme.color ?? theme.colorScheme.surface;

    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        color: backgroundColor ?? defaultBg,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: GNav(
          gap: 8,
          padding: tabPadding ??
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          activeColor: activeColor ?? theme.colorScheme.primary,
          color: color ?? theme.colorScheme.onSurface.withOpacity(0.8),
          tabBackgroundColor: activeTabBackgroundColor ??
              theme.colorScheme.primary.withOpacity(0.12),
          tabMargin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          selectedIndex: selectedIndex,
          onTabChange: (index) => onTabChange(index),
          tabs: items
              .map(
                (item) => GButton(
                  icon: item.icon,
                  iconSize: item.iconSize,
                  iconColor: item.iconColor,
                  iconActiveColor: item.activeIconColor,
                  text: item.label,
                  textStyle: item.textStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                  leading: item.leading,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class AppGoogleNavBarItem {
  /// Text label shown underneath the icon.
  final String label;

  /// The icon shown for this tab.
  final IconData icon;

  /// When set, this icon color is used while selected.
  final Color? activeIconColor;

  /// When set, this icon color is used while unselected.
  final Color? iconColor;

  /// Optional leading widget; useful for badges.
  final Widget? leading;

  /// Optional explicit text style.
  final TextStyle? textStyle;

  /// Optional override for icon size.
  final double? iconSize;

  /// Optional additional padding around the icon.
  final EdgeInsets? iconSizePadding;

  const AppGoogleNavBarItem({
    required this.label,
    required this.icon,
    this.activeIconColor,
    this.iconColor,
    this.leading,
    this.textStyle,
    this.iconSize,
    this.iconSizePadding,
  });
}
