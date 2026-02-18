// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AssetModel _$AssetModelFromJson(Map<String, dynamic> json) {
  return _AssetModel.fromJson(json);
}

/// @nodoc
mixin _$AssetModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'asset_id')
  String? get assetId => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'registration_number')
  String? get registrationNumber => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get year => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  int? get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  int? get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_gps')
  bool? get hasGps => throw _privateConstructorUsedError;
  String? get vin => throw _privateConstructorUsedError;
  String? get make => throw _privateConstructorUsedError;
  @JsonKey(name: 'company')
  String? get company => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_consuption')
  num? get fuelConsumption => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AssetModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssetModelCopyWith<AssetModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetModelCopyWith<$Res> {
  factory $AssetModelCopyWith(
    AssetModel value,
    $Res Function(AssetModel) then,
  ) = _$AssetModelCopyWithImpl<$Res, AssetModel>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'asset_id') String? assetId,
    String? type,
    String? name,
    @JsonKey(name: 'registration_number') String? registrationNumber,
    String? model,
    String? image,
    String? year,
    String? status,
    @JsonKey(name: 'is_available') int? isAvailable,
    @JsonKey(name: 'is_active') int? isActive,
    @JsonKey(name: 'has_gps') bool? hasGps,
    String? vin,
    String? make,
    @JsonKey(name: 'company') String? company,
    @JsonKey(name: 'fuel_consuption') num? fuelConsumption,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$AssetModelCopyWithImpl<$Res, $Val extends AssetModel>
    implements $AssetModelCopyWith<$Res> {
  _$AssetModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? assetId = freezed,
    Object? type = freezed,
    Object? name = freezed,
    Object? registrationNumber = freezed,
    Object? model = freezed,
    Object? image = freezed,
    Object? year = freezed,
    Object? status = freezed,
    Object? isAvailable = freezed,
    Object? isActive = freezed,
    Object? hasGps = freezed,
    Object? vin = freezed,
    Object? make = freezed,
    Object? company = freezed,
    Object? fuelConsumption = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            assetId: freezed == assetId
                ? _value.assetId
                : assetId // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            registrationNumber: freezed == registrationNumber
                ? _value.registrationNumber
                : registrationNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            model: freezed == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String?,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
            year: freezed == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAvailable: freezed == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as int?,
            isActive: freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as int?,
            hasGps: freezed == hasGps
                ? _value.hasGps
                : hasGps // ignore: cast_nullable_to_non_nullable
                      as bool?,
            vin: freezed == vin
                ? _value.vin
                : vin // ignore: cast_nullable_to_non_nullable
                      as String?,
            make: freezed == make
                ? _value.make
                : make // ignore: cast_nullable_to_non_nullable
                      as String?,
            company: freezed == company
                ? _value.company
                : company // ignore: cast_nullable_to_non_nullable
                      as String?,
            fuelConsumption: freezed == fuelConsumption
                ? _value.fuelConsumption
                : fuelConsumption // ignore: cast_nullable_to_non_nullable
                      as num?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssetModelImplCopyWith<$Res>
    implements $AssetModelCopyWith<$Res> {
  factory _$$AssetModelImplCopyWith(
    _$AssetModelImpl value,
    $Res Function(_$AssetModelImpl) then,
  ) = __$$AssetModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'asset_id') String? assetId,
    String? type,
    String? name,
    @JsonKey(name: 'registration_number') String? registrationNumber,
    String? model,
    String? image,
    String? year,
    String? status,
    @JsonKey(name: 'is_available') int? isAvailable,
    @JsonKey(name: 'is_active') int? isActive,
    @JsonKey(name: 'has_gps') bool? hasGps,
    String? vin,
    String? make,
    @JsonKey(name: 'company') String? company,
    @JsonKey(name: 'fuel_consuption') num? fuelConsumption,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$AssetModelImplCopyWithImpl<$Res>
    extends _$AssetModelCopyWithImpl<$Res, _$AssetModelImpl>
    implements _$$AssetModelImplCopyWith<$Res> {
  __$$AssetModelImplCopyWithImpl(
    _$AssetModelImpl _value,
    $Res Function(_$AssetModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? assetId = freezed,
    Object? type = freezed,
    Object? name = freezed,
    Object? registrationNumber = freezed,
    Object? model = freezed,
    Object? image = freezed,
    Object? year = freezed,
    Object? status = freezed,
    Object? isAvailable = freezed,
    Object? isActive = freezed,
    Object? hasGps = freezed,
    Object? vin = freezed,
    Object? make = freezed,
    Object? company = freezed,
    Object? fuelConsumption = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$AssetModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        assetId: freezed == assetId
            ? _value.assetId
            : assetId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        registrationNumber: freezed == registrationNumber
            ? _value.registrationNumber
            : registrationNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        model: freezed == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String?,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
        year: freezed == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAvailable: freezed == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as int?,
        isActive: freezed == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as int?,
        hasGps: freezed == hasGps
            ? _value.hasGps
            : hasGps // ignore: cast_nullable_to_non_nullable
                  as bool?,
        vin: freezed == vin
            ? _value.vin
            : vin // ignore: cast_nullable_to_non_nullable
                  as String?,
        make: freezed == make
            ? _value.make
            : make // ignore: cast_nullable_to_non_nullable
                  as String?,
        company: freezed == company
            ? _value.company
            : company // ignore: cast_nullable_to_non_nullable
                  as String?,
        fuelConsumption: freezed == fuelConsumption
            ? _value.fuelConsumption
            : fuelConsumption // ignore: cast_nullable_to_non_nullable
                  as num?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetModelImpl implements _AssetModel {
  const _$AssetModelImpl({
    this.id,
    @JsonKey(name: 'asset_id') this.assetId,
    this.type,
    this.name,
    @JsonKey(name: 'registration_number') this.registrationNumber,
    this.model,
    this.image,
    this.year,
    this.status,
    @JsonKey(name: 'is_available') this.isAvailable,
    @JsonKey(name: 'is_active') this.isActive,
    @JsonKey(name: 'has_gps') this.hasGps,
    this.vin,
    this.make,
    @JsonKey(name: 'company') this.company,
    @JsonKey(name: 'fuel_consuption') this.fuelConsumption,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$AssetModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'asset_id')
  final String? assetId;
  @override
  final String? type;
  @override
  final String? name;
  @override
  @JsonKey(name: 'registration_number')
  final String? registrationNumber;
  @override
  final String? model;
  @override
  final String? image;
  @override
  final String? year;
  @override
  final String? status;
  @override
  @JsonKey(name: 'is_available')
  final int? isAvailable;
  @override
  @JsonKey(name: 'is_active')
  final int? isActive;
  @override
  @JsonKey(name: 'has_gps')
  final bool? hasGps;
  @override
  final String? vin;
  @override
  final String? make;
  @override
  @JsonKey(name: 'company')
  final String? company;
  @override
  @JsonKey(name: 'fuel_consuption')
  final num? fuelConsumption;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'AssetModel(id: $id, assetId: $assetId, type: $type, name: $name, registrationNumber: $registrationNumber, model: $model, image: $image, year: $year, status: $status, isAvailable: $isAvailable, isActive: $isActive, hasGps: $hasGps, vin: $vin, make: $make, company: $company, fuelConsumption: $fuelConsumption, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.registrationNumber, registrationNumber) ||
                other.registrationNumber == registrationNumber) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.hasGps, hasGps) || other.hasGps == hasGps) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.make, make) || other.make == make) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.fuelConsumption, fuelConsumption) ||
                other.fuelConsumption == fuelConsumption) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    assetId,
    type,
    name,
    registrationNumber,
    model,
    image,
    year,
    status,
    isAvailable,
    isActive,
    hasGps,
    vin,
    make,
    company,
    fuelConsumption,
    createdAt,
  );

  /// Create a copy of AssetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetModelImplCopyWith<_$AssetModelImpl> get copyWith =>
      __$$AssetModelImplCopyWithImpl<_$AssetModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetModelImplToJson(this);
  }
}

abstract class _AssetModel implements AssetModel {
  const factory _AssetModel({
    final int? id,
    @JsonKey(name: 'asset_id') final String? assetId,
    final String? type,
    final String? name,
    @JsonKey(name: 'registration_number') final String? registrationNumber,
    final String? model,
    final String? image,
    final String? year,
    final String? status,
    @JsonKey(name: 'is_available') final int? isAvailable,
    @JsonKey(name: 'is_active') final int? isActive,
    @JsonKey(name: 'has_gps') final bool? hasGps,
    final String? vin,
    final String? make,
    @JsonKey(name: 'company') final String? company,
    @JsonKey(name: 'fuel_consuption') final num? fuelConsumption,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$AssetModelImpl;

  factory _AssetModel.fromJson(Map<String, dynamic> json) =
      _$AssetModelImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'asset_id')
  String? get assetId;
  @override
  String? get type;
  @override
  String? get name;
  @override
  @JsonKey(name: 'registration_number')
  String? get registrationNumber;
  @override
  String? get model;
  @override
  String? get image;
  @override
  String? get year;
  @override
  String? get status;
  @override
  @JsonKey(name: 'is_available')
  int? get isAvailable;
  @override
  @JsonKey(name: 'is_active')
  int? get isActive;
  @override
  @JsonKey(name: 'has_gps')
  bool? get hasGps;
  @override
  String? get vin;
  @override
  String? get make;
  @override
  @JsonKey(name: 'company')
  String? get company;
  @override
  @JsonKey(name: 'fuel_consuption')
  num? get fuelConsumption;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of AssetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssetModelImplCopyWith<_$AssetModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
