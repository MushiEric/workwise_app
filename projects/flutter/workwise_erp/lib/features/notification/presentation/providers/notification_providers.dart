import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';

import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../notifier/notifications_notifier.dart';
import '../state/notifications_state.dart';

final notificationRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRemoteDataSource(dio);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remote = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remote);
});

final getNotificationsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return GetNotifications(repo);
});

final notificationsNotifierProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
      final usecase = ref.watch(getNotificationsUseCaseProvider);
      return NotificationsNotifier(getNotifications: usecase);
    });

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final state = ref.watch(notificationsNotifierProvider);
  return state.notifications.where((n) => !n.isOpened).length;
});

// Simple filter state used by the notifications page dialog
final notificationFilterProvider = StateProvider<String>((ref) => 'all');
