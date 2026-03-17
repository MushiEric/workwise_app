import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';
import 'package:workwise_erp/core/widgets/shimmer.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';

import '../providers/notification_providers.dart';
import '../../domain/entities/notification.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0E21)
          : const Color(0xFFF8F9FC),
      appBar: CustomAppBar(
        title: context.l10n.notifications,
        actions: [
          if (ref.watch(unreadNotificationsCountProvider) > 0)
            Builder(
              builder: (context) {
                final isSwahili =
                    Localizations.localeOf(context).languageCode == 'sw';
                return isSwahili
                    ? IconButton(
                        tooltip: context.l10n.markAllRead,
                        onPressed: () => ref
                            .read(notificationsNotifierProvider.notifier)
                            .markAllAsRead(),
                        icon: const Icon(
                          LucideIcons.checkCheck,
                          size: 18,
                          color: Colors.white,
                        ),
                      )
                    : TextButton.icon(
                        onPressed: () => ref
                            .read(notificationsNotifierProvider.notifier)
                            .markAllAsRead(),
                        icon: const Icon(
                          LucideIcons.checkCheck,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          context.l10n.markAllRead,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      );
              },
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, __) => const _NotificationSkeletonCard(),
            );
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.failedToLoad,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        ref.invalidate(notificationsNotifierProvider),
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }

          final notifications = state.notifications;
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.bellOff,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(height: 6),
                  Text(
                    context.l10n.noNotificationsToShow,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _NotificationCard(
                notification: notifications[index],
                onTap: () => _showDetail(context, notifications[index]),
                onDismiss: () => ref
                    .read(notificationsNotifierProvider.notifier)
                    .dismiss(notifications[index].id),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, AppNotification n) {
    // Mark as opened
    ref.read(notificationsNotifierProvider.notifier).markOpenedLocally(n.id);

    // Strip HTML tags for plain text
    String plainText = n.message
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.bell,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      n.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(LucideIcons.x, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _formatDateTime(context, n.createdAt),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const Divider(height: 24),
              // Message body
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Text(
                    plainText,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                ),
              ),
              // Navigate button — shown whenever we can route to the related record
              if (n.jobcardId != null ||
                  n.ticketId != null ||
                  (n.redirectLink != null && n.redirectLink!.isNotEmpty)) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(LucideIcons.externalLink, size: 16),
                    label: Text(context.l10n.viewDetails),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _navigateTo(context, n);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, AppNotification n) {
    // 1. Jobcard — explicit ID from the backend payload (fastest path).
    if (n.jobcardId != null) {
      Navigator.pushNamed(context, '/jobcards/detail', arguments: n.jobcardId);
      return;
    }

    // 2. Support ticket — navigate to the support list.
    if (n.ticketId != null) {
      Navigator.pushNamed(context, '/support');
      return;
    }

    // 3. Fallback: parse whatever `redirectLink` contains and route sensibly.
    final link = n.redirectLink;
    if (link == null || link.isEmpty) return;

    final uri = Uri.tryParse(link);
    final path = (uri?.path ?? link).toLowerCase();

    // Backend may send paths like /logistic/job_card, /jobcard/detail/42,
    // /job_card, etc.  Match all variants.
    final isJobcard =
        path.contains('jobcard') ||
        path.contains('job_card') ||
        path.contains('job-card');

    if (isJobcard) {
      // Try ?id= query param first, then the last numeric path segment.
      final idParam = uri?.queryParameters['id'];
      int? parsedId = idParam != null ? int.tryParse(idParam) : null;
      if (parsedId == null) {
        final segments = uri?.pathSegments ?? [];
        for (final seg in segments.reversed) {
          final n = int.tryParse(seg);
          if (n != null && n > 0) {
            parsedId = n;
            break;
          }
        }
      }
      if (parsedId != null && parsedId > 0) {
        Navigator.pushNamed(context, '/jobcards/detail', arguments: parsedId);
      } else {
        Navigator.pushNamed(context, '/jobcards');
      }
      return;
    }

    // Support / CRM / ticket path.
    if (path.contains('support') ||
        path.contains('ticket') ||
        path.contains('crm')) {
      Navigator.pushNamed(context, '/support');
      return;
    }

    // Known app routes — push by name only if the route is registered.
    const _knownRoutes = {
      '/jobcards',
      '/jobcards/detail',
      '/jobcards/create',
      '/support',
      '/logistic',
      '/logistic/trips',
      '/index',
      '/notifications',
      '/profile',
    };
    final cleanPath = uri?.path ?? link;
    if (_knownRoutes.contains(cleanPath)) {
      Navigator.pushNamed(context, cleanPath);
    }
    // Silently ignore unknown server-side paths to avoid a crash.
  }

  String _formatDateTime(BuildContext context, DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    final l10n = context.l10n;
    if (diff.inSeconds < 60) return l10n.justNow;
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
    if (diff.inDays == 1) return l10n.yesterday;
    if (diff.inDays < 7) return l10n.daysAgo(diff.inDays);
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ---------------------------------------------------------------------------

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUnread = !notification.isOpened;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Dismissible(
        key: ValueKey(notification.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDismiss(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red.shade400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.trash2, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                context.l10n.delete,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.35)
                      : Colors.black.withOpacity(0.06),
                  spreadRadius: 1,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isUnread
                        ? AppColors.primary.withOpacity(0.15)
                        : (isDark ? Colors.white12 : Colors.grey.shade100),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.bell,
                    size: 20,
                    color: isUnread
                        ? AppColors.primary
                        : (isDark ? Colors.white54 : Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A2634),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _timeAgo(context, notification.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _plainText(notification.message),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Unread dot
                if (isUnread)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _timeAgo(BuildContext context, DateTime dt) {
    final diff = DateTime.now().difference(dt);
    final l10n = context.l10n;
    if (diff.inSeconds < 60) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHours(diff.inHours);
    if (diff.inDays < 7) return l10n.timeDays(diff.inDays);
    return '${dt.day}/${dt.month}';
  }

  String _plainText(String html) => html
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ')
      .replaceAll(RegExp(r'<[^>]*>'), '');
}

class _NotificationSkeletonCard extends StatelessWidget {
  const _NotificationSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer(
        child: Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151A2E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.35)
                        : Colors.black.withOpacity(0.06),
                    spreadRadius: 1,
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
