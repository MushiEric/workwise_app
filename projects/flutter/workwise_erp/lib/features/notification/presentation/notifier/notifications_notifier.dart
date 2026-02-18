import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_notifications.dart';
import '../../domain/entities/notification.dart';
import '../state/notifications_state.dart';

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final GetNotifications getNotifications;
  NotificationsNotifier({required this.getNotifications}) : super(NotificationsState.initial());

  Future<void> loadNotifications({int isOpened = 0}) async {
    state = NotificationsState.loading(state.notifications);
    final res = await getNotifications.call(isOpened: isOpened);
    res.fold((f) => state = NotificationsState.errorState(f.message, state.notifications), (list) => state = NotificationsState.loaded(list));
  }

  /// Optimistic local mark-as-opened (no server endpoint known).
  void markOpenedLocally(int id) {
    final list = state.notifications.map((n) => n.id == id ? AppNotification(
          id: n.id,
          title: n.title,
          message: n.message,
          createdAt: n.createdAt,
          isOpened: true,
          isClicked: n.isClicked,
          redirectLink: n.redirectLink,
        ) : n).toList();
    state = NotificationsState.loaded(list);
  }

  /// Convenience: unread count
  int unreadCount() => state.notifications.where((n) => !n.isOpened).length;
}
