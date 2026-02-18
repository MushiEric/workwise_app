// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'priority_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PriorityModel _$PriorityModelFromJson(Map<String, dynamic> json) {
  return _PriorityModel.fromJson(json);
}

/// @nodoc
mixin _$PriorityModel {
  int? get id => throw _privateConstructorUsedError;
  String? get priority => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this PriorityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriorityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriorityModelCopyWith<PriorityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriorityModelCopyWith<$Res> {
  factory $PriorityModelCopyWith(
    PriorityModel value,
    $Res Function(PriorityModel) then,
  ) = _$PriorityModelCopyWithImpl<$Res, PriorityModel>;
  @useResult
  $Res call({int? id, String? priority, String? color});
}

/// @nodoc
class _$PriorityModelCopyWithImpl<$Res, $Val extends PriorityModel>
    implements $PriorityModelCopyWith<$Res> {
  _$PriorityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriorityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? priority = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PriorityModelImplCopyWith<$Res>
    implements $PriorityModelCopyWith<$Res> {
  factory _$$PriorityModelImplCopyWith(
    _$PriorityModelImpl value,
    $Res Function(_$PriorityModelImpl) then,
  ) = __$$PriorityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? priority, String? color});
}

/// @nodoc
class __$$PriorityModelImplCopyWithImpl<$Res>
    extends _$PriorityModelCopyWithImpl<$Res, _$PriorityModelImpl>
    implements _$$PriorityModelImplCopyWith<$Res> {
  __$$PriorityModelImplCopyWithImpl(
    _$PriorityModelImpl _value,
    $Res Function(_$PriorityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PriorityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? priority = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _$PriorityModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
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
class _$PriorityModelImpl implements _PriorityModel {
  const _$PriorityModelImpl({this.id, this.priority, this.color});

  factory _$PriorityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriorityModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? priority;
  @override
  final String? color;

  @override
  String toString() {
    return 'PriorityModel(id: $id, priority: $priority, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriorityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, priority, color);

  /// Create a copy of PriorityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriorityModelImplCopyWith<_$PriorityModelImpl> get copyWith =>
      __$$PriorityModelImplCopyWithImpl<_$PriorityModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriorityModelImplToJson(this);
  }
}

abstract class _PriorityModel implements PriorityModel {
  const factory _PriorityModel({
    final int? id,
    final String? priority,
    final String? color,
  }) = _$PriorityModelImpl;

  factory _PriorityModel.fromJson(Map<String, dynamic> json) =
      _$PriorityModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get priority;
  @override
  String? get color;

  /// Create a copy of PriorityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriorityModelImplCopyWith<_$PriorityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
