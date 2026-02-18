import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/notification_repository.dart';
import '../entities/notification.dart';

class GetNotifications {
  final NotificationRepository repository;
  GetNotifications(this.repository);

  Future<Either<Failure, List<AppNotification>>> call({int isOpened = 0}) async {
    return repository.getNotifications(isOpened: isOpened);
  }
}
