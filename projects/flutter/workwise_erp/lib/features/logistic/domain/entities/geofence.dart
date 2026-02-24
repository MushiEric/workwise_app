import 'package:equatable/equatable.dart';

/// A geofence zone returned by the backend.
///
/// [type] is one of: `polygon`, `rectangle`, `circle`.
/// [coordinates] is a raw JSON string that must be parsed to obtain the
/// actual lat/lng points (see [GeofenceModel.parsedPoints]).
class Geofence extends Equatable {
  final int id;
  final String? name;
  final String? description;
  final String? type;
  final String? coordinates; // raw JSON string
  final double? latitude;
  final double? longitude;
  final String? centerLat;
  final String? centerLng;
  final String? radius;
  final String? color;
  final int? status;

  // Asset-specific fields (only present when fetched via /geofence/asset/...)
  final bool isCurrentlyInside;
  final String? currentStatus; // "inside" | "outside"
  final String? checkInTime;
  final String? checkOutTime;
  final String? address;

  const Geofence({
    required this.id,
    this.name,
    this.description,
    this.type,
    this.coordinates,
    this.latitude,
    this.longitude,
    this.centerLat,
    this.centerLng,
    this.radius,
    this.color,
    this.status,
    this.isCurrentlyInside = false,
    this.currentStatus,
    this.checkInTime,
    this.checkOutTime,
    this.address,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        coordinates,
        isCurrentlyInside,
        currentStatus,
      ];
}
