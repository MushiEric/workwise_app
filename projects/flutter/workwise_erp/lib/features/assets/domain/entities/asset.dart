import 'package:equatable/equatable.dart';

class Asset extends Equatable {
  final int? id;
  final String? assetId;
  final String? type;
  final String? name;
  final String? registrationNumber;
  final String? model;
  final String? image;
  final String? year;
  final String? status;
  final bool? isAvailable;
  final bool? isActive;
  final bool? hasGps;
  final String? vin;
  final String? make;
  final String? company;
  final num? fuelConsumption;
  final String? createdAt;

  const Asset({
    this.id,
    this.assetId,
    this.type,
    this.name,
    this.registrationNumber,
    this.model,
    this.image,
    this.year,
    this.status,
    this.isAvailable,
    this.isActive,
    this.hasGps,
    this.vin,
    this.make,
    this.company,
    this.fuelConsumption,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        assetId,
        type,
        name,
        registrationNumber,
        model,
        image,
        year,
        status,
        isAvailable,
        isActive,
        hasGps,
        vin,
        make,
        company,
        fuelConsumption,
        createdAt,
      ];
}
