import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/geofence.dart';

abstract class GeofenceRepository {
  /// Returns all geofences (no vehicle filter).
  Future<Either<Failure, List<Geofence>>> getGeofences();

  /// Returns geofences for a specific asset (vehicle) identified by its
  /// [registrationNumber], including [Geofence.isCurrentlyInside] status.
  Future<Either<Failure, List<Geofence>>> getAssetGeofences(
    String registrationNumber,
  );
}
