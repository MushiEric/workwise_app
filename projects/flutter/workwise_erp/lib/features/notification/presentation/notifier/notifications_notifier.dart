import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_notifications.dart';
import '../../domain/entities/notification.dart';
import '../state/notifications_state.dart';

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final GetNotifications getNotifications;
  NotificationsNotifier({required this.getNotifications})
    : super(NotificationsState.initial());

  Future<void> loadNotifications({int isOpened = 0}) async {
    state = NotificationsState.loading(state.notifications);
    final res = await getNotifications.call(isOpened: isOpened);
    res.fold(
      (f) =>
          state = NotificationsState.errorState(f.message, state.notifications),
      (list) => state = NotificationsState.loaded(list),
    );
  }

  /// Optimistic local mark-as-opened (no server endpoint known).
  void markOpenedLocally(int id) {
    final list = state.notifications
        .map(
          (n) => n.id == id
              ? AppNotification(
                  id: n.id,
                  title: n.title,
                  message: n.message,
                  createdAt: n.createdAt,
                  isOpened: true,
                  isClicked: n.isClicked,
                  redirectLink: n.redirectLink,
                )
              : n,
        )
        .toList();
    state = NotificationsState.loaded(list);
  }

  /// Mark every notification as opened locally.
  void markAllAsRead() {
    final list = state.notifications
        .map(
          (n) => AppNotification(
            id: n.id,
            title: n.title,
            message: n.message,
            createdAt: n.createdAt,
            isOpened: true,
            isClicked: n.isClicked,
            redirectLink: n.redirectLink,
          ),
        )
        .toList();
    state = NotificationsState.loaded(list);
  }

  /// Remove a notification locally (dismiss swipe).
  void dismiss(int id) {
    final list = state.notifications.where((n) => n.id != id).toList();
    state = NotificationsState.loaded(list);
  }

  /// Throw away all read notifications (archive).
  void archiveAllRead() {
    final list = state.notifications.where((n) => !n.isOpened).toList();
    state = NotificationsState.loaded(list);
  }

  /// Stub: mute notifications for a duration – no-op in local state.
  void muteForDuration(Duration duration) {
    // no-op: server support not implemented yet
  }

  /// Convenience: unread count
  int unreadCount() => state.notifications.where((n) => !n.isOpened).length;
}
