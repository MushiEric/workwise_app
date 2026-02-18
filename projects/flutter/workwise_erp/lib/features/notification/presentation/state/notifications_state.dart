import '../../domain/entities/notification.dart';

/// Simple state class (no freezed) used by NotificationsNotifier.
class NotificationsState {
  final bool isLoading;
  final String? error;
  final List<AppNotification> notifications;

  NotificationsState({required this.isLoading, required this.notifications, this.error});

  factory NotificationsState.initial() => NotificationsState(isLoading: false, notifications: []);
  factory NotificationsState.loading(List<AppNotification> prev) => NotificationsState(isLoading: true, notifications: prev);
  factory NotificationsState.loaded(List<AppNotification> list) => NotificationsState(isLoading: false, notifications: list);
  factory NotificationsState.errorState(String message, List<AppNotification> prev) => NotificationsState(isLoading: false, notifications: prev, error: message);
}
