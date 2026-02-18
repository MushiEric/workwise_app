import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/constants/app_constant.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/core/provider/permission_provider.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';

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

/// Reusable drawer that lists `appMenus` and navigates to routes.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    // Header user info (prefer backend/currentUserProvider, fall back to auth state)
    final currentUserAsync = ref.watch(currentUserProvider);

    String headerName = 'Guest User';
    String headerEmail = 'guest@example.com';
    String? headerAvatar; // URL if available

    // Try backend-loaded user first (currentUserProvider returns Future<Either<Failure, User>>)
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

    // Fallback: use authNotifierProvider (local/session) when backend not available
    final authState = ref.watch(authNotifierProvider);
    authState.maybeWhen(
      authenticated: (u) {
        // only overwrite if backend didn't provide values
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
            // Simple white header: avatar, name and email (tappable -> Profile)
            Material(
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
                      // show user avatar if available, otherwise fall back to initials/icon
                      headerAvatar != null
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
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Divider(thickness: 1, height: 24, indent: 20, endIndent: 20),

            // Menu Title with icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Menu items with enhanced design
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: appMenus.length,
                separatorBuilder: (context, index) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final m = appMenus[index];
                  final checker = ref.watch(permissionCheckerProvider);

                  // Skip menus that require permissions the user doesn't have
                  if (m.requiredPermissions != null &&
                      m.requiredPermissions!.isNotEmpty &&
                      !checker.hasAnyPermission(m.requiredPermissions!)) {
                    return const SizedBox.shrink();
                  }

                  // Render grouped ExpansionTiles for specific menu ids
                  if (m.id == 'logistic') {
                    return _buildExpansionGroup(
                      context: context,
                      title: m.title,
                      icon: m.icon,
                      children: [
                        _DrawerChild(
                          title: 'Journey',
                          route: '/logistic/journey',
                          icon: Icons.timeline,
                        ),
                        _DrawerChild(
                          title: 'Trips',
                          route: '/logistic/trips',
                          icon: Icons.directions_car,
                        ),
                        _DrawerChild(
                          title: 'Vehicle',
                          route: '/logistic/vehicle',
                          icon: Icons.car_rental,
                        ),
                        _DrawerChild(
                          title: 'Operators',
                          route: '/logistic/operators',
                          icon: Icons.person,
                        ),
                        _DrawerChild(
                          title: 'Expenses',
                          route: '/logistic/expenses',
                          icon: Icons.receipt_long,
                        ),
                        _DrawerChild(
                          title: 'History',
                          route: '/logistic/history',
                          icon: Icons.history,
                        ),
                      ],
                    );
                  }

                  if (m.id == 'assets') {
                    return _buildExpansionGroup(
                      context: context,
                      title: m.title,
                      icon: m.icon,
                      children: [
                        _DrawerChild(
                          title: 'List',
                          route: '/assets/list',
                          icon: Icons.list,
                        ),
                        _DrawerChild(
                          title: 'Accessory',
                          route: '/assets/accessory',
                          icon: Icons.extension,
                        ),
                        _DrawerChild(
                          title: 'Components',
                          route: '/assets/components',
                          icon: Icons.widgets,
                        ),
                        _DrawerChild(
                          title: 'Activity Logs',
                          route: '/assets/activity-logs',
                          icon: Icons.history_toggle_off,
                        ),
                      ],
                    );
                  }

                  if (m.id == 'support') {
                    return _buildExpansionGroup(
                      context: context,
                      title: m.title,
                      icon: m.icon,
                      children: [
                        _DrawerChild(
                          title: 'Tickets',
                          route: '/support',
                          icon: Icons.confirmation_num_rounded,
                        ),
                        _DrawerChild(
                          title: 'Settings',
                          route: '/support/settings',
                          icon: Icons.settings,
                        ),
                      ],
                    );
                  }

                  // Default single menu tile
                  final isSelected = index == 0; // You can track selected index

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isSelected
                          ? primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor.withOpacity(0.15)
                              : (isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(14),
                          border: isSelected
                              ? Border.all(
                                  color: primaryColor.withOpacity(0.3),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Icon(
                          m.icon,
                          color: isSelected
                              ? primaryColor
                              : (isDark
                                    ? Colors.white70
                                    : Colors.grey.shade600),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        m.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? primaryColor
                                  : (isDark
                                        ? Colors.white
                                        : Colors.grey.shade800),
                              fontSize: 15,
                            ),
                      ),
                      trailing: isSelected
                          ? Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.5),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            )
                          : Icon(
                              Icons.chevron_right_rounded,
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade400,
                              size: 20,
                            ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, m.route);
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom Section with elegant design
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    isDark
                        ? Colors.white.withOpacity(0.02)
                        : Colors.grey.shade50,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),

              child: Column(
                children: [
                  // Logout Button with elegant styling
                  ListTile(
                    onTap: () => _showLogoutDialog(context, ref),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    title: Text(
                      'Sign Out',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    ),
                    tileColor: Colors.red.withOpacity(0.05),
                  ),

                  const SizedBox(height: 12),

                  // Version Info with elegant design
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
                              Icons.fiber_manual_record_rounded,
                              size: 8,
                              color: Colors.green.shade400,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppConstant.appVersion,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.grey.shade500,
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
            ),
          ],
        ),
      ),
    );
  }

  // Helper to render grouped menu (ExpansionTile)
  Widget _buildExpansionGroup({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<_DrawerChild> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        collapsedIconColor: isDark ? Colors.white54 : Colors.grey.shade400,
        childrenPadding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
        children: children.map((c) {
          return ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            leading: Icon(
              c.icon,
              size: 18,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
            title: Text(
              c.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, c.route);
            },
          );
        }).toList(),
      ),
    );
  }

  // helper for grouped menus (class moved to top-level)

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Sign Out',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close drawer

              // Perform logout and navigate to login route
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Sign Out',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
