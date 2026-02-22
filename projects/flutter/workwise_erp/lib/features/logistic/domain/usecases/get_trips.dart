import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

class GetTrips {
  final TripRepository repository;
  GetTrips(this.repository);

  Future<Either<Failure, List<Trip>>> call() async {
    return repository.getTrips();
  }
}
