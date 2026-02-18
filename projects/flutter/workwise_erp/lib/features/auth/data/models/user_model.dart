import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';
import 'role_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    int? id,
    String? name,
    String? email,
    @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
    String? avatar,
    String? lang,
    String? mode,
    @JsonKey(name: 'is_admin') Object? isAdmin,
    @JsonKey(name: 'is_active') Object? isActive,
    @JsonKey(name: 'messenger_color') String? messengerColor,
    @JsonKey(name: 'dark_mode') Object? darkMode,
    @JsonKey(name: 'is_email_verified') Object? isEmailVerified,
    String? phone,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'api_token') String? apiToken,
    List<RoleModel>? roles,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  bool? _objToBool(Object? v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v == 1;
    if (v is String) {
      final lv = v.toLowerCase();
      if (lv == '1' || lv == 'true') return true;
      if (lv == '0' || lv == 'false') return false;
    }
    return null;
  }

  User toDomain() {
    return User(
      id: id,
      name: name,
      email: email,
      emailVerifiedAt: emailVerifiedAt,
      avatar: avatar,
      lang: lang,
      mode: mode,
      isAdmin: _objToBool(isAdmin),
      isActive: _objToBool(isActive),
      messengerColor: messengerColor,
      darkMode: _objToBool(darkMode),
      isEmailVerified: _objToBool(isEmailVerified),
      phone: phone,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      apiToken: apiToken,
      roles: roles?.map((r) => r.toDomain()).toList(),
    );
  }
}
