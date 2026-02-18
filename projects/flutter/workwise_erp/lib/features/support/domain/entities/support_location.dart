import 'package:equatable/equatable.dart';

class SupportLocation extends Equatable {
  final int? id;
  final String? name;
  final String? number;
  final String? latitude;
  final String? longitude;
  final String? countryId;
  final String? regionId;
  final String? districtId;
  final String? customerId;
  final String? clientId;
  final String? zone;
  final String? phone;
  final String? fax;
  final String? address;
  final int? createdBy;
  final int? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final int? archive;
  final String? locationNumber;

  const SupportLocation({
    this.id,
    this.name,
    this.number,
    this.latitude,
    this.longitude,
    this.countryId,
    this.regionId,
    this.districtId,
    this.customerId,
    this.clientId,
    this.zone,
    this.phone,
    this.fax,
    this.address,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.archive,
    this.locationNumber,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        number,
        latitude,
        longitude,
        countryId,
        regionId,
        districtId,
        customerId,
        clientId,
        zone,
        phone,
        fax,
        address,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        archive,
        locationNumber,
      ];
}
