import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/trip.dart';

part 'trips_state.freezed.dart';

@freezed
class TripsState with _$TripsState {
  const factory TripsState.initial() = _Initial;
  const factory TripsState.loading() = _Loading;
  const factory TripsState.loaded(List<Trip> trips) = _Loaded;
  const factory TripsState.error(String message) = _Error;
}
