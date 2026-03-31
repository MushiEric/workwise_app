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

  // MenuItemModel(
  //   id: 'customer',
  //   title: 'Customers',
  //   icon: Icons.people_outline,
  //   route: '/customers',
  // ),

  // MenuItemModel(
  //   id: 'logistic',
  //   title: 'Logistic',
  //   icon: Icons.local_shipping,
  //   route: '/logistic',
  //   requiredPermissions: ['show logistic dashboard'],
  // ),

  // MenuItemModel(
  //   id: 'project',
  //   title: 'Project',
  //   icon: Icons.work_outline,
  //   route: '/projects',
  //   requiredPermissions: ['show project dashboard'],
  // ),

  // MenuItemModel(
  //   id: 'documents',
  //   title: 'Documents',
  //   icon: Icons.folder_open,
  //   route: '/documents',
  // ),

  MenuItemModel(
    id: 'support',
    title: 'Support',
    icon: Icons.support_agent_outlined,
    route: '/support',
    requiredPermissions: ['show crm dashboard'],
  ),

  // MenuItemModel(
  //   id: 'hr',
  //   title: 'Human Resource',
  //   icon: Icons.people_outline,
  //   route: '/hr',
  //   requiredPermissions: ['show hrm dashboard'],
  // ),

  MenuItemModel(
    id: 'jobcard',
    title: 'Jobcard',
    icon: Icons.assignment,
    route: '/jobcards',
    requiredPermissions: ['show jobcard dashboard', 'manage jobcard dashboard'],
  ),
];
