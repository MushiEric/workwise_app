import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Semantic icon tokens — prefer `LucideIcons` here so the app can migrate
/// icon usage in a single place.
class AppIcons {
  AppIcons._();

  static const IconData menu = LucideIcons.menu;
  static const IconData search = LucideIcons.search;
  static const IconData plus = LucideIcons.plus;
  static const IconData bell = LucideIcons.bell;
  static const IconData user = LucideIcons.user;
  static const IconData x = LucideIcons.x;
  static const IconData moreHorizontal = LucideIcons.moreHorizontal;
}

/// Lightweight icon wrapper (keeps sizing/color consistent)
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = 20,
    this.color,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Icon(
        icon,
        size: size,
        color: color ?? Theme.of(context).iconTheme.color,
      ),
    );
  }
}
