// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priority_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriorityModelImpl _$$PriorityModelImplFromJson(Map<String, dynamic> json) =>
    _$PriorityModelImpl(
      id: (json['id'] as num?)?.toInt(),
      priority: json['priority'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$PriorityModelImplToJson(_$PriorityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'priority': instance.priority,
      'color': instance.color,
    };
