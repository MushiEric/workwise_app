// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get quotation => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String? get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  int? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  String? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  num? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  int? get paymentStatus => throw _privateConstructorUsedError;
  CustomerModel? get customer => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_row')
  OrderStatusModel? get statusRow => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status_row')
  OrderStatusModel? get paymentStatusRow => throw _privateConstructorUsedError;
  List<OrderItemModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'truck_list')
  List<TruckModel>? get truckList => throw _privateConstructorUsedError;

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
    OrderModel value,
    $Res Function(OrderModel) then,
  ) = _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call({
    int? id,
    String? title,
    String? quotation,
    @JsonKey(name: 'order_number') String? orderNumber,
    @JsonKey(name: 'customer_id') int? customerId,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    num? amount,
    @JsonKey(name: 'payment_status') int? paymentStatus,
    CustomerModel? customer,
    UserModel? user,
    @JsonKey(name: 'status_row') OrderStatusModel? statusRow,
    @JsonKey(name: 'payment_status_row') OrderStatusModel? paymentStatusRow,
    List<OrderItemModel>? items,
    @JsonKey(name: 'truck_list') List<TruckModel>? truckList,
  });

  $CustomerModelCopyWith<$Res>? get customer;
  $UserModelCopyWith<$Res>? get user;
  $OrderStatusModelCopyWith<$Res>? get statusRow;
  $OrderStatusModelCopyWith<$Res>? get paymentStatusRow;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? quotation = freezed,
    Object? orderNumber = freezed,
    Object? customerId = freezed,
    Object? startDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? amount = freezed,
    Object? paymentStatus = freezed,
    Object? customer = freezed,
    Object? user = freezed,
    Object? statusRow = freezed,
    Object? paymentStatusRow = freezed,
    Object? items = freezed,
    Object? truckList = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            quotation: freezed == quotation
                ? _value.quotation
                : quotation // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderNumber: freezed == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as num?,
            paymentStatus: freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as int?,
            customer: freezed == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                      as CustomerModel?,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            statusRow: freezed == statusRow
                ? _value.statusRow
                : statusRow // ignore: cast_nullable_to_non_nullable
                      as OrderStatusModel?,
            paymentStatusRow: freezed == paymentStatusRow
                ? _value.paymentStatusRow
                : paymentStatusRow // ignore: cast_nullable_to_non_nullable
                      as OrderStatusModel?,
            items: freezed == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItemModel>?,
            truckList: freezed == truckList
                ? _value.truckList
                : truckList // ignore: cast_nullable_to_non_nullable
                      as List<TruckModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res>? get customer {
    if (_value.customer == null) {
      return null;
    }

    return $CustomerModelCopyWith<$Res>(_value.customer!, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderStatusModelCopyWith<$Res>? get statusRow {
    if (_value.statusRow == null) {
      return null;
    }

    return $OrderStatusModelCopyWith<$Res>(_value.statusRow!, (value) {
      return _then(_value.copyWith(statusRow: value) as $Val);
    });
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderStatusModelCopyWith<$Res>? get paymentStatusRow {
    if (_value.paymentStatusRow == null) {
      return null;
    }

    return $OrderStatusModelCopyWith<$Res>(_value.paymentStatusRow!, (value) {
      return _then(_value.copyWith(paymentStatusRow: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
    _$OrderModelImpl value,
    $Res Function(_$OrderModelImpl) then,
  ) = __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? title,
    String? quotation,
    @JsonKey(name: 'order_number') String? orderNumber,
    @JsonKey(name: 'customer_id') int? customerId,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    num? amount,
    @JsonKey(name: 'payment_status') int? paymentStatus,
    CustomerModel? customer,
    UserModel? user,
    @JsonKey(name: 'status_row') OrderStatusModel? statusRow,
    @JsonKey(name: 'payment_status_row') OrderStatusModel? paymentStatusRow,
    List<OrderItemModel>? items,
    @JsonKey(name: 'truck_list') List<TruckModel>? truckList,
  });

  @override
  $CustomerModelCopyWith<$Res>? get customer;
  @override
  $UserModelCopyWith<$Res>? get user;
  @override
  $OrderStatusModelCopyWith<$Res>? get statusRow;
  @override
  $OrderStatusModelCopyWith<$Res>? get paymentStatusRow;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
    _$OrderModelImpl _value,
    $Res Function(_$OrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? quotation = freezed,
    Object? orderNumber = freezed,
    Object? customerId = freezed,
    Object? startDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? amount = freezed,
    Object? paymentStatus = freezed,
    Object? customer = freezed,
    Object? user = freezed,
    Object? statusRow = freezed,
    Object? paymentStatusRow = freezed,
    Object? items = freezed,
    Object? truckList = freezed,
  }) {
    return _then(
      _$OrderModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        quotation: freezed == quotation
            ? _value.quotation
            : quotation // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderNumber: freezed == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as int?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as num?,
        paymentStatus: freezed == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as int?,
        customer: freezed == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as CustomerModel?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        statusRow: freezed == statusRow
            ? _value.statusRow
            : statusRow // ignore: cast_nullable_to_non_nullable
                  as OrderStatusModel?,
        paymentStatusRow: freezed == paymentStatusRow
            ? _value.paymentStatusRow
            : paymentStatusRow // ignore: cast_nullable_to_non_nullable
                  as OrderStatusModel?,
        items: freezed == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItemModel>?,
        truckList: freezed == truckList
            ? _value._truckList
            : truckList // ignore: cast_nullable_to_non_nullable
                  as List<TruckModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl({
    this.id,
    this.title,
    this.quotation,
    @JsonKey(name: 'order_number') this.orderNumber,
    @JsonKey(name: 'customer_id') this.customerId,
    @JsonKey(name: 'start_date') this.startDate,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    this.amount,
    @JsonKey(name: 'payment_status') this.paymentStatus,
    this.customer,
    this.user,
    @JsonKey(name: 'status_row') this.statusRow,
    @JsonKey(name: 'payment_status_row') this.paymentStatusRow,
    final List<OrderItemModel>? items,
    @JsonKey(name: 'truck_list') final List<TruckModel>? truckList,
  }) : _items = items,
       _truckList = truckList;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? quotation;
  @override
  @JsonKey(name: 'order_number')
  final String? orderNumber;
  @override
  @JsonKey(name: 'customer_id')
  final int? customerId;
  @override
  @JsonKey(name: 'start_date')
  final String? startDate;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  final num? amount;
  @override
  @JsonKey(name: 'payment_status')
  final int? paymentStatus;
  @override
  final CustomerModel? customer;
  @override
  final UserModel? user;
  @override
  @JsonKey(name: 'status_row')
  final OrderStatusModel? statusRow;
  @override
  @JsonKey(name: 'payment_status_row')
  final OrderStatusModel? paymentStatusRow;
  final List<OrderItemModel>? _items;
  @override
  List<OrderItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<TruckModel>? _truckList;
  @override
  @JsonKey(name: 'truck_list')
  List<TruckModel>? get truckList {
    final value = _truckList;
    if (value == null) return null;
    if (_truckList is EqualUnmodifiableListView) return _truckList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, title: $title, quotation: $quotation, orderNumber: $orderNumber, customerId: $customerId, startDate: $startDate, createdAt: $createdAt, updatedAt: $updatedAt, amount: $amount, paymentStatus: $paymentStatus, customer: $customer, user: $user, statusRow: $statusRow, paymentStatusRow: $paymentStatusRow, items: $items, truckList: $truckList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.quotation, quotation) ||
                other.quotation == quotation) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.statusRow, statusRow) ||
                other.statusRow == statusRow) &&
            (identical(other.paymentStatusRow, paymentStatusRow) ||
                other.paymentStatusRow == paymentStatusRow) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._truckList,
              _truckList,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    quotation,
    orderNumber,
    customerId,
    startDate,
    createdAt,
    updatedAt,
    amount,
    paymentStatus,
    customer,
    user,
    statusRow,
    paymentStatusRow,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_truckList),
  );

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(this);
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel({
    final int? id,
    final String? title,
    final String? quotation,
    @JsonKey(name: 'order_number') final String? orderNumber,
    @JsonKey(name: 'customer_id') final int? customerId,
    @JsonKey(name: 'start_date') final String? startDate,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    final num? amount,
    @JsonKey(name: 'payment_status') final int? paymentStatus,
    final CustomerModel? customer,
    final UserModel? user,
    @JsonKey(name: 'status_row') final OrderStatusModel? statusRow,
    @JsonKey(name: 'payment_status_row')
    final OrderStatusModel? paymentStatusRow,
    final List<OrderItemModel>? items,
    @JsonKey(name: 'truck_list') final List<TruckModel>? truckList,
  }) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get title;
  @override
  String? get quotation;
  @override
  @JsonKey(name: 'order_number')
  String? get orderNumber;
  @override
  @JsonKey(name: 'customer_id')
  int? get customerId;
  @override
  @JsonKey(name: 'start_date')
  String? get startDate;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  num? get amount;
  @override
  @JsonKey(name: 'payment_status')
  int? get paymentStatus;
  @override
  CustomerModel? get customer;
  @override
  UserModel? get user;
  @override
  @JsonKey(name: 'status_row')
  OrderStatusModel? get statusRow;
  @override
  @JsonKey(name: 'payment_status_row')
  OrderStatusModel? get paymentStatusRow;
  @override
  List<OrderItemModel>? get items;
  @override
  @JsonKey(name: 'truck_list')
  List<TruckModel>? get truckList;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
