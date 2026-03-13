// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_reply_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SupportReplyModel _$SupportReplyModelFromJson(Map<String, dynamic> json) {
  return _SupportReplyModel.fromJson(json);
}

/// @nodoc
mixin _$SupportReplyModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get message => throw _privateConstructorUsedError;
  int? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  int? get isRead => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SupportReplyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SupportReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupportReplyModelCopyWith<SupportReplyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupportReplyModelCopyWith<$Res> {
  factory $SupportReplyModelCopyWith(
    SupportReplyModel value,
    $Res Function(SupportReplyModel) then,
  ) = _$SupportReplyModelCopyWithImpl<$Res, SupportReplyModel>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'description') String? message,
    int? user,
    @JsonKey(name: 'created_by') int? createdBy,
    @JsonKey(name: 'is_read') int? isRead,
    String? name,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$SupportReplyModelCopyWithImpl<$Res, $Val extends SupportReplyModel>
    implements $SupportReplyModelCopyWith<$Res> {
  _$SupportReplyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupportReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? user = freezed,
    Object? createdBy = freezed,
    Object? isRead = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as int?,
            isRead: freezed == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as int?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SupportReplyModelImplCopyWith<$Res>
    implements $SupportReplyModelCopyWith<$Res> {
  factory _$$SupportReplyModelImplCopyWith(
    _$SupportReplyModelImpl value,
    $Res Function(_$SupportReplyModelImpl) then,
  ) = __$$SupportReplyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'description') String? message,
    int? user,
    @JsonKey(name: 'created_by') int? createdBy,
    @JsonKey(name: 'is_read') int? isRead,
    String? name,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$SupportReplyModelImplCopyWithImpl<$Res>
    extends _$SupportReplyModelCopyWithImpl<$Res, _$SupportReplyModelImpl>
    implements _$$SupportReplyModelImplCopyWith<$Res> {
  __$$SupportReplyModelImplCopyWithImpl(
    _$SupportReplyModelImpl _value,
    $Res Function(_$SupportReplyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupportReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? user = freezed,
    Object? createdBy = freezed,
    Object? isRead = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SupportReplyModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as int?,
        isRead: freezed == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SupportReplyModelImpl implements _SupportReplyModel {
  const _$SupportReplyModelImpl({
    this.id,
    @JsonKey(name: 'description') this.message,
    this.user,
    @JsonKey(name: 'created_by') this.createdBy,
    @JsonKey(name: 'is_read') this.isRead,
    this.name,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$SupportReplyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupportReplyModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'description')
  final String? message;
  @override
  final int? user;
  @override
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @override
  @JsonKey(name: 'is_read')
  final int? isRead;
  @override
  final String? name;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SupportReplyModel(id: $id, message: $message, user: $user, createdBy: $createdBy, isRead: $isRead, name: $name, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupportReplyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    message,
    user,
    createdBy,
    isRead,
    name,
    createdAt,
  );

  /// Create a copy of SupportReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupportReplyModelImplCopyWith<_$SupportReplyModelImpl> get copyWith =>
      __$$SupportReplyModelImplCopyWithImpl<_$SupportReplyModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SupportReplyModelImplToJson(this);
  }
}

abstract class _SupportReplyModel implements SupportReplyModel {
  const factory _SupportReplyModel({
    final int? id,
    @JsonKey(name: 'description') final String? message,
    final int? user,
    @JsonKey(name: 'created_by') final int? createdBy,
    @JsonKey(name: 'is_read') final int? isRead,
    final String? name,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$SupportReplyModelImpl;

  factory _SupportReplyModel.fromJson(Map<String, dynamic> json) =
      _$SupportReplyModelImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'description')
  String? get message;
  @override
  int? get user;
  @override
  @JsonKey(name: 'created_by')
  int? get createdBy;
  @override
  @JsonKey(name: 'is_read')
  int? get isRead;
  @override
  String? get name;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of SupportReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupportReplyModelImplCopyWith<_$SupportReplyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
