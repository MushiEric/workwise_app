import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/trip_remote_data_source.dart';
import '../../data/repositories/trip_repository_impl.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../domain/usecases/get_trips.dart';
import '../notifier/trips_notifier.dart';
import '../state/trips_state.dart';

final tripRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return TripRemoteDataSource(dio);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final remote = ref.watch(tripRemoteDataSourceProvider);
  return TripRepositoryImpl(remote);
});

final getTripsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(tripRepositoryProvider);
  return GetTrips(repo);
});

final tripsNotifierProvider = StateNotifierProvider<TripsNotifier, TripsState>((ref) {
  final getTrips = ref.watch(getTripsUseCaseProvider);
  return TripsNotifier(getTrips: getTrips);
});
