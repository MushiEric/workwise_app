import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/geofence.dart';

part 'geofence_state.freezed.dart';

@freezed
class GeofenceState with _$GeofenceState {
  const factory GeofenceState.initial() = _Initial;
  const factory GeofenceState.loading() = _Loading;
  const factory GeofenceState.loaded(List<Geofence> geofences) = _Loaded;
  const factory GeofenceState.error(String message) = _Error;
}
