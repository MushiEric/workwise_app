import '../../domain/entities/geofence.dart';

class GeofenceModel {
  final int id;
  final String? name;
  final String? description;
  final String? type;
  final String? coordinates;
  final double? latitude;
  final double? longitude;
  final String? centerLat;
  final String? centerLng;
  final String? radius;
  final String? color;
  final int? status;
  final bool isCurrentlyInside;
  final String? currentStatus;
  final String? checkInTime;
  final String? checkOutTime;
  final String? address;

  GeofenceModel({
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

  factory GeofenceModel.fromJson(Map<String, dynamic> json) {
    double? asDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    String? asString(dynamic v) {
      if (v == null) return null;
      if (v is String) return v.isEmpty ? null : v;
      return v.toString();
    }

    return GeofenceModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: asString(json['name']),
      description: asString(json['description']),
      type: asString(json['type']),
      coordinates: asString(json['coordinates']),
      latitude: asDouble(json['latitude']),
      longitude: asDouble(json['longitude']),
      centerLat: asString(json['center_lat']),
      centerLng: asString(json['center_lng']),
      radius: asString(json['radius']),
      color: asString(json['color']),
      status: (json['status'] as num?)?.toInt(),
      isCurrentlyInside: json['is_currently_inside'] as bool? ?? false,
      currentStatus: asString(json['current_status']),
      checkInTime: asString(json['check_in_time']),
      checkOutTime: asString(json['check_out_time']),
      address: asString(json['address']),
    );
  }

  Geofence toDomain() => Geofence(
        id: id,
        name: name,
        description: description,
        type: type,
        coordinates: coordinates,
        latitude: latitude,
        longitude: longitude,
        centerLat: centerLat,
        centerLng: centerLng,
        radius: radius,
        color: color,
        status: status,
        isCurrentlyInside: isCurrentlyInside,
        currentStatus: currentStatus,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        address: address,
      );
}
