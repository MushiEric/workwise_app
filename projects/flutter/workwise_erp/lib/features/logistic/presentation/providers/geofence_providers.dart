import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/provider/dio_provider.dart';

import '../../data/datasources/geofence_remote_data_source.dart';
import '../../data/repositories/geofence_repository_impl.dart';
import '../../domain/repositories/geofence_repository.dart';
import '../../domain/usecases/get_geofences.dart';
import '../../domain/usecases/get_asset_geofences.dart';
import '../notifier/geofence_notifier.dart';
import '../state/geofence_state.dart';

final geofenceRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return GeofenceRemoteDataSource(dio);
});

final geofenceRepositoryProvider = Provider<GeofenceRepository>((ref) {
  final remote = ref.watch(geofenceRemoteDataSourceProvider);
  return GeofenceRepositoryImpl(remote);
});

final getGeofencesUseCaseProvider = Provider((ref) {
  final repo = ref.watch(geofenceRepositoryProvider);
  return GetGeofences(repo);
});

final getAssetGeofencesUseCaseProvider = Provider((ref) {
  final repo = ref.watch(geofenceRepositoryProvider);
  return GetAssetGeofences(repo);
});

final geofenceNotifierProvider =
    StateNotifierProvider<GeofenceNotifier, GeofenceState>((ref) {
  return GeofenceNotifier(
    getGeofences: ref.watch(getGeofencesUseCaseProvider),
    getAssetGeofences: ref.watch(getAssetGeofencesUseCaseProvider),
  );
});
