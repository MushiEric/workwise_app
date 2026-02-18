import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';

import '../providers/notification_providers.dart';


class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsNotifierProvider.notifier).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(title:'Notifications'),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationsNotifierProvider.notifier).loadNotifications(),
        child: Builder(builder: (context) {
          if (state.isLoading && state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.notifications.isEmpty) {
            if (state.error != null) {
              return ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(child: Text('Failed: \'${state.error}\'')),
                ],
              );
            }
            return ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No notifications')),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final n = state.notifications[i];
              final subtitle = n.message.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n').replaceAll(RegExp(r'<[^>]*>'), '');
              final time = DateFormat.yMMMd().add_jm().format(n.createdAt);

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: n.isOpened ? Colors.grey.shade300 : Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.notifications, color: n.isOpened ? Colors.black54 : Colors.white, size: 18),
                ),
                title: Row(
                  children: [
                    Expanded(child: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w600))),
                    const SizedBox(width: 8),
                    Text(time, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(subtitle, maxLines: 3, overflow: TextOverflow.ellipsis),
                ),
                trailing: n.isOpened ? null : Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                onTap: () {
                  // optimistic local update
                  ref.read(notificationsNotifierProvider.notifier).markOpenedLocally(n.id);

                  // navigate if redirectLink present
                  if (n.redirectLink != null && n.redirectLink!.isNotEmpty) {
                    try {
                      final uri = Uri.parse(n.redirectLink!);
                      final path = uri.path.isEmpty ? n.redirectLink! : uri.path;
                      final args = uri.queryParameters.isEmpty ? null : uri.queryParameters;
                      Navigator.pushNamed(context, path, arguments: args);
                    } catch (_) {
                      // fallback: no navigation
                    }
                  } else {
                    // show detail dialog
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(n.title),
                        content: Text(subtitle),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                      ),
                    );
                  }
                },
              );
            },
          );
        }),
      ),
    );
  }
}
