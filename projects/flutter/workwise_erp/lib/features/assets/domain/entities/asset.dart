// import 'package:equatable/equatable.dart';

// import 'asset_links.dart';

// class Asset extends Equatable {
//   final int? id;
//   final String? assetId;
//   final String? type;
//   final String? name;
//   final String? registrationNumber;
//   final String? model;
//   final String? image;
//   final String? year;
//   final String? status;
//   final bool? isAvailable;
//   final bool? isActive;
//   final bool? hasGps;
//   final String? vin;
//   final String? make;
//   final String? company;
//   final num? fuelConsumption;
//   final String? createdAt;

//   // ── GPS / live-tracking fields ──────────────────────────────────────
//   /// Decimal degrees latitude (positive = N, negative = S).
//   final double? latitude;

//   /// Decimal degrees longitude (positive = E, negative = W).
//   final double? longitude;

//   /// Current speed in km/h. 0 = stopped, null = unknown.
//   final double? speed;

//   /// Whether the vehicle ignition is on.
//   final bool? ignition;

//   /// GPS heading in degrees (0 = North, 90 = East, …).
//   final double? heading;

//   /// Human-readable address from reverse-geocoding.
//   final String? address;

//   /// ISO-8601 timestamp of the last GPS transmission.
//   final String? lastTransmit;

//   /// Device battery voltage.
//   final double? battery;

//   /// Whether the GPS fix is valid (enough satellites).
//   final bool? gpsValid;

//   /// Number of satellites used for the current fix.
//   final int? satellites;

//   /// GPS provider label (e.g. "AfriTrack").
//   final String? gpsLabel;

//   /// Unit / device number assigned by the GPS provider.
//   final String? unitNumber;

//   /// GPS hardware/integration type.
//   final String? gpsType;

//   /// Recent breadcrumb trail as `[[lat, lng], ...]`, newest entry last.
//   /// Used to draw a polyline on the map.
//   final List<List<double>>? routeHistory;

//   // ── Linked units ────────────────────────────────────────────────────
//   /// Driver currently assigned to this vehicle.
//   final LinkedDriver? linkedDriver;

//   /// Trailer currently coupled to this vehicle.
//   final LinkedTrailer? linkedTrailer;

//   /// Most recent trips associated with this vehicle (newest first).
//   final List<LinkedTrip>? recentTrips;

//   const Asset({
//     this.id,
//     this.assetId,
//     this.type,
//     this.name,
//     this.registrationNumber,
//     this.model,
//     this.image,
//     this.year,
//     this.status,
//     this.isAvailable,
//     this.isActive,
//     this.hasGps,
//     this.vin,
//     this.make,
//     this.company,
//     this.fuelConsumption,
//     this.createdAt,
//     // GPS
//     this.latitude,
//     this.longitude,
//     this.speed,
//     this.ignition,
//     this.heading,
//     this.address,
//     this.lastTransmit,
//     this.battery,
//     this.gpsValid,
//     this.satellites,
//     this.gpsLabel,
//     this.unitNumber,
//     this.gpsType,
//     this.routeHistory,
//     // Linked units
//     this.linkedDriver,
//     this.linkedTrailer,
//     this.recentTrips,
//   });

//   @override
//   List<Object?> get props => [
//         id, assetId, type, name, registrationNumber, model, image, year,
//         status, isAvailable, isActive, hasGps, vin, make, company,
//         fuelConsumption, createdAt,
//         latitude, longitude, speed, ignition, heading, address,
//         lastTransmit, battery, gpsValid, satellites, gpsLabel,
//         unitNumber, gpsType, routeHistory,
//         linkedDriver, linkedTrailer, recentTrips,
//       ];
// }
