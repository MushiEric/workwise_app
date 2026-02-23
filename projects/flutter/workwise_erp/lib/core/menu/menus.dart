import 'package:flutter/material.dart';
import 'menu_item.dart';

const List<MenuItemModel> appMenus = [
  // Sales: requires CRM/pos dashboard permission (server names vary) — accept either
  MenuItemModel(
    id: 'sales',
    title: 'Sales',
    icon: Icons.shopping_cart_outlined,
    route: '/sales',
    requiredPermissions: ['show crm dashboard', 'show pos dashboard'],
  ),

  // Customer management: allow everyone by default (no permission required)
  MenuItemModel(
    id: 'customer',
    title: 'Customers',
    icon: Icons.people_outline,
    route: '/customers',
    // optionally guard with CRM permission if desired:
    // requiredPermissions: ['show crm dashboard'],
  ),

  // Logistic: allow by default (no strict permission)
  MenuItemModel(id: 'logistic', title: 'Logistic', icon: Icons.local_shipping, route: '/logistic'),

  // Assets: allow by default
  MenuItemModel(id: 'assets', title: 'Assets', icon: Icons.inventory_2_outlined, route: '/assets'),

  // Inventory: allow users who can view invoices/accounts or inventory (no explicit permission in payload)
  MenuItemModel(id: 'inventory', title: 'Inventory', icon: Icons.storefront_outlined, route: '/inventory'),

  // Project: requires 'show project dashboard' — open projects list
  MenuItemModel(id: 'project', title: 'Project', icon: Icons.work_outline, route: '/projects', requiredPermissions: ['show project dashboard']),

  // Documents: open to everyone
  MenuItemModel(id: 'documents', title: 'Documents', icon: Icons.folder_open, route: '/documents'),

  // Support
  MenuItemModel(id: 'support', title: 'Support', icon: Icons.support_agent_outlined, route: '/support', requiredPermissions: ['show crm dashboard']),

  MenuItemModel(id: 'hr', title: 'HR', icon: Icons.people_outline, route: '/hr', requiredPermissions: ['show hrm dashboard']),

  // Jobcard: accept either 'show jobcard dashboard' or 'manage jobcard dashboard' (backend naming varies)
  MenuItemModel(id: 'jobcard', title: 'Jobcard', icon: Icons.assignment, route: '/jobcards', requiredPermissions: ['show jobcard dashboard', 'manage jobcard dashboard']),
];
