// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageUnitModelImpl _$$PackageUnitModelImplFromJson(
  Map<String, dynamic> json,
) => _$PackageUnitModelImpl(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  shortName: json['short_name'] as String?,
);

Map<String, dynamic> _$$PackageUnitModelImplToJson(
  _$PackageUnitModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'short_name': instance.shortName,
};
