// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatusModelImpl _$$StatusModelImplFromJson(Map<String, dynamic> json) =>
    _$StatusModelImpl(
      id: (json['id'] as num?)?.toInt(),
      status: json['status'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$StatusModelImplToJson(_$StatusModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'color': instance.color,
    };
