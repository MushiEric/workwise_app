// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TruckModelImpl _$$TruckModelImplFromJson(Map<String, dynamic> json) =>
    _$TruckModelImpl(
      id: (json['id'] as num?)?.toInt(),
      orderId: json['order_id'] as String?,
      vehicleId: (json['vehicle_id'] as num?)?.toInt(),
      vehicleName: json['vehicle_name'] as String?,
      vehiclePlateNumber: json['vehicle_plate_number'] as String?,
      vehicleTrailerNumber: json['vehicle_trailer_number'] as String?,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      driverLicenseNumber: json['driver_license_number'] as String?,
      checkinStatus: json['checkin_status'] as String?,
      checkoutStatus: json['checkout_status'] as String?,
      checkinDatetime: json['checkin_datetime'] as String?,
      checkoutDatetime: json['checkout_datetime'] as String?,
      checkinWeight: json['checkin_weight'] as String?,
      checkinWeightUnit: json['checkin_weight_unit'] as String?,
      checkoutWeight: json['checkout_weight'] as String?,
      checkoutWeightUnit: json['checkout_weight_unit'] as String?,
      netWeight: json['net_weight'] as String?,
      netWeightUnit: json['net_weight_unit'] as String?,
    );

Map<String, dynamic> _$$TruckModelImplToJson(_$TruckModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'vehicle_id': instance.vehicleId,
      'vehicle_name': instance.vehicleName,
      'vehicle_plate_number': instance.vehiclePlateNumber,
      'vehicle_trailer_number': instance.vehicleTrailerNumber,
      'driver_name': instance.driverName,
      'driver_phone': instance.driverPhone,
      'driver_license_number': instance.driverLicenseNumber,
      'checkin_status': instance.checkinStatus,
      'checkout_status': instance.checkoutStatus,
      'checkin_datetime': instance.checkinDatetime,
      'checkout_datetime': instance.checkoutDatetime,
      'checkin_weight': instance.checkinWeight,
      'checkin_weight_unit': instance.checkinWeightUnit,
      'checkout_weight': instance.checkoutWeight,
      'checkout_weight_unit': instance.checkoutWeightUnit,
      'net_weight': instance.netWeight,
      'net_weight_unit': instance.netWeightUnit,
    };
