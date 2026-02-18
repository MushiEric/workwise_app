import 'package:equatable/equatable.dart';

class Truck extends Equatable {
  final int? id;
  final int? orderId;
  final String? vehicleName;
  final String? vehiclePlateNumber;
  final String? vehicleTrailerNumber;
  final String? driverName;
  final String? driverPhone;
  final String? driverLicenseNumber;
  final String? checkinStatus;
  final String? checkoutStatus;
  final String? checkinDatetime;
  final String? checkoutDatetime;
  final String? checkinWeight;
  final String? checkinWeightUnit;
  final String? checkoutWeight;
  final String? checkoutWeightUnit;
  final String? netWeight;
  final String? netWeightUnit;

  const Truck({
    this.id,
    this.orderId,
    this.vehicleName,
    this.vehiclePlateNumber,
    this.vehicleTrailerNumber,
    this.driverName,
    this.driverPhone,
    this.driverLicenseNumber,
    this.checkinStatus,
    this.checkoutStatus,
    this.checkinDatetime,
    this.checkoutDatetime,
    this.checkinWeight,
    this.checkinWeightUnit,
    this.checkoutWeight,
    this.checkoutWeightUnit,
    this.netWeight,
    this.netWeightUnit,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    vehicleName,
    vehiclePlateNumber,
    vehicleTrailerNumber,
    driverName,
    driverPhone,
    driverLicenseNumber,
    checkinStatus,
    checkoutStatus,
    checkinDatetime,
    checkoutDatetime,
    checkinWeight,
    checkinWeightUnit,
    checkoutWeight,
    checkoutWeightUnit,
    netWeight,
    netWeightUnit,
  ];
}
