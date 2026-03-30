import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/truck.dart';

part 'truck_model.freezed.dart';
part 'truck_model.g.dart';

@freezed
class TruckModel with _$TruckModel {
  const factory TruckModel({
    int? id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'vehicle_id') int? vehicleId,
    @JsonKey(name: 'vehicle_name') String? vehicleName,
    @JsonKey(name: 'vehicle_plate_number') String? vehiclePlateNumber,
    @JsonKey(name: 'vehicle_trailer_number') String? vehicleTrailerNumber,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'driver_phone') String? driverPhone,
    @JsonKey(name: 'driver_license_number') String? driverLicenseNumber,
    @JsonKey(name: 'checkin_status') String? checkinStatus,
    @JsonKey(name: 'checkout_status') String? checkoutStatus,
    @JsonKey(name: 'checkin_datetime') String? checkinDatetime,
    @JsonKey(name: 'checkout_datetime') String? checkoutDatetime,
    @JsonKey(name: 'checkin_weight') String? checkinWeight,
    @JsonKey(name: 'checkin_weight_unit') String? checkinWeightUnit,
    @JsonKey(name: 'checkout_weight') String? checkoutWeight,
    @JsonKey(name: 'checkout_weight_unit') String? checkoutWeightUnit,
    @JsonKey(name: 'net_weight') String? netWeight,
    @JsonKey(name: 'net_weight_unit') String? netWeightUnit,
  }) = _TruckModel;

  factory TruckModel.fromJson(Map<String, dynamic> json) =>
      _$TruckModelFromJson(json);
}

extension TruckModelX on TruckModel {
  Truck toDomain() => Truck(
    id: id,
    orderId: int.tryParse(orderId ?? ''),
    vehicleId: vehicleId,
    vehicleName: vehicleName,
    vehiclePlateNumber: vehiclePlateNumber,
    vehicleTrailerNumber: vehicleTrailerNumber,
    driverName: driverName,
    driverPhone: driverPhone,
    driverLicenseNumber: driverLicenseNumber,
    checkinStatus: checkinStatus,
    checkoutStatus: checkoutStatus,
    checkinDatetime: checkinDatetime,
    checkoutDatetime: checkoutDatetime,
    checkinWeight: checkinWeight,
    checkinWeightUnit: checkinWeightUnit,
    checkoutWeight: checkoutWeight,
    checkoutWeightUnit: checkoutWeightUnit,
    netWeight: netWeight,
    netWeightUnit: netWeightUnit,
  );
}
