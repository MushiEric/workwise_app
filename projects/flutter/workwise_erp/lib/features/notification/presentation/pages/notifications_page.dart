import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';

// providers & models for notifications
import '../providers/notification_providers.dart';
import '../../domain/entities/notification.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabAnimationController;
  late final Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fabAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // watch the notifier state which holds the list of notifications
    final state = ref.watch(notificationsNotifierProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : Colors.grey.shade50,
      appBar: CustomAppBar(
        title: 'Notifications',
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.slidersHorizontal,
              color: isDark ? Colors.white70 : AppColors.white,
            ),
            onPressed: () => _showFilterDialog(context),
          ),
          // Stack(
          //   children: [
          //     IconButton(
          //       icon: Icon(
          //         LucideIcons.checkCheck,
          //         color: isDark ? Colors.white70 : AppColors.white,
          //       ),
          //       onPressed: unreadCount > 0
          //           ? () => _markAllAsRead()
          //           : null,
          //     ),
          //     if (unreadCount > 0)
          //       Positioned(
          //         top: 4,
          //         right: 4,
          //         child: Container(
          //           padding: const EdgeInsets.all(4),
          //           decoration: BoxDecoration(
          //             color: Colors.red,
          //             shape: BoxShape.circle,
          //           ),
          //           child: Text(
          //             unreadCount > 9 ? '9+' : '$unreadCount',
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontSize: 10,
          //             ),
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: Builder(
              builder: (context) {
                if (state.isLoading) {
                  return SliverFillRemaining(
                    child: LoadingWidget(message: 'Loading notifications...'),
                  );
                }

                if (state.error != null) {
                  return SliverFillRemaining(
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutQuad,
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: EmptyStateWidget(
                            icon: LucideIcons.alertCircle,
                            title: 'Oops!',
                            message: 'Failed to load notifications',
                            actionLabel: 'Retry',
                            onAction: () =>
                                ref.refresh(notificationsNotifierProvider),
                          ),
                        );
                      },
                    ),
                  );
                }

                final notifications = state.notifications;
                if (notifications.isEmpty) {
                  return SliverFillRemaining(
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutQuad,
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: EmptyStateWidget(
                            icon: LucideIcons.bellOff,
                            title: 'No Notifications',
                            message: 'You\'re all caught up!',
                          ),
                        );
                      },
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final notification = notifications[index];
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutQuad,
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(50 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: NotificationTile(
                              notification: notification,
                              onTap: () => _handleNotificationTap(notification),
                              onDismiss: () =>
                                  _dismissNotification(notification.id),
                            ),
                          ),
                        );
                      },
                    );
                  }, childCount: notifications.length),
                );
              },
            ),
          ),
        ],
      ),

      // Animated FAB for quick actions
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: _showQuickActions,
          backgroundColor: AppColors.primary,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: const Icon(LucideIcons.sparkles, color: Colors.white),
          label: const Text(
            'Quick Actions',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedFilter = ref.read(notificationFilterProvider);

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            LucideIcons.slidersHorizontal,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Filter Notifications',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildFilterOption(
                      context: context,
                      icon: LucideIcons.bell,
                      label: 'All',
                      value: 'all',
                      groupValue: selectedFilter,
                      onChanged: (value) {
                        ref.read(notificationFilterProvider.notifier).state =
                            value!;
                        Navigator.pop(context);
                      },
                    ),
                    _buildFilterOption(
                      context: context,
                      icon: LucideIcons.mailOpen,
                      label: 'Unread',
                      value: 'unread',
                      groupValue: selectedFilter,
                      onChanged: (value) {
                        ref.read(notificationFilterProvider.notifier).state =
                            value!;
                        Navigator.pop(context);
                      },
                    ),
                    _buildFilterOption(
                      context: context,
                      icon: LucideIcons.star,
                      label: 'Important',
                      value: 'important',
                      groupValue: selectedFilter,
                      onChanged: (value) {
                        ref.read(notificationFilterProvider.notifier).state =
                            value!;
                        Navigator.pop(context);
                      },
                    ),
                    _buildFilterOption(
                      context: context,
                      icon: LucideIcons.archive,
                      label: 'Archived',
                      value: 'archived',
                      groupValue: selectedFilter,
                      onChanged: (value) {
                        ref.read(notificationFilterProvider.notifier).state =
                            value!;
                        Navigator.pop(context);
                      },
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

  Widget _buildFilterOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = groupValue == value;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.2)
                : isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColors.primary : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? AppColors.primary
                : isDark
                ? Colors.white70
                : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF151A2E)
          : Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    // gradient: const LinearGradient(
                    //   colors: [AppColors.primary, AppColors.primaryDark],
                    // ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.sparkles,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Quick Actions',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildQuickActionTile(
              context: context,
              icon: LucideIcons.checkCheck,
              label: 'Mark all as read',
              color: AppColors.muted,
              onTap: () {
                Navigator.pop(context);
                _markAllAsRead();
              },
            ),
            _buildQuickActionTile(
              context: context,
              icon: LucideIcons.archive,
              label: 'Archive all read',
              color: AppColors.muted,
              onTap: () {
                Navigator.pop(context);
                _archiveAllRead();
              },
            ),
            _buildQuickActionTile(
              context: context,
              icon: LucideIcons.bellOff,
              label: 'Mute for 1 hour',
              color: AppColors.muted,
              onTap: () {
                Navigator.pop(context);
                _muteNotifications();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.chevronRight, size: 16),
        ),
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification) {
    // locally mark as opened; server side not implemented
    ref
        .read(notificationsNotifierProvider.notifier)
        .markOpenedLocally(notification.id);
    // Navigate to relevant screen based on notification type
  }

  void _dismissNotification(int id) {
    ref.read(notificationsNotifierProvider.notifier).dismiss(id);
  }

  void _markAllAsRead() {
    ref.read(notificationsNotifierProvider.notifier).markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(LucideIcons.checkCircle, color: Colors.white),
            SizedBox(width: 12),
            Text('All notifications marked as read'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _archiveAllRead() {
    ref.read(notificationsNotifierProvider.notifier).archiveAllRead();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(LucideIcons.archive, color: Colors.white),
            SizedBox(width: 12),
            Text('All read notifications archived'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _muteNotifications() {
    ref
        .read(notificationsNotifierProvider.notifier)
        .muteForDuration(const Duration(hours: 1));
  }
}

// -----------------------------------------------------------------------------
// Helper widgets used by NotificationsPage
// -----------------------------------------------------------------------------

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String message;
  const LoadingWidget({Key? key, required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(message),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationTile({
    Key? key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(notification.title),
        subtitle: Text(
          notification.message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '${notification.createdAt.hour.toString().padLeft(2, '0')}:${notification.createdAt.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        tileColor: notification.isOpened
            ? null
            : (isDark ? Colors.white10 : Colors.grey.shade100),
      ),
    );
  }
}
