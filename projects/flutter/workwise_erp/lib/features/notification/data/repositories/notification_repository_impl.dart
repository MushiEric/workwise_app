import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../../domain/entities/notification.dart' as domain;
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;
  NotificationRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<domain.AppNotification>>> getNotifications({int isOpened = 0}) async {
    try {
      final models = await remote.getNotifications(isOpened: isOpened);
      return Either.right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
