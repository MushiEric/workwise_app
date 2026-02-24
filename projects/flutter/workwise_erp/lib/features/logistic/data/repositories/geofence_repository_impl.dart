import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../../domain/entities/geofence.dart';
import '../../domain/repositories/geofence_repository.dart';
import '../datasources/geofence_remote_data_source.dart';

class GeofenceRepositoryImpl implements GeofenceRepository {
  final GeofenceRemoteDataSource remote;
  GeofenceRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Geofence>>> getGeofences() async {
    try {
      final models = await remote.getGeofences();
      return Either.right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Geofence>>> getAssetGeofences(
      String registrationNumber) async {
    try {
      final models = await remote.getAssetGeofences(registrationNumber);
      return Either.right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
