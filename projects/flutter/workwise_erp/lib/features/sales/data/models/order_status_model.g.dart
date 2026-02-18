// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderStatusModelImpl _$$OrderStatusModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrderStatusModelImpl(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  color: json['color'] as String?,
);

Map<String, dynamic> _$$OrderStatusModelImplToJson(
  _$OrderStatusModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
};
