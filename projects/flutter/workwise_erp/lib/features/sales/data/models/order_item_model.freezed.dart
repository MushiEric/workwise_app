// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  String? get itemId => throw _privateConstructorUsedError;
  String? get price => throw _privateConstructorUsedError;
  String? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'package_unit')
  PackageUnitModel? get packageUnit => throw _privateConstructorUsedError;
  ProductModel? get product => throw _privateConstructorUsedError;
  @JsonKey(name: 'loading_instruction')
  String? get loadingInstruction => throw _privateConstructorUsedError;

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
    OrderItemModel value,
    $Res Function(OrderItemModel) then,
  ) = _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'item_id') String? itemId,
    String? price,
    String? quantity,
    @JsonKey(name: 'package_unit') PackageUnitModel? packageUnit,
    ProductModel? product,
    @JsonKey(name: 'loading_instruction') String? loadingInstruction,
  });

  $PackageUnitModelCopyWith<$Res>? get packageUnit;
  $ProductModelCopyWith<$Res>? get product;
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderId = freezed,
    Object? itemId = freezed,
    Object? price = freezed,
    Object? quantity = freezed,
    Object? packageUnit = freezed,
    Object? product = freezed,
    Object? loadingInstruction = freezed,
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
            itemId: freezed == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageUnit: freezed == packageUnit
                ? _value.packageUnit
                : packageUnit // ignore: cast_nullable_to_non_nullable
                      as PackageUnitModel?,
            product: freezed == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as ProductModel?,
            loadingInstruction: freezed == loadingInstruction
                ? _value.loadingInstruction
                : loadingInstruction // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PackageUnitModelCopyWith<$Res>? get packageUnit {
    if (_value.packageUnit == null) {
      return null;
    }

    return $PackageUnitModelCopyWith<$Res>(_value.packageUnit!, (value) {
      return _then(_value.copyWith(packageUnit: value) as $Val);
    });
  }

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductModelCopyWith<$Res>? get product {
    if (_value.product == null) {
      return null;
    }

    return $ProductModelCopyWith<$Res>(_value.product!, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(
    _$OrderItemModelImpl value,
    $Res Function(_$OrderItemModelImpl) then,
  ) = __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'item_id') String? itemId,
    String? price,
    String? quantity,
    @JsonKey(name: 'package_unit') PackageUnitModel? packageUnit,
    ProductModel? product,
    @JsonKey(name: 'loading_instruction') String? loadingInstruction,
  });

  @override
  $PackageUnitModelCopyWith<$Res>? get packageUnit;
  @override
  $ProductModelCopyWith<$Res>? get product;
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
    _$OrderItemModelImpl _value,
    $Res Function(_$OrderItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderId = freezed,
    Object? itemId = freezed,
    Object? price = freezed,
    Object? quantity = freezed,
    Object? packageUnit = freezed,
    Object? product = freezed,
    Object? loadingInstruction = freezed,
  }) {
    return _then(
      _$OrderItemModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        orderId: freezed == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemId: freezed == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageUnit: freezed == packageUnit
            ? _value.packageUnit
            : packageUnit // ignore: cast_nullable_to_non_nullable
                  as PackageUnitModel?,
        product: freezed == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as ProductModel?,
        loadingInstruction: freezed == loadingInstruction
            ? _value.loadingInstruction
            : loadingInstruction // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemModelImpl implements _OrderItemModel {
  const _$OrderItemModelImpl({
    this.id,
    @JsonKey(name: 'order_id') this.orderId,
    @JsonKey(name: 'item_id') this.itemId,
    this.price,
    this.quantity,
    @JsonKey(name: 'package_unit') this.packageUnit,
    this.product,
    @JsonKey(name: 'loading_instruction') this.loadingInstruction,
  });

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'order_id')
  final String? orderId;
  @override
  @JsonKey(name: 'item_id')
  final String? itemId;
  @override
  final String? price;
  @override
  final String? quantity;
  @override
  @JsonKey(name: 'package_unit')
  final PackageUnitModel? packageUnit;
  @override
  final ProductModel? product;
  @override
  @JsonKey(name: 'loading_instruction')
  final String? loadingInstruction;

  @override
  String toString() {
    return 'OrderItemModel(id: $id, orderId: $orderId, itemId: $itemId, price: $price, quantity: $quantity, packageUnit: $packageUnit, product: $product, loadingInstruction: $loadingInstruction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.packageUnit, packageUnit) ||
                other.packageUnit == packageUnit) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.loadingInstruction, loadingInstruction) ||
                other.loadingInstruction == loadingInstruction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    itemId,
    price,
    quantity,
    packageUnit,
    product,
    loadingInstruction,
  );

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(this);
  }
}

abstract class _OrderItemModel implements OrderItemModel {
  const factory _OrderItemModel({
    final int? id,
    @JsonKey(name: 'order_id') final String? orderId,
    @JsonKey(name: 'item_id') final String? itemId,
    final String? price,
    final String? quantity,
    @JsonKey(name: 'package_unit') final PackageUnitModel? packageUnit,
    final ProductModel? product,
    @JsonKey(name: 'loading_instruction') final String? loadingInstruction,
  }) = _$OrderItemModelImpl;

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'order_id')
  String? get orderId;
  @override
  @JsonKey(name: 'item_id')
  String? get itemId;
  @override
  String? get price;
  @override
  String? get quantity;
  @override
  @JsonKey(name: 'package_unit')
  PackageUnitModel? get packageUnit;
  @override
  ProductModel? get product;
  @override
  @JsonKey(name: 'loading_instruction')
  String? get loadingInstruction;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
