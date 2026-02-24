import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_geofences.dart';
import '../../domain/usecases/get_asset_geofences.dart';
import '../state/geofence_state.dart';

class GeofenceNotifier extends StateNotifier<GeofenceState> {
  final GetGeofences _getGeofences;
  final GetAssetGeofences _getAssetGeofences;

  GeofenceNotifier({
    required GetGeofences getGeofences,
    required GetAssetGeofences getAssetGeofences,
  })  : _getGeofences = getGeofences,
        _getAssetGeofences = getAssetGeofences,
        super(const GeofenceState.initial());

  /// Load all geofences (no vehicle filter).
  Future<void> loadGeofences() async {
    state = const GeofenceState.loading();
    final res = await _getGeofences.call();
    res.fold(
      (f) => state = GeofenceState.error(f.message),
      (list) => state = GeofenceState.loaded(list),
    );
  }

  /// Load geofences for a specific vehicle and show inside/outside status.
  Future<void> loadAssetGeofences(String registrationNumber) async {
    state = const GeofenceState.loading();
    final res = await _getAssetGeofences.call(registrationNumber);
    res.fold(
      (f) => state = GeofenceState.error(f.message),
      (list) => state = GeofenceState.loaded(list),
    );
  }
}
