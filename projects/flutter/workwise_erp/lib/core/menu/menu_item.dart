import 'package:flutter/material.dart';

/// Small value object representing an app menu entry.
class MenuItemModel {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final List<String>? requiredPermissions; // optional list of permission names (server canonical)

  const MenuItemModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.requiredPermissions,
  });
}
