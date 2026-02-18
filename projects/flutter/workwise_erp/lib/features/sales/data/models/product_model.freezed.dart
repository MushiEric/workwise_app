// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_price')
  String? get salePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_price')
  String? get purchasePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_number')
  String? get itemNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int? get categoryId => throw _privateConstructorUsedError;

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
    ProductModel value,
    $Res Function(ProductModel) then,
  ) = _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call({
    int? id,
    String? name,
    @JsonKey(name: 'sale_price') String? salePrice,
    @JsonKey(name: 'purchase_price') String? purchasePrice,
    @JsonKey(name: 'item_number') String? itemNumber,
    @JsonKey(name: 'category_id') int? categoryId,
  });
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? salePrice = freezed,
    Object? purchasePrice = freezed,
    Object? itemNumber = freezed,
    Object? categoryId = freezed,
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
            salePrice: freezed == salePrice
                ? _value.salePrice
                : salePrice // ignore: cast_nullable_to_non_nullable
                      as String?,
            purchasePrice: freezed == purchasePrice
                ? _value.purchasePrice
                : purchasePrice // ignore: cast_nullable_to_non_nullable
                      as String?,
            itemNumber: freezed == itemNumber
                ? _value.itemNumber
                : itemNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
    _$ProductModelImpl value,
    $Res Function(_$ProductModelImpl) then,
  ) = __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? name,
    @JsonKey(name: 'sale_price') String? salePrice,
    @JsonKey(name: 'purchase_price') String? purchasePrice,
    @JsonKey(name: 'item_number') String? itemNumber,
    @JsonKey(name: 'category_id') int? categoryId,
  });
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
    _$ProductModelImpl _value,
    $Res Function(_$ProductModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? salePrice = freezed,
    Object? purchasePrice = freezed,
    Object? itemNumber = freezed,
    Object? categoryId = freezed,
  }) {
    return _then(
      _$ProductModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        salePrice: freezed == salePrice
            ? _value.salePrice
            : salePrice // ignore: cast_nullable_to_non_nullable
                  as String?,
        purchasePrice: freezed == purchasePrice
            ? _value.purchasePrice
            : purchasePrice // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemNumber: freezed == itemNumber
            ? _value.itemNumber
            : itemNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl implements _ProductModel {
  const _$ProductModelImpl({
    this.id,
    this.name,
    @JsonKey(name: 'sale_price') this.salePrice,
    @JsonKey(name: 'purchase_price') this.purchasePrice,
    @JsonKey(name: 'item_number') this.itemNumber,
    @JsonKey(name: 'category_id') this.categoryId,
  });

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  @JsonKey(name: 'sale_price')
  final String? salePrice;
  @override
  @JsonKey(name: 'purchase_price')
  final String? purchasePrice;
  @override
  @JsonKey(name: 'item_number')
  final String? itemNumber;
  @override
  @JsonKey(name: 'category_id')
  final int? categoryId;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, salePrice: $salePrice, purchasePrice: $purchasePrice, itemNumber: $itemNumber, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.itemNumber, itemNumber) ||
                other.itemNumber == itemNumber) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    salePrice,
    purchasePrice,
    itemNumber,
    categoryId,
  );

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(this);
  }
}

abstract class _ProductModel implements ProductModel {
  const factory _ProductModel({
    final int? id,
    final String? name,
    @JsonKey(name: 'sale_price') final String? salePrice,
    @JsonKey(name: 'purchase_price') final String? purchasePrice,
    @JsonKey(name: 'item_number') final String? itemNumber,
    @JsonKey(name: 'category_id') final int? categoryId,
  }) = _$ProductModelImpl;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'sale_price')
  String? get salePrice;
  @override
  @JsonKey(name: 'purchase_price')
  String? get purchasePrice;
  @override
  @JsonKey(name: 'item_number')
  String? get itemNumber;
  @override
  @JsonKey(name: 'category_id')
  int? get categoryId;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
