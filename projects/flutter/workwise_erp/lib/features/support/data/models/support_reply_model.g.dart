// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupportReplyModelImpl _$$SupportReplyModelImplFromJson(
  Map<String, dynamic> json,
) => _$SupportReplyModelImpl(
  id: (json['id'] as num?)?.toInt(),
  message: json['message'] as String?,
  createdBy: (json['created_by'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$SupportReplyModelImplToJson(
  _$SupportReplyModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'message': instance.message,
  'created_by': instance.createdBy,
  'created_at': instance.createdAt?.toIso8601String(),
};
