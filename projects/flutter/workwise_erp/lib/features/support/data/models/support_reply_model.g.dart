// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupportReplyModelImpl _$$SupportReplyModelImplFromJson(
  Map<String, dynamic> json,
) => _$SupportReplyModelImpl(
  id: (json['id'] as num?)?.toInt(),
  message: json['description'] as String?,
  user: (json['user'] as num?)?.toInt(),
  createdBy: (json['created_by'] as num?)?.toInt(),
  isRead: (json['is_read'] as num?)?.toInt(),
  name: json['name'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$SupportReplyModelImplToJson(
  _$SupportReplyModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.message,
  'user': instance.user,
  'created_by': instance.createdBy,
  'is_read': instance.isRead,
  'name': instance.name,
  'created_at': instance.createdAt?.toIso8601String(),
};
