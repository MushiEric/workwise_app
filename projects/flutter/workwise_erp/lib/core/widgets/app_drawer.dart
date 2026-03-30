import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workwise_erp/core/constants/app_constant.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/core/provider/permission_provider.dart';
import 'package:workwise_erp/core/widgets/app_circle_avatar.dart';
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
    final authState = ref.watch(authNotifierProvider);

    // Prefer the authenticated user from auth state (ensures immediate update on login/logout).
    // Fall back to the cached current user response when auth state is not yet populated.
    String headerName = 'Guest User';
    String headerEmail = 'guest@example.com';
    String? headerAvatar;

    bool hasAuthUser = false;
    authState.maybeWhen(
      authenticated: (u) {
        hasAuthUser = true;
        headerName = u.name ?? headerName;
        headerEmail = u.email ?? headerEmail;
        headerAvatar = (u.avatar != null && u.avatar!.isNotEmpty)
            ? u.avatar
            : null;
      },
      orElse: () {},
    );

    if (!hasAuthUser) {
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
    }

    final headerColor = isDark ? const Color(0xFF10163B) : AppColors.primary;

    return Drawer(
      elevation: 20,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      // Body is white so the bottom navigation bar area never shows primary colour.
      // The header extends into the top status-bar area via explicit padding below.
      backgroundColor: isDark ? const Color(0xFF0A0E21) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAnimatedHeader(
            context: context,
            isDark: isDark,
            headerColor: headerColor,
            headerName: headerName,
            headerEmail: headerEmail,
            headerAvatar: headerAvatar,
          ),
          Expanded(
            child: Container(
              // Keep the drawer content background consistent with light/dark mode.
              color: isDark ? const Color(0xFF0A0E21) : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  _buildDivider(isDark),
                  _buildMenuHeader(isDark, context),
                  const SizedBox(height: 12),
                  // Menu items with animations
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: appMenus.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 2),
                      itemBuilder: (context, index) {
                        final m = appMenus[index];
                        final checker = ref.watch(permissionCheckerProvider);

                        if (m.requiredPermissions != null &&
                            m.requiredPermissions!.isNotEmpty &&
                            !checker.hasAnyPermission(m.requiredPermissions!)) {
                          return const SizedBox.shrink();
                        }

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
                  // Bottom Section (includes bottom safe-area padding so white fills to edge)
                  _buildBottomSection(context, ref, isDark),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedHeader({
    required BuildContext context,
    required bool isDark,
    required Color headerColor,
    required String headerName,
    required String headerEmail,
    String? headerAvatar,
  }) {
    String initials0(String name) {
      final parts = name.trim().split(RegExp(r"\s+"));
      if (parts.isEmpty) return 'U';
      if (parts.length == 1) return parts.first[0].toUpperCase();
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    final initials = initials0(headerName);

    final imageProvider = headerAvatar != null
        ? imageProviderFromUrl(headerAvatar)
        : null;

    return Material(
      color: headerColor,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/profile');
        },
        child: Container(
          // Top padding absorbs status-bar height so header colour fills to screen edge.
          padding: EdgeInsets.fromLTRB(
            20,
            22 + MediaQuery.of(context).padding.top,
            20,
            22,
          ),
          decoration: BoxDecoration(
            color: headerColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Row(
            children: [
              // Avatar / initials
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AppCircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  initials: initials,
                  imageUrl: headerAvatar,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      headerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      headerEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
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
    final shareBg = isDark
        ? Colors.white12
        : AppColors.primary.withOpacity(0.05);
    final shareIconBg = isDark
        ? Colors.white10
        : AppColors.primary.withOpacity(0.15);
    final shareTextColor = isDark ? Colors.white : AppColors.primary;

    final logoutBg = isDark ? Colors.white12 : Colors.red.withOpacity(0.05);
    final logoutIconBg = isDark ? Colors.white10 : Colors.red.withOpacity(0.1);
    final logoutTextColor = isDark ? Colors.white : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDark ? const Color(0xFF0A0E21) : Colors.white,
            isDark ? const Color(0xFF0A0E21) : Colors.grey.shade50,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Share App
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _inviteFriends(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: shareBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: shareIconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.share2,
                        color: shareTextColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.shareApp,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: shareTextColor,
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white10
                            : AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.chevronRight,
                        color: shareTextColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

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
                  color: logoutBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: logoutIconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.logOut,
                        color: logoutTextColor,
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
                              color: logoutTextColor,
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: logoutIconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.chevronRight,
                        color: logoutTextColor,
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
      case 'jobcard':
        return LucideIcons.fileText;
      case 'users':
        return LucideIcons.users;
      default:
        return LucideIcons.circle;
    }
  }

  Future<void> _inviteFriends(BuildContext context) async {
    final appName = context.l10n.appName;
    final baseDescription =
        'An AI-powered software built to help you and your team stay organized, automate work and streamline your operations.';

    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    final mobileExtras =
        '\n\nMobile highlights: offline sync, push notifications, quick task assignment, built-in timesheets.';

    final shareText = isMobile
        ? '$appName — $baseDescription$mobileExtras\n\nDownload now: https://play.google.com/store/apps/details?id=com.getcoregroup.workwise'
        : '$appName — $baseDescription\n\nDownload now: https://play.google.com/store/apps/details?id=com.getcoregroup.workwise';

    final subject = 'Try $appName — team productivity & operations';

    try {
      await SharePlus.instance.share(
        ShareParams(text: shareText, subject: subject),
      );
    } catch (e) {
      // Fallback: copy invite text to clipboard when share sheet isn't available
      try {
        await Clipboard.setData(ClipboardData(text: shareText));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Share dialog unavailable — invite text copied to clipboard',
              ),
            ),
          );
        }
      } catch (_) {
        if (context.mounted) {
          final message = kDebugMode
              ? 'Could not share or copy invite text: ${e.toString()}'
              : 'Could not share invite. Please try again.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(message),
            ),
          );
        }
      }
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
