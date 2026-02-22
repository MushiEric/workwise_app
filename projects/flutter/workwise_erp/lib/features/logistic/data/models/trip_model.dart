import '../../domain/entities/trip.dart' as domain;

class TripModel {
  final int? id;
  final String? tripNumber;
  final String? customerName;
  final String? vehicleNumber;
  final String? operatorName;
  final String? routeName;
  final String? statusName;
  final String? statusColor;
  final String? etd;
  final String? etas;
  final String? cargoCapacity;
  final String? cargoUnit;
  final String? tripCurrency;
  final String? openingBalance;
  final String? createdAt;
  final String? updatedAt;

  TripModel({
    this.id,
    this.tripNumber,
    this.customerName,
    this.vehicleNumber,
    this.operatorName,
    this.routeName,
    this.statusName,
    this.statusColor,
    this.etd,
    this.etas,
    this.cargoCapacity,
    this.cargoUnit,
    this.tripCurrency,
    this.openingBalance,
    this.createdAt,
    this.updatedAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    String? asString(dynamic v) {
      if (v == null) return null;
      if (v is String) return v.isEmpty ? null : v;
      if (v is num || v is bool) return v.toString();
      return v.toString();
    }

    return TripModel(
      id: asInt(json['id']),
      tripNumber: asString(json['trip_number']),
      customerName: asString(json['customer_name']),
      vehicleNumber: asString(json['vehicle_number']),
      operatorName: asString(json['operator_name']),
      routeName: asString(json['route_name']),
      statusName: asString(json['status_name']),
      statusColor: asString(json['status_color']),
      etd: asString(json['ETD']),
      etas: asString(json['ETAS']),
      cargoCapacity: asString(json['cargo_capacity']),
      cargoUnit: asString(json['cargo_unit']),
      tripCurrency: asString(json['trip_currency']),
      openingBalance: asString(json['opening_balance']),
      createdAt: asString(json['created_at']),
      updatedAt: asString(json['updated_at']),
    );
  }

  domain.Trip toDomain() => domain.Trip(
        id: id,
        tripNumber: tripNumber,
        customerName: customerName,
        vehicleNumber: vehicleNumber,
        operatorName: operatorName,
        routeName: routeName,
        statusName: statusName,
        statusColor: statusColor,
        etd: etd,
        etas: etas,
        cargoCapacity: cargoCapacity,
        cargoUnit: cargoUnit,
        tripCurrency: tripCurrency,
        openingBalance: openingBalance,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
