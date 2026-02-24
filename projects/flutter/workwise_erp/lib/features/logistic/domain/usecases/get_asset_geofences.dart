import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/geofence.dart';
import '../repositories/geofence_repository.dart';

class GetAssetGeofences {
  final GeofenceRepository repository;
  GetAssetGeofences(this.repository);

  Future<Either<Failure, List<Geofence>>> call(String registrationNumber) =>
      repository.getAssetGeofences(registrationNumber);
}
