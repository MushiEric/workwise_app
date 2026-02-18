// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_unit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PackageUnitModel _$PackageUnitModelFromJson(Map<String, dynamic> json) {
  return _PackageUnitModel.fromJson(json);
}

/// @nodoc
mixin _$PackageUnitModel {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_name')
  String? get shortName => throw _privateConstructorUsedError;

  /// Serializes this PackageUnitModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PackageUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageUnitModelCopyWith<PackageUnitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageUnitModelCopyWith<$Res> {
  factory $PackageUnitModelCopyWith(
    PackageUnitModel value,
    $Res Function(PackageUnitModel) then,
  ) = _$PackageUnitModelCopyWithImpl<$Res, PackageUnitModel>;
  @useResult
  $Res call({
    int? id,
    String? name,
    @JsonKey(name: 'short_name') String? shortName,
  });
}

/// @nodoc
class _$PackageUnitModelCopyWithImpl<$Res, $Val extends PackageUnitModel>
    implements $PackageUnitModelCopyWith<$Res> {
  _$PackageUnitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PackageUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? shortName = freezed,
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
            shortName: freezed == shortName
                ? _value.shortName
                : shortName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackageUnitModelImplCopyWith<$Res>
    implements $PackageUnitModelCopyWith<$Res> {
  factory _$$PackageUnitModelImplCopyWith(
    _$PackageUnitModelImpl value,
    $Res Function(_$PackageUnitModelImpl) then,
  ) = __$$PackageUnitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? name,
    @JsonKey(name: 'short_name') String? shortName,
  });
}

/// @nodoc
class __$$PackageUnitModelImplCopyWithImpl<$Res>
    extends _$PackageUnitModelCopyWithImpl<$Res, _$PackageUnitModelImpl>
    implements _$$PackageUnitModelImplCopyWith<$Res> {
  __$$PackageUnitModelImplCopyWithImpl(
    _$PackageUnitModelImpl _value,
    $Res Function(_$PackageUnitModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PackageUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? shortName = freezed,
  }) {
    return _then(
      _$PackageUnitModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        shortName: freezed == shortName
            ? _value.shortName
            : shortName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageUnitModelImpl implements _PackageUnitModel {
  const _$PackageUnitModelImpl({
    this.id,
    this.name,
    @JsonKey(name: 'short_name') this.shortName,
  });

  factory _$PackageUnitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageUnitModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  @JsonKey(name: 'short_name')
  final String? shortName;

  @override
  String toString() {
    return 'PackageUnitModel(id: $id, name: $name, shortName: $shortName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageUnitModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, shortName);

  /// Create a copy of PackageUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageUnitModelImplCopyWith<_$PackageUnitModelImpl> get copyWith =>
      __$$PackageUnitModelImplCopyWithImpl<_$PackageUnitModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageUnitModelImplToJson(this);
  }
}

abstract class _PackageUnitModel implements PackageUnitModel {
  const factory _PackageUnitModel({
    final int? id,
    final String? name,
    @JsonKey(name: 'short_name') final String? shortName,
  }) = _$PackageUnitModelImpl;

  factory _PackageUnitModel.fromJson(Map<String, dynamic> json) =
      _$PackageUnitModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'short_name')
  String? get shortName;

  /// Create a copy of PackageUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageUnitModelImplCopyWith<_$PackageUnitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
