// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      avatar: json['avatar'] as String?,
      lang: json['lang'] as String?,
      mode: json['mode'] as String?,
      isAdmin: json['is_admin'],
      isActive: json['is_active'],
      messengerColor: json['messenger_color'] as String?,
      darkMode: json['dark_mode'],
      isEmailVerified: json['is_email_verified'],
      phone: json['phone'] as String?,
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      apiToken: json['api_token'] as String?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'avatar': instance.avatar,
      'lang': instance.lang,
      'mode': instance.mode,
      'is_admin': instance.isAdmin,
      'is_active': instance.isActive,
      'messenger_color': instance.messengerColor,
      'dark_mode': instance.darkMode,
      'is_email_verified': instance.isEmailVerified,
      'phone': instance.phone,
      'last_login_at': instance.lastLoginAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'api_token': instance.apiToken,
      'roles': instance.roles,
    };
