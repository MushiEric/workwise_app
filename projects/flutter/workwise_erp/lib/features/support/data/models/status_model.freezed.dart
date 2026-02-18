// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) {
  return _StatusModel.fromJson(json);
}

/// @nodoc
mixin _$StatusModel {
  int? get id => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this StatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusModelCopyWith<StatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusModelCopyWith<$Res> {
  factory $StatusModelCopyWith(
    StatusModel value,
    $Res Function(StatusModel) then,
  ) = _$StatusModelCopyWithImpl<$Res, StatusModel>;
  @useResult
  $Res call({int? id, String? status, String? color});
}

/// @nodoc
class _$StatusModelCopyWithImpl<$Res, $Val extends StatusModel>
    implements $StatusModelCopyWith<$Res> {
  _$StatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatusModelImplCopyWith<$Res>
    implements $StatusModelCopyWith<$Res> {
  factory _$$StatusModelImplCopyWith(
    _$StatusModelImpl value,
    $Res Function(_$StatusModelImpl) then,
  ) = __$$StatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? status, String? color});
}

/// @nodoc
class __$$StatusModelImplCopyWithImpl<$Res>
    extends _$StatusModelCopyWithImpl<$Res, _$StatusModelImpl>
    implements _$$StatusModelImplCopyWith<$Res> {
  __$$StatusModelImplCopyWithImpl(
    _$StatusModelImpl _value,
    $Res Function(_$StatusModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _$StatusModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StatusModelImpl implements _StatusModel {
  const _$StatusModelImpl({this.id, this.status, this.color});

  factory _$StatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? status;
  @override
  final String? color;

  @override
  String toString() {
    return 'StatusModel(id: $id, status: $status, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, color);

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusModelImplCopyWith<_$StatusModelImpl> get copyWith =>
      __$$StatusModelImplCopyWithImpl<_$StatusModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusModelImplToJson(this);
  }
}

abstract class _StatusModel implements StatusModel {
  const factory _StatusModel({
    final int? id,
    final String? status,
    final String? color,
  }) = _$StatusModelImpl;

  factory _StatusModel.fromJson(Map<String, dynamic> json) =
      _$StatusModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get status;
  @override
  String? get color;

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusModelImplCopyWith<_$StatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
