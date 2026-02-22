import 'package:equatable/equatable.dart';

class Trip extends Equatable {
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

  const Trip({
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

  @override
  List<Object?> get props => [
        id,
        tripNumber,
        customerName,
        vehicleNumber,
        operatorName,
        routeName,
        statusName,
        statusColor,
        etd,
        etas,
        cargoCapacity,
        cargoUnit,
        tripCurrency,
        openingBalance,
        createdAt,
        updatedAt,
      ];
}
