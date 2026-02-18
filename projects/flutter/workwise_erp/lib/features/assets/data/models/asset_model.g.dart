// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssetModelImpl _$$AssetModelImplFromJson(Map<String, dynamic> json) =>
    _$AssetModelImpl(
      id: (json['id'] as num?)?.toInt(),
      assetId: json['asset_id'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      registrationNumber: json['registration_number'] as String?,
      model: json['model'] as String?,
      image: json['image'] as String?,
      year: json['year'] as String?,
      status: json['status'] as String?,
      isAvailable: (json['is_available'] as num?)?.toInt(),
      isActive: (json['is_active'] as num?)?.toInt(),
      hasGps: json['has_gps'] as bool?,
      vin: json['vin'] as String?,
      make: json['make'] as String?,
      company: json['company'] as String?,
      fuelConsumption: json['fuel_consuption'] as num?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$AssetModelImplToJson(_$AssetModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'asset_id': instance.assetId,
      'type': instance.type,
      'name': instance.name,
      'registration_number': instance.registrationNumber,
      'model': instance.model,
      'image': instance.image,
      'year': instance.year,
      'status': instance.status,
      'is_available': instance.isAvailable,
      'is_active': instance.isActive,
      'has_gps': instance.hasGps,
      'vin': instance.vin,
      'make': instance.make,
      'company': instance.company,
      'fuel_consuption': instance.fuelConsumption,
      'created_at': instance.createdAt,
    };
