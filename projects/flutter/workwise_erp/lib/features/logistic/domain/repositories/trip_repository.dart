import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/trip.dart';

abstract class TripRepository {
  Future<Either<Failure, List<Trip>>> getTrips();
}
