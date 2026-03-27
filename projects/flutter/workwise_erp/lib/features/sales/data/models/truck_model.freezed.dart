// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truck_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TruckModel _$TruckModelFromJson(Map<String, dynamic> json) {
  return _TruckModel.fromJson(json);
}

/// @nodoc
mixin _$TruckModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_id')
  int? get vehicleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_name')
  String? get vehicleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_plate_number')
  String? get vehiclePlateNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_trailer_number')
  String? get vehicleTrailerNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_name')
  String? get driverName => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_phone')
  String? get driverPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_license_number')
  String? get driverLicenseNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkin_status')
  String? get checkinStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkout_status')
  String? get checkoutStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkin_datetime')
  String? get checkinDatetime => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkout_datetime')
  String? get checkoutDatetime => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkin_weight')
  String? get checkinWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkin_weight_unit')
  String? get checkinWeightUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkout_weight')
  String? get checkoutWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkout_weight_unit')
  String? get checkoutWeightUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_weight')
  String? get netWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_weight_unit')
  String? get netWeightUnit => throw _privateConstructorUsedError;

  /// Serializes this TruckModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TruckModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TruckModelCopyWith<TruckModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TruckModelCopyWith<$Res> {
  factory $TruckModelCopyWith(
    TruckModel value,
    $Res Function(TruckModel) then,
  ) = _$TruckModelCopyWithImpl<$Res, TruckModel>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'vehicle_id') int? vehicleId,
    @JsonKey(name: 'vehicle_name') String? vehicleName,
    @JsonKey(name: 'vehicle_plate_number') String? vehiclePlateNumber,
    @JsonKey(name: 'vehicle_trailer_number') String? vehicleTrailerNumber,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'driver_phone') String? driverPhone,
    @JsonKey(name: 'driver_license_number') String? driverLicenseNumber,
    @JsonKey(name: 'checkin_status') String? checkinStatus,
    @JsonKey(name: 'checkout_status') String? checkoutStatus,
    @JsonKey(name: 'checkin_datetime') String? checkinDatetime,
    @JsonKey(name: 'checkout_datetime') String? checkoutDatetime,
    @JsonKey(name: 'checkin_weight') String? checkinWeight,
    @JsonKey(name: 'checkin_weight_unit') String? checkinWeightUnit,
    @JsonKey(name: 'checkout_weight') String? checkoutWeight,
    @JsonKey(name: 'checkout_weight_unit') String? checkoutWeightUnit,
    @JsonKey(name: 'net_weight') String? netWeight,
    @JsonKey(name: 'net_weight_unit') String? netWeightUnit,
  });
}

/// @nodoc
class _$TruckModelCopyWithImpl<$Res, $Val extends TruckModel>
    implements $TruckModelCopyWith<$Res> {
  _$TruckModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TruckModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderId = freezed,
    Object? vehicleId = freezed,
    Object? vehicleName = freezed,
    Object? vehiclePlateNumber = freezed,
    Object? vehicleTrailerNumber = freezed,
    Object? driverName = freezed,
    Object? driverPhone = freezed,
    Object? driverLicenseNumber = freezed,
    Object? checkinStatus = freezed,
    Object? checkoutStatus = freezed,
    Object? checkinDatetime = freezed,
    Object? checkoutDatetime = freezed,
    Object? checkinWeight = freezed,
    Object? checkinWeightUnit = freezed,
    Object? checkoutWeight = freezed,
    Object? checkoutWeightUnit = freezed,
    Object? netWeight = freezed,
    Object? netWeightUnit = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            orderId: freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleId: freezed == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as int?,
            vehicleName: freezed == vehicleName
                ? _value.vehicleName
                : vehicleName // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehiclePlateNumber: freezed == vehiclePlateNumber
                ? _value.vehiclePlateNumber
                : vehiclePlateNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleTrailerNumber: freezed == vehicleTrailerNumber
                ? _value.vehicleTrailerNumber
                : vehicleTrailerNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            driverName: freezed == driverName
                ? _value.driverName
                : driverName // ignore: cast_nullable_to_non_nullable
                      as String?,
            driverPhone: freezed == driverPhone
                ? _value.driverPhone
                : driverPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            driverLicenseNumber: freezed == driverLicenseNumber
                ? _value.driverLicenseNumber
                : driverLicenseNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkinStatus: freezed == checkinStatus
                ? _value.checkinStatus
                : checkinStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkoutStatus: freezed == checkoutStatus
                ? _value.checkoutStatus
                : checkoutStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkinDatetime: freezed == checkinDatetime
                ? _value.checkinDatetime
                : checkinDatetime // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkoutDatetime: freezed == checkoutDatetime
                ? _value.checkoutDatetime
                : checkoutDatetime // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkinWeight: freezed == checkinWeight
                ? _value.checkinWeight
                : checkinWeight // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkinWeightUnit: freezed == checkinWeightUnit
                ? _value.checkinWeightUnit
                : checkinWeightUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkoutWeight: freezed == checkoutWeight
                ? _value.checkoutWeight
                : checkoutWeight // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkoutWeightUnit: freezed == checkoutWeightUnit
                ? _value.checkoutWeightUnit
                : checkoutWeightUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
            netWeight: freezed == netWeight
                ? _value.netWeight
                : netWeight // ignore: cast_nullable_to_non_nullable
                      as String?,
            netWeightUnit: freezed == netWeightUnit
                ? _value.netWeightUnit
                : netWeightUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TruckModelImplCopyWith<$Res>
    implements $TruckModelCopyWith<$Res> {
  factory _$$TruckModelImplCopyWith(
    _$TruckModelImpl value,
    $Res Function(_$TruckModelImpl) then,
  ) = __$$TruckModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'vehicle_id') int? vehicleId,
    @JsonKey(name: 'vehicle_name') String? vehicleName,
    @JsonKey(name: 'vehicle_plate_number') String? vehiclePlateNumber,
    @JsonKey(name: 'vehicle_trailer_number') String? vehicleTrailerNumber,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'driver_phone') String? driverPhone,
    @JsonKey(name: 'driver_license_number') String? driverLicenseNumber,
    @JsonKey(name: 'checkin_status') String? checkinStatus,
    @JsonKey(name: 'checkout_status') String? checkoutStatus,
    @JsonKey(name: 'checkin_datetime') String? checkinDatetime,
    @JsonKey(name: 'checkout_datetime') String? checkoutDatetime,
    @JsonKey(name: 'checkin_weight') String? checkinWeight,
    @JsonKey(name: 'checkin_weight_unit') String? checkinWeightUnit,
    @JsonKey(name: 'checkout_weight') String? checkoutWeight,
    @JsonKey(name: 'checkout_weight_unit') String? checkoutWeightUnit,
    @JsonKey(name: 'net_weight') String? netWeight,
    @JsonKey(name: 'net_weight_unit') String? netWeightUnit,
  });
}

/// @nodoc
class __$$TruckModelImplCopyWithImpl<$Res>
    extends _$TruckModelCopyWithImpl<$Res, _$TruckModelImpl>
    implements _$$TruckModelImplCopyWith<$Res> {
  __$$TruckModelImplCopyWithImpl(
    _$TruckModelImpl _value,
    $Res Function(_$TruckModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TruckModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderId = freezed,
    Object? vehicleId = freezed,
    Object? vehicleName = freezed,
    Object? vehiclePlateNumber = freezed,
    Object? vehicleTrailerNumber = freezed,
    Object? driverName = freezed,
    Object? driverPhone = freezed,
    Object? driverLicenseNumber = freezed,
    Object? checkinStatus = freezed,
    Object? checkoutStatus = freezed,
    Object? checkinDatetime = freezed,
    Object? checkoutDatetime = freezed,
    Object? checkinWeight = freezed,
    Object? checkinWeightUnit = freezed,
    Object? checkoutWeight = freezed,
    Object? checkoutWeightUnit = freezed,
    Object? netWeight = freezed,
    Object? netWeightUnit = freezed,
  }) {
    return _then(
      _$TruckModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        orderId: freezed == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleId: freezed == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as int?,
        vehicleName: freezed == vehicleName
            ? _value.vehicleName
            : vehicleName // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehiclePlateNumber: freezed == vehiclePlateNumber
            ? _value.vehiclePlateNumber
            : vehiclePlateNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleTrailerNumber: freezed == vehicleTrailerNumber
            ? _value.vehicleTrailerNumber
            : vehicleTrailerNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        driverName: freezed == driverName
            ? _value.driverName
            : driverName // ignore: cast_nullable_to_non_nullable
                  as String?,
        driverPhone: freezed == driverPhone
            ? _value.driverPhone
            : driverPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        driverLicenseNumber: freezed == driverLicenseNumber
            ? _value.driverLicenseNumber
            : driverLicenseNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkinStatus: freezed == checkinStatus
            ? _value.checkinStatus
            : checkinStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkoutStatus: freezed == checkoutStatus
            ? _value.checkoutStatus
            : checkoutStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkinDatetime: freezed == checkinDatetime
            ? _value.checkinDatetime
            : checkinDatetime // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkoutDatetime: freezed == checkoutDatetime
            ? _value.checkoutDatetime
            : checkoutDatetime // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkinWeight: freezed == checkinWeight
            ? _value.checkinWeight
            : checkinWeight // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkinWeightUnit: freezed == checkinWeightUnit
            ? _value.checkinWeightUnit
            : checkinWeightUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkoutWeight: freezed == checkoutWeight
            ? _value.checkoutWeight
            : checkoutWeight // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkoutWeightUnit: freezed == checkoutWeightUnit
            ? _value.checkoutWeightUnit
            : checkoutWeightUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        netWeight: freezed == netWeight
            ? _value.netWeight
            : netWeight // ignore: cast_nullable_to_non_nullable
                  as String?,
        netWeightUnit: freezed == netWeightUnit
            ? _value.netWeightUnit
            : netWeightUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TruckModelImpl implements _TruckModel {
  const _$TruckModelImpl({
    this.id,
    @JsonKey(name: 'order_id') this.orderId,
    @JsonKey(name: 'vehicle_id') this.vehicleId,
    @JsonKey(name: 'vehicle_name') this.vehicleName,
    @JsonKey(name: 'vehicle_plate_number') this.vehiclePlateNumber,
    @JsonKey(name: 'vehicle_trailer_number') this.vehicleTrailerNumber,
    @JsonKey(name: 'driver_name') this.driverName,
    @JsonKey(name: 'driver_phone') this.driverPhone,
    @JsonKey(name: 'driver_license_number') this.driverLicenseNumber,
    @JsonKey(name: 'checkin_status') this.checkinStatus,
    @JsonKey(name: 'checkout_status') this.checkoutStatus,
    @JsonKey(name: 'checkin_datetime') this.checkinDatetime,
    @JsonKey(name: 'checkout_datetime') this.checkoutDatetime,
    @JsonKey(name: 'checkin_weight') this.checkinWeight,
    @JsonKey(name: 'checkin_weight_unit') this.checkinWeightUnit,
    @JsonKey(name: 'checkout_weight') this.checkoutWeight,
    @JsonKey(name: 'checkout_weight_unit') this.checkoutWeightUnit,
    @JsonKey(name: 'net_weight') this.netWeight,
    @JsonKey(name: 'net_weight_unit') this.netWeightUnit,
  });

  factory _$TruckModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TruckModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'order_id')
  final String? orderId;
  @override
  @JsonKey(name: 'vehicle_id')
  final int? vehicleId;
  @override
  @JsonKey(name: 'vehicle_name')
  final String? vehicleName;
  @override
  @JsonKey(name: 'vehicle_plate_number')
  final String? vehiclePlateNumber;
  @override
  @JsonKey(name: 'vehicle_trailer_number')
  final String? vehicleTrailerNumber;
  @override
  @JsonKey(name: 'driver_name')
  final String? driverName;
  @override
  @JsonKey(name: 'driver_phone')
  final String? driverPhone;
  @override
  @JsonKey(name: 'driver_license_number')
  final String? driverLicenseNumber;
  @override
  @JsonKey(name: 'checkin_status')
  final String? checkinStatus;
  @override
  @JsonKey(name: 'checkout_status')
  final String? checkoutStatus;
  @override
  @JsonKey(name: 'checkin_datetime')
  final String? checkinDatetime;
  @override
  @JsonKey(name: 'checkout_datetime')
  final String? checkoutDatetime;
  @override
  @JsonKey(name: 'checkin_weight')
  final String? checkinWeight;
  @override
  @JsonKey(name: 'checkin_weight_unit')
  final String? checkinWeightUnit;
  @override
  @JsonKey(name: 'checkout_weight')
  final String? checkoutWeight;
  @override
  @JsonKey(name: 'checkout_weight_unit')
  final String? checkoutWeightUnit;
  @override
  @JsonKey(name: 'net_weight')
  final String? netWeight;
  @override
  @JsonKey(name: 'net_weight_unit')
  final String? netWeightUnit;

  @override
  String toString() {
    return 'TruckModel(id: $id, orderId: $orderId, vehicleId: $vehicleId, vehicleName: $vehicleName, vehiclePlateNumber: $vehiclePlateNumber, vehicleTrailerNumber: $vehicleTrailerNumber, driverName: $driverName, driverPhone: $driverPhone, driverLicenseNumber: $driverLicenseNumber, checkinStatus: $checkinStatus, checkoutStatus: $checkoutStatus, checkinDatetime: $checkinDatetime, checkoutDatetime: $checkoutDatetime, checkinWeight: $checkinWeight, checkinWeightUnit: $checkinWeightUnit, checkoutWeight: $checkoutWeight, checkoutWeightUnit: $checkoutWeightUnit, netWeight: $netWeight, netWeightUnit: $netWeightUnit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TruckModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.vehicleName, vehicleName) ||
                other.vehicleName == vehicleName) &&
            (identical(other.vehiclePlateNumber, vehiclePlateNumber) ||
                other.vehiclePlateNumber == vehiclePlateNumber) &&
            (identical(other.vehicleTrailerNumber, vehicleTrailerNumber) ||
                other.vehicleTrailerNumber == vehicleTrailerNumber) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.driverPhone, driverPhone) ||
                other.driverPhone == driverPhone) &&
            (identical(other.driverLicenseNumber, driverLicenseNumber) ||
                other.driverLicenseNumber == driverLicenseNumber) &&
            (identical(other.checkinStatus, checkinStatus) ||
                other.checkinStatus == checkinStatus) &&
            (identical(other.checkoutStatus, checkoutStatus) ||
                other.checkoutStatus == checkoutStatus) &&
            (identical(other.checkinDatetime, checkinDatetime) ||
                other.checkinDatetime == checkinDatetime) &&
            (identical(other.checkoutDatetime, checkoutDatetime) ||
                other.checkoutDatetime == checkoutDatetime) &&
            (identical(other.checkinWeight, checkinWeight) ||
                other.checkinWeight == checkinWeight) &&
            (identical(other.checkinWeightUnit, checkinWeightUnit) ||
                other.checkinWeightUnit == checkinWeightUnit) &&
            (identical(other.checkoutWeight, checkoutWeight) ||
                other.checkoutWeight == checkoutWeight) &&
            (identical(other.checkoutWeightUnit, checkoutWeightUnit) ||
                other.checkoutWeightUnit == checkoutWeightUnit) &&
            (identical(other.netWeight, netWeight) ||
                other.netWeight == netWeight) &&
            (identical(other.netWeightUnit, netWeightUnit) ||
                other.netWeightUnit == netWeightUnit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    orderId,
    vehicleId,
    vehicleName,
    vehiclePlateNumber,
    vehicleTrailerNumber,
    driverName,
    driverPhone,
    driverLicenseNumber,
    checkinStatus,
    checkoutStatus,
    checkinDatetime,
    checkoutDatetime,
    checkinWeight,
    checkinWeightUnit,
    checkoutWeight,
    checkoutWeightUnit,
    netWeight,
    netWeightUnit,
  ]);

  /// Create a copy of TruckModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TruckModelImplCopyWith<_$TruckModelImpl> get copyWith =>
      __$$TruckModelImplCopyWithImpl<_$TruckModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TruckModelImplToJson(this);
  }
}

abstract class _TruckModel implements TruckModel {
  const factory _TruckModel({
    final int? id,
    @JsonKey(name: 'order_id') final String? orderId,
    @JsonKey(name: 'vehicle_id') final int? vehicleId,
    @JsonKey(name: 'vehicle_name') final String? vehicleName,
    @JsonKey(name: 'vehicle_plate_number') final String? vehiclePlateNumber,
    @JsonKey(name: 'vehicle_trailer_number') final String? vehicleTrailerNumber,
    @JsonKey(name: 'driver_name') final String? driverName,
    @JsonKey(name: 'driver_phone') final String? driverPhone,
    @JsonKey(name: 'driver_license_number') final String? driverLicenseNumber,
    @JsonKey(name: 'checkin_status') final String? checkinStatus,
    @JsonKey(name: 'checkout_status') final String? checkoutStatus,
    @JsonKey(name: 'checkin_datetime') final String? checkinDatetime,
    @JsonKey(name: 'checkout_datetime') final String? checkoutDatetime,
    @JsonKey(name: 'checkin_weight') final String? checkinWeight,
    @JsonKey(name: 'checkin_weight_unit') final String? checkinWeightUnit,
    @JsonKey(name: 'checkout_weight') final String? checkoutWeight,
    @JsonKey(name: 'checkout_weight_unit') final String? checkoutWeightUnit,
    @JsonKey(name: 'net_weight') final String? netWeight,
    @JsonKey(name: 'net_weight_unit') final String? netWeightUnit,
  }) = _$TruckModelImpl;

  factory _TruckModel.fromJson(Map<String, dynamic> json) =
      _$TruckModelImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'order_id')
  String? get orderId;
  @override
  @JsonKey(name: 'vehicle_id')
  int? get vehicleId;
  @override
  @JsonKey(name: 'vehicle_name')
  String? get vehicleName;
  @override
  @JsonKey(name: 'vehicle_plate_number')
  String? get vehiclePlateNumber;
  @override
  @JsonKey(name: 'vehicle_trailer_number')
  String? get vehicleTrailerNumber;
  @override
  @JsonKey(name: 'driver_name')
  String? get driverName;
  @override
  @JsonKey(name: 'driver_phone')
  String? get driverPhone;
  @override
  @JsonKey(name: 'driver_license_number')
  String? get driverLicenseNumber;
  @override
  @JsonKey(name: 'checkin_status')
  String? get checkinStatus;
  @override
  @JsonKey(name: 'checkout_status')
  String? get checkoutStatus;
  @override
  @JsonKey(name: 'checkin_datetime')
  String? get checkinDatetime;
  @override
  @JsonKey(name: 'checkout_datetime')
  String? get checkoutDatetime;
  @override
  @JsonKey(name: 'checkin_weight')
  String? get checkinWeight;
  @override
  @JsonKey(name: 'checkin_weight_unit')
  String? get checkinWeightUnit;
  @override
  @JsonKey(name: 'checkout_weight')
  String? get checkoutWeight;
  @override
  @JsonKey(name: 'checkout_weight_unit')
  String? get checkoutWeightUnit;
  @override
  @JsonKey(name: 'net_weight')
  String? get netWeight;
  @override
  @JsonKey(name: 'net_weight_unit')
  String? get netWeightUnit;

  /// Create a copy of TruckModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TruckModelImplCopyWith<_$TruckModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
