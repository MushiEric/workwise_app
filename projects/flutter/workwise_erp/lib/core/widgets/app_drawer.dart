import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workwise_erp/core/constants/app_constant.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/core/provider/permission_provider.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';

import '../menu/menus.dart';
import '../themes/app_colors.dart';

// Simple child descriptor for grouped menus used by AppDrawer
class _DrawerChild {
  final String title;
  final String route;
  final IconData icon;
  const _DrawerChild({
    required this.title,
    required this.route,
    required this.icon,
  });
}

/// Stunning drawer with LucideIcons and smooth animations
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Header user info
    final currentUserAsync = ref.watch(currentUserProvider);

    String headerName = 'Guest User';
    String headerEmail = 'guest@example.com';
    String? headerAvatar;

    currentUserAsync.maybeWhen(
      data: (either) {
        either.fold((_) => null, (u) {
          headerName = u.name ?? headerName;
          headerEmail = u.email ?? headerEmail;
          headerAvatar = (u.avatar != null && u.avatar!.isNotEmpty)
              ? u.avatar
              : headerAvatar;
        });
      },
      orElse: () {},
    );

    final authState = ref.watch(authNotifierProvider);
    authState.maybeWhen(
      authenticated: (u) {
        headerName = (headerName == 'Guest User')
            ? (u.name ?? headerName)
            : headerName;
        headerEmail = (headerEmail == 'guest@example.com')
            ? (u.email ?? headerEmail)
            : headerEmail;
        headerAvatar =
            headerAvatar ??
            ((u.avatar != null && u.avatar!.isNotEmpty) ? u.avatar : null);
      },
      orElse: () {},
    );

    return Drawer(
      elevation: 20,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      backgroundColor: isDark ? const Color(0xFF0A0E21) : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAnimatedHeader(
              context: context,
              isDark: isDark,
              headerName: headerName,
              headerEmail: headerEmail,
              headerAvatar: headerAvatar,
            ),

            const SizedBox(height: 16),

            _buildDivider(isDark),

            _buildMenuHeader(isDark, context),

            const SizedBox(height: 12),

            // Menu items with animations
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: appMenus.length,
                separatorBuilder: (context, index) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final m = appMenus[index];
                  final checker = ref.watch(permissionCheckerProvider);

                  if (m.requiredPermissions != null &&
                      m.requiredPermissions!.isNotEmpty &&
                      !checker.hasAnyPermission(m.requiredPermissions!)) {
                    return const SizedBox.shrink();
                  }

                  if (m.id == 'logistic') {
                    return _buildAnimatedExpansionGroup(
                      context: context,
                      title: m.title,
                      icon: _getLucideIconForLogistic(),
                      children: [
                        _DrawerChild(
                          title: 'Journey',
                          route: '/logistic/journey',
                          icon: LucideIcons.map,
                        ),
                        _DrawerChild(
                          title: 'Trips',
                          route: '/logistic/trips',
                          icon: LucideIcons.truck,
                        ),
                        _DrawerChild(
                          title: 'Vehicle',
                          route: '/logistic/vehicle',
                          icon: LucideIcons.car,
                        ),
                        _DrawerChild(
                          title: 'Operators',
                          route: '/logistic/operators',
                          icon: LucideIcons.users,
                        ),
                        _DrawerChild(
                          title: 'Expenses',
                          route: '/logistic/expenses',
                          icon: LucideIcons.receipt,
                        ),
                        _DrawerChild(
                          title: 'History',
                          route: '/logistic/history',
                          icon: LucideIcons.history,
                        ),
                      ],
                    );
                  }

                  if (m.id == 'support') {
                    return _buildAnimatedExpansionGroup(
                      context: context,
                      title: m.title,
                      icon: LucideIcons.heading,
                      children: [
                        _DrawerChild(
                          title: 'Tickets',
                          route: '/support',
                          icon: LucideIcons.ticket,
                        ),
                        _DrawerChild(
                          title: 'Settings',
                          route: '/support/settings',
                          icon: LucideIcons.settings,
                        ),
                      ],
                    );
                  }

                  // Default single menu tile with animation
                  return _buildAnimatedMenuItem(
                    context: context,
                    isDark: isDark,
                    icon: _getLucideIconForMenu(m.id),
                    title: m.title,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, m.route);
                    },
                  );
                },
              ),
            ),

            // Bottom Section
            _buildBottomSection(context, ref, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader({
    required BuildContext context,
    required bool isDark,
    required String headerName,
    required String headerEmail,
    String? headerAvatar,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuad,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Material(
              color: AppColors.white,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
                child: Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      // Avatar with glow effect
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: headerAvatar != null
                            ? CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                backgroundImage: imageProviderFromUrl(
                                  headerAvatar,
                                ),
                              )
                            : CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  headerName.isNotEmpty
                                      ? headerName[0].toUpperCase()
                                      : 'U',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              headerName,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: const Color(0xFF1A2634),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              headerEmail,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Edit profile indicator
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.chevronRight,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Divider(thickness: 1, height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: isDark ? const Color(0xFF0A0E21) : Colors.white,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader(bool isDark, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.layoutDashboard,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.l10n.mainMenu,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMenuItem({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            icon,
                            color: isDark
                                ? Colors.white70
                                : Colors.grey.shade600,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.grey.shade800,
                                  fontSize: 15,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.03)
                                : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.chevronRight,
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.shade400,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedExpansionGroup({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<_DrawerChild> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.03)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.grey.shade800,
                    ),
                  ),
                  collapsedIconColor: isDark
                      ? Colors.white54
                      : Colors.grey.shade400,
                  iconColor: AppColors.primary,
                  childrenPadding: const EdgeInsets.only(
                    left: 16,
                    right: 8,
                    bottom: 8,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.centerLeft,
                  children: children.map((c) {
                    return _buildAnimatedSubMenuItem(
                      context: context,
                      isDark: isDark,
                      child: c,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSubMenuItem({
    required BuildContext context,
    required bool isDark,
    required _DrawerChild child,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
      builder: (context, double value, childWidget) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              leading: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.02)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  child.icon,
                  size: 16,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
              title: Text(
                child.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, child.route);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection(BuildContext context, WidgetRef ref, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            isDark ? Colors.white.withOpacity(0.02) : Colors.grey.shade50,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Logout Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showLogoutDialog(context, ref),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.logOut,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.signOut,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.red,
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.chevronRight,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Version Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.circle,
                      size: 8,
                      color: Colors.green.shade400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Version ${AppConstant.appVersion}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper to map menu IDs to LucideIcons
  IconData _getLucideIconForMenu(String menuId) {
    switch (menuId) {
      case 'dashboard':
        return LucideIcons.layoutDashboard;
      case 'logistic':
        return LucideIcons.truck;
      case 'assets':
        return LucideIcons.package;
      case 'support':
        return LucideIcons.helpingHand;
      case 'settings':
        return LucideIcons.settings;
      case 'reports':
        return LucideIcons.fileText;
      case 'users':
        return LucideIcons.users;
      default:
        return LucideIcons.circle;
    }
  }

  IconData _getLucideIconForLogistic() {
    return LucideIcons.truck;
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.logOut,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.signOut,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.signOutMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              context.l10n.back,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              await ref
                                  .read(authNotifierProvider.notifier)
                                  .logout();
                              if (context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/',
                                  (route) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              context.l10n.signOut,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
