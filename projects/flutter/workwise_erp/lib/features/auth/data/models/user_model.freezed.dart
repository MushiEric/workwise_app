// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_verified_at')
  DateTime? get emailVerifiedAt => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get lang => throw _privateConstructorUsedError;
  String? get mode => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_admin')
  Object? get isAdmin => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  Object? get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'messenger_color')
  String? get messengerColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'dark_mode')
  Object? get darkMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_email_verified')
  Object? get isEmailVerified => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login_at')
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'api_token')
  String? get apiToken => throw _privateConstructorUsedError;
  List<RoleModel>? get roles => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
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
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? emailVerifiedAt = freezed,
    Object? avatar = freezed,
    Object? lang = freezed,
    Object? mode = freezed,
    Object? isAdmin = freezed,
    Object? isActive = freezed,
    Object? messengerColor = freezed,
    Object? darkMode = freezed,
    Object? isEmailVerified = freezed,
    Object? phone = freezed,
    Object? lastLoginAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? apiToken = freezed,
    Object? roles = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            emailVerifiedAt: freezed == emailVerifiedAt
                ? _value.emailVerifiedAt
                : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            lang: freezed == lang
                ? _value.lang
                : lang // ignore: cast_nullable_to_non_nullable
                      as String?,
            mode: freezed == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAdmin: freezed == isAdmin ? _value.isAdmin : isAdmin,
            isActive: freezed == isActive ? _value.isActive : isActive,
            messengerColor: freezed == messengerColor
                ? _value.messengerColor
                : messengerColor // ignore: cast_nullable_to_non_nullable
                      as String?,
            darkMode: freezed == darkMode ? _value.darkMode : darkMode,
            isEmailVerified: freezed == isEmailVerified
                ? _value.isEmailVerified
                : isEmailVerified,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastLoginAt: freezed == lastLoginAt
                ? _value.lastLoginAt
                : lastLoginAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            apiToken: freezed == apiToken
                ? _value.apiToken
                : apiToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            roles: freezed == roles
                ? _value.roles
                : roles // ignore: cast_nullable_to_non_nullable
                      as List<RoleModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
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
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? emailVerifiedAt = freezed,
    Object? avatar = freezed,
    Object? lang = freezed,
    Object? mode = freezed,
    Object? isAdmin = freezed,
    Object? isActive = freezed,
    Object? messengerColor = freezed,
    Object? darkMode = freezed,
    Object? isEmailVerified = freezed,
    Object? phone = freezed,
    Object? lastLoginAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? apiToken = freezed,
    Object? roles = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        emailVerifiedAt: freezed == emailVerifiedAt
            ? _value.emailVerifiedAt
            : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        lang: freezed == lang
            ? _value.lang
            : lang // ignore: cast_nullable_to_non_nullable
                  as String?,
        mode: freezed == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAdmin: freezed == isAdmin ? _value.isAdmin : isAdmin,
        isActive: freezed == isActive ? _value.isActive : isActive,
        messengerColor: freezed == messengerColor
            ? _value.messengerColor
            : messengerColor // ignore: cast_nullable_to_non_nullable
                  as String?,
        darkMode: freezed == darkMode ? _value.darkMode : darkMode,
        isEmailVerified: freezed == isEmailVerified
            ? _value.isEmailVerified
            : isEmailVerified,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastLoginAt: freezed == lastLoginAt
            ? _value.lastLoginAt
            : lastLoginAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        apiToken: freezed == apiToken
            ? _value.apiToken
            : apiToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        roles: freezed == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<RoleModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    this.id,
    this.name,
    this.email,
    @JsonKey(name: 'email_verified_at') this.emailVerifiedAt,
    this.avatar,
    this.lang,
    this.mode,
    @JsonKey(name: 'is_admin') this.isAdmin,
    @JsonKey(name: 'is_active') this.isActive,
    @JsonKey(name: 'messenger_color') this.messengerColor,
    @JsonKey(name: 'dark_mode') this.darkMode,
    @JsonKey(name: 'is_email_verified') this.isEmailVerified,
    this.phone,
    @JsonKey(name: 'last_login_at') this.lastLoginAt,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(name: 'api_token') this.apiToken,
    final List<RoleModel>? roles,
  }) : _roles = roles;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? email;
  @override
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @override
  final String? avatar;
  @override
  final String? lang;
  @override
  final String? mode;
  @override
  @JsonKey(name: 'is_admin')
  final Object? isAdmin;
  @override
  @JsonKey(name: 'is_active')
  final Object? isActive;
  @override
  @JsonKey(name: 'messenger_color')
  final String? messengerColor;
  @override
  @JsonKey(name: 'dark_mode')
  final Object? darkMode;
  @override
  @JsonKey(name: 'is_email_verified')
  final Object? isEmailVerified;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'api_token')
  final String? apiToken;
  final List<RoleModel>? _roles;
  @override
  List<RoleModel>? get roles {
    final value = _roles;
    if (value == null) return null;
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, emailVerifiedAt: $emailVerifiedAt, avatar: $avatar, lang: $lang, mode: $mode, isAdmin: $isAdmin, isActive: $isActive, messengerColor: $messengerColor, darkMode: $darkMode, isEmailVerified: $isEmailVerified, phone: $phone, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt, apiToken: $apiToken, roles: $roles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailVerifiedAt, emailVerifiedAt) ||
                other.emailVerifiedAt == emailVerifiedAt) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            const DeepCollectionEquality().equals(other.isAdmin, isAdmin) &&
            const DeepCollectionEquality().equals(other.isActive, isActive) &&
            (identical(other.messengerColor, messengerColor) ||
                other.messengerColor == messengerColor) &&
            const DeepCollectionEquality().equals(other.darkMode, darkMode) &&
            const DeepCollectionEquality().equals(
              other.isEmailVerified,
              isEmailVerified,
            ) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.apiToken, apiToken) ||
                other.apiToken == apiToken) &&
            const DeepCollectionEquality().equals(other._roles, _roles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    emailVerifiedAt,
    avatar,
    lang,
    mode,
    const DeepCollectionEquality().hash(isAdmin),
    const DeepCollectionEquality().hash(isActive),
    messengerColor,
    const DeepCollectionEquality().hash(darkMode),
    const DeepCollectionEquality().hash(isEmailVerified),
    phone,
    lastLoginAt,
    createdAt,
    updatedAt,
    apiToken,
    const DeepCollectionEquality().hash(_roles),
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    final int? id,
    final String? name,
    final String? email,
    @JsonKey(name: 'email_verified_at') final DateTime? emailVerifiedAt,
    final String? avatar,
    final String? lang,
    final String? mode,
    @JsonKey(name: 'is_admin') final Object? isAdmin,
    @JsonKey(name: 'is_active') final Object? isActive,
    @JsonKey(name: 'messenger_color') final String? messengerColor,
    @JsonKey(name: 'dark_mode') final Object? darkMode,
    @JsonKey(name: 'is_email_verified') final Object? isEmailVerified,
    final String? phone,
    @JsonKey(name: 'last_login_at') final DateTime? lastLoginAt,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'api_token') final String? apiToken,
    final List<RoleModel>? roles,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get email;
  @override
  @JsonKey(name: 'email_verified_at')
  DateTime? get emailVerifiedAt;
  @override
  String? get avatar;
  @override
  String? get lang;
  @override
  String? get mode;
  @override
  @JsonKey(name: 'is_admin')
  Object? get isAdmin;
  @override
  @JsonKey(name: 'is_active')
  Object? get isActive;
  @override
  @JsonKey(name: 'messenger_color')
  String? get messengerColor;
  @override
  @JsonKey(name: 'dark_mode')
  Object? get darkMode;
  @override
  @JsonKey(name: 'is_email_verified')
  Object? get isEmailVerified;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'last_login_at')
  DateTime? get lastLoginAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'api_token')
  String? get apiToken;
  @override
  List<RoleModel>? get roles;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
