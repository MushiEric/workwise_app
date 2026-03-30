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
  @JsonKey(name: 'invoice_number')
  String? get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'lpo_number')
  String? get lpoNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_id')
  String? get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'exchange_rate')
  String? get exchangeRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'cargo_value')
  String? get cargoValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'cargo_unit')
  String? get cargoUnit => throw _privateConstructorUsedError;
  String? get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_id')
  int? get warehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_id')
  int? get statusId => throw _privateConstructorUsedError;
  @JsonKey(name: 'assign_user_id')
  int? get assignUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'package_type')
  String? get packageType => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_name')
  String? get senderName => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_phone')
  String? get senderPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_name')
  String? get receiverName => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_phone')
  String? get receiverPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'consignment_details')
  String? get consignmentDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'contract_id')
  String? get contractId => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_id')
  String? get requestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'quotation_id')
  String? get quotationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_type')
  String? get paymentType => throw _privateConstructorUsedError;
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
    @JsonKey(name: 'invoice_number') String? invoiceNumber,
    @JsonKey(name: 'lpo_number') String? lpoNumber,
    @JsonKey(name: 'currency_id') String? currencyId,
    @JsonKey(name: 'exchange_rate') String? exchangeRate,
    @JsonKey(name: 'cargo_value') String? cargoValue,
    @JsonKey(name: 'cargo_unit') String? cargoUnit,
    String? priority,
    @JsonKey(name: 'warehouse_id') int? warehouseId,
    @JsonKey(name: 'status_id') int? statusId,
    @JsonKey(name: 'assign_user_id') int? assignUserId,
    @JsonKey(name: 'package_type') String? packageType,
    @JsonKey(name: 'sender_name') String? senderName,
    @JsonKey(name: 'sender_phone') String? senderPhone,
    @JsonKey(name: 'receiver_name') String? receiverName,
    @JsonKey(name: 'receiver_phone') String? receiverPhone,
    @JsonKey(name: 'consignment_details') String? consignmentDetails,
    @JsonKey(name: 'contract_id') String? contractId,
    @JsonKey(name: 'request_id') String? requestId,
    @JsonKey(name: 'quotation_id') String? quotationId,
    @JsonKey(name: 'payment_type') String? paymentType,
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
    Object? invoiceNumber = freezed,
    Object? lpoNumber = freezed,
    Object? currencyId = freezed,
    Object? exchangeRate = freezed,
    Object? cargoValue = freezed,
    Object? cargoUnit = freezed,
    Object? priority = freezed,
    Object? warehouseId = freezed,
    Object? statusId = freezed,
    Object? assignUserId = freezed,
    Object? packageType = freezed,
    Object? senderName = freezed,
    Object? senderPhone = freezed,
    Object? receiverName = freezed,
    Object? receiverPhone = freezed,
    Object? consignmentDetails = freezed,
    Object? contractId = freezed,
    Object? requestId = freezed,
    Object? quotationId = freezed,
    Object? paymentType = freezed,
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
            invoiceNumber: freezed == invoiceNumber
                ? _value.invoiceNumber
                : invoiceNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            lpoNumber: freezed == lpoNumber
                ? _value.lpoNumber
                : lpoNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            currencyId: freezed == currencyId
                ? _value.currencyId
                : currencyId // ignore: cast_nullable_to_non_nullable
                      as String?,
            exchangeRate: freezed == exchangeRate
                ? _value.exchangeRate
                : exchangeRate // ignore: cast_nullable_to_non_nullable
                      as String?,
            cargoValue: freezed == cargoValue
                ? _value.cargoValue
                : cargoValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            cargoUnit: freezed == cargoUnit
                ? _value.cargoUnit
                : cargoUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String?,
            warehouseId: freezed == warehouseId
                ? _value.warehouseId
                : warehouseId // ignore: cast_nullable_to_non_nullable
                      as int?,
            statusId: freezed == statusId
                ? _value.statusId
                : statusId // ignore: cast_nullable_to_non_nullable
                      as int?,
            assignUserId: freezed == assignUserId
                ? _value.assignUserId
                : assignUserId // ignore: cast_nullable_to_non_nullable
                      as int?,
            packageType: freezed == packageType
                ? _value.packageType
                : packageType // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderName: freezed == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderPhone: freezed == senderPhone
                ? _value.senderPhone
                : senderPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            receiverName: freezed == receiverName
                ? _value.receiverName
                : receiverName // ignore: cast_nullable_to_non_nullable
                      as String?,
            receiverPhone: freezed == receiverPhone
                ? _value.receiverPhone
                : receiverPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            consignmentDetails: freezed == consignmentDetails
                ? _value.consignmentDetails
                : consignmentDetails // ignore: cast_nullable_to_non_nullable
                      as String?,
            contractId: freezed == contractId
                ? _value.contractId
                : contractId // ignore: cast_nullable_to_non_nullable
                      as String?,
            requestId: freezed == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as String?,
            quotationId: freezed == quotationId
                ? _value.quotationId
                : quotationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentType: freezed == paymentType
                ? _value.paymentType
                : paymentType // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(name: 'invoice_number') String? invoiceNumber,
    @JsonKey(name: 'lpo_number') String? lpoNumber,
    @JsonKey(name: 'currency_id') String? currencyId,
    @JsonKey(name: 'exchange_rate') String? exchangeRate,
    @JsonKey(name: 'cargo_value') String? cargoValue,
    @JsonKey(name: 'cargo_unit') String? cargoUnit,
    String? priority,
    @JsonKey(name: 'warehouse_id') int? warehouseId,
    @JsonKey(name: 'status_id') int? statusId,
    @JsonKey(name: 'assign_user_id') int? assignUserId,
    @JsonKey(name: 'package_type') String? packageType,
    @JsonKey(name: 'sender_name') String? senderName,
    @JsonKey(name: 'sender_phone') String? senderPhone,
    @JsonKey(name: 'receiver_name') String? receiverName,
    @JsonKey(name: 'receiver_phone') String? receiverPhone,
    @JsonKey(name: 'consignment_details') String? consignmentDetails,
    @JsonKey(name: 'contract_id') String? contractId,
    @JsonKey(name: 'request_id') String? requestId,
    @JsonKey(name: 'quotation_id') String? quotationId,
    @JsonKey(name: 'payment_type') String? paymentType,
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
    Object? invoiceNumber = freezed,
    Object? lpoNumber = freezed,
    Object? currencyId = freezed,
    Object? exchangeRate = freezed,
    Object? cargoValue = freezed,
    Object? cargoUnit = freezed,
    Object? priority = freezed,
    Object? warehouseId = freezed,
    Object? statusId = freezed,
    Object? assignUserId = freezed,
    Object? packageType = freezed,
    Object? senderName = freezed,
    Object? senderPhone = freezed,
    Object? receiverName = freezed,
    Object? receiverPhone = freezed,
    Object? consignmentDetails = freezed,
    Object? contractId = freezed,
    Object? requestId = freezed,
    Object? quotationId = freezed,
    Object? paymentType = freezed,
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
        invoiceNumber: freezed == invoiceNumber
            ? _value.invoiceNumber
            : invoiceNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        lpoNumber: freezed == lpoNumber
            ? _value.lpoNumber
            : lpoNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        currencyId: freezed == currencyId
            ? _value.currencyId
            : currencyId // ignore: cast_nullable_to_non_nullable
                  as String?,
        exchangeRate: freezed == exchangeRate
            ? _value.exchangeRate
            : exchangeRate // ignore: cast_nullable_to_non_nullable
                  as String?,
        cargoValue: freezed == cargoValue
            ? _value.cargoValue
            : cargoValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        cargoUnit: freezed == cargoUnit
            ? _value.cargoUnit
            : cargoUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String?,
        warehouseId: freezed == warehouseId
            ? _value.warehouseId
            : warehouseId // ignore: cast_nullable_to_non_nullable
                  as int?,
        statusId: freezed == statusId
            ? _value.statusId
            : statusId // ignore: cast_nullable_to_non_nullable
                  as int?,
        assignUserId: freezed == assignUserId
            ? _value.assignUserId
            : assignUserId // ignore: cast_nullable_to_non_nullable
                  as int?,
        packageType: freezed == packageType
            ? _value.packageType
            : packageType // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderName: freezed == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderPhone: freezed == senderPhone
            ? _value.senderPhone
            : senderPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        receiverName: freezed == receiverName
            ? _value.receiverName
            : receiverName // ignore: cast_nullable_to_non_nullable
                  as String?,
        receiverPhone: freezed == receiverPhone
            ? _value.receiverPhone
            : receiverPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        consignmentDetails: freezed == consignmentDetails
            ? _value.consignmentDetails
            : consignmentDetails // ignore: cast_nullable_to_non_nullable
                  as String?,
        contractId: freezed == contractId
            ? _value.contractId
            : contractId // ignore: cast_nullable_to_non_nullable
                  as String?,
        requestId: freezed == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String?,
        quotationId: freezed == quotationId
            ? _value.quotationId
            : quotationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentType: freezed == paymentType
            ? _value.paymentType
            : paymentType // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(name: 'invoice_number') this.invoiceNumber,
    @JsonKey(name: 'lpo_number') this.lpoNumber,
    @JsonKey(name: 'currency_id') this.currencyId,
    @JsonKey(name: 'exchange_rate') this.exchangeRate,
    @JsonKey(name: 'cargo_value') this.cargoValue,
    @JsonKey(name: 'cargo_unit') this.cargoUnit,
    this.priority,
    @JsonKey(name: 'warehouse_id') this.warehouseId,
    @JsonKey(name: 'status_id') this.statusId,
    @JsonKey(name: 'assign_user_id') this.assignUserId,
    @JsonKey(name: 'package_type') this.packageType,
    @JsonKey(name: 'sender_name') this.senderName,
    @JsonKey(name: 'sender_phone') this.senderPhone,
    @JsonKey(name: 'receiver_name') this.receiverName,
    @JsonKey(name: 'receiver_phone') this.receiverPhone,
    @JsonKey(name: 'consignment_details') this.consignmentDetails,
    @JsonKey(name: 'contract_id') this.contractId,
    @JsonKey(name: 'request_id') this.requestId,
    @JsonKey(name: 'quotation_id') this.quotationId,
    @JsonKey(name: 'payment_type') this.paymentType,
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
  @JsonKey(name: 'invoice_number')
  final String? invoiceNumber;
  @override
  @JsonKey(name: 'lpo_number')
  final String? lpoNumber;
  @override
  @JsonKey(name: 'currency_id')
  final String? currencyId;
  @override
  @JsonKey(name: 'exchange_rate')
  final String? exchangeRate;
  @override
  @JsonKey(name: 'cargo_value')
  final String? cargoValue;
  @override
  @JsonKey(name: 'cargo_unit')
  final String? cargoUnit;
  @override
  final String? priority;
  @override
  @JsonKey(name: 'warehouse_id')
  final int? warehouseId;
  @override
  @JsonKey(name: 'status_id')
  final int? statusId;
  @override
  @JsonKey(name: 'assign_user_id')
  final int? assignUserId;
  @override
  @JsonKey(name: 'package_type')
  final String? packageType;
  @override
  @JsonKey(name: 'sender_name')
  final String? senderName;
  @override
  @JsonKey(name: 'sender_phone')
  final String? senderPhone;
  @override
  @JsonKey(name: 'receiver_name')
  final String? receiverName;
  @override
  @JsonKey(name: 'receiver_phone')
  final String? receiverPhone;
  @override
  @JsonKey(name: 'consignment_details')
  final String? consignmentDetails;
  @override
  @JsonKey(name: 'contract_id')
  final String? contractId;
  @override
  @JsonKey(name: 'request_id')
  final String? requestId;
  @override
  @JsonKey(name: 'quotation_id')
  final String? quotationId;
  @override
  @JsonKey(name: 'payment_type')
  final String? paymentType;
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
    return 'OrderModel(id: $id, title: $title, quotation: $quotation, orderNumber: $orderNumber, invoiceNumber: $invoiceNumber, lpoNumber: $lpoNumber, currencyId: $currencyId, exchangeRate: $exchangeRate, cargoValue: $cargoValue, cargoUnit: $cargoUnit, priority: $priority, warehouseId: $warehouseId, statusId: $statusId, assignUserId: $assignUserId, packageType: $packageType, senderName: $senderName, senderPhone: $senderPhone, receiverName: $receiverName, receiverPhone: $receiverPhone, consignmentDetails: $consignmentDetails, contractId: $contractId, requestId: $requestId, quotationId: $quotationId, paymentType: $paymentType, customerId: $customerId, startDate: $startDate, createdAt: $createdAt, updatedAt: $updatedAt, amount: $amount, paymentStatus: $paymentStatus, customer: $customer, user: $user, statusRow: $statusRow, paymentStatusRow: $paymentStatusRow, items: $items, truckList: $truckList)';
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
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.lpoNumber, lpoNumber) ||
                other.lpoNumber == lpoNumber) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.cargoValue, cargoValue) ||
                other.cargoValue == cargoValue) &&
            (identical(other.cargoUnit, cargoUnit) ||
                other.cargoUnit == cargoUnit) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.statusId, statusId) ||
                other.statusId == statusId) &&
            (identical(other.assignUserId, assignUserId) ||
                other.assignUserId == assignUserId) &&
            (identical(other.packageType, packageType) ||
                other.packageType == packageType) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderPhone, senderPhone) ||
                other.senderPhone == senderPhone) &&
            (identical(other.receiverName, receiverName) ||
                other.receiverName == receiverName) &&
            (identical(other.receiverPhone, receiverPhone) ||
                other.receiverPhone == receiverPhone) &&
            (identical(other.consignmentDetails, consignmentDetails) ||
                other.consignmentDetails == consignmentDetails) &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.quotationId, quotationId) ||
                other.quotationId == quotationId) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
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
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    quotation,
    orderNumber,
    invoiceNumber,
    lpoNumber,
    currencyId,
    exchangeRate,
    cargoValue,
    cargoUnit,
    priority,
    warehouseId,
    statusId,
    assignUserId,
    packageType,
    senderName,
    senderPhone,
    receiverName,
    receiverPhone,
    consignmentDetails,
    contractId,
    requestId,
    quotationId,
    paymentType,
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
  ]);

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
    @JsonKey(name: 'invoice_number') final String? invoiceNumber,
    @JsonKey(name: 'lpo_number') final String? lpoNumber,
    @JsonKey(name: 'currency_id') final String? currencyId,
    @JsonKey(name: 'exchange_rate') final String? exchangeRate,
    @JsonKey(name: 'cargo_value') final String? cargoValue,
    @JsonKey(name: 'cargo_unit') final String? cargoUnit,
    final String? priority,
    @JsonKey(name: 'warehouse_id') final int? warehouseId,
    @JsonKey(name: 'status_id') final int? statusId,
    @JsonKey(name: 'assign_user_id') final int? assignUserId,
    @JsonKey(name: 'package_type') final String? packageType,
    @JsonKey(name: 'sender_name') final String? senderName,
    @JsonKey(name: 'sender_phone') final String? senderPhone,
    @JsonKey(name: 'receiver_name') final String? receiverName,
    @JsonKey(name: 'receiver_phone') final String? receiverPhone,
    @JsonKey(name: 'consignment_details') final String? consignmentDetails,
    @JsonKey(name: 'contract_id') final String? contractId,
    @JsonKey(name: 'request_id') final String? requestId,
    @JsonKey(name: 'quotation_id') final String? quotationId,
    @JsonKey(name: 'payment_type') final String? paymentType,
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
  @JsonKey(name: 'invoice_number')
  String? get invoiceNumber;
  @override
  @JsonKey(name: 'lpo_number')
  String? get lpoNumber;
  @override
  @JsonKey(name: 'currency_id')
  String? get currencyId;
  @override
  @JsonKey(name: 'exchange_rate')
  String? get exchangeRate;
  @override
  @JsonKey(name: 'cargo_value')
  String? get cargoValue;
  @override
  @JsonKey(name: 'cargo_unit')
  String? get cargoUnit;
  @override
  String? get priority;
  @override
  @JsonKey(name: 'warehouse_id')
  int? get warehouseId;
  @override
  @JsonKey(name: 'status_id')
  int? get statusId;
  @override
  @JsonKey(name: 'assign_user_id')
  int? get assignUserId;
  @override
  @JsonKey(name: 'package_type')
  String? get packageType;
  @override
  @JsonKey(name: 'sender_name')
  String? get senderName;
  @override
  @JsonKey(name: 'sender_phone')
  String? get senderPhone;
  @override
  @JsonKey(name: 'receiver_name')
  String? get receiverName;
  @override
  @JsonKey(name: 'receiver_phone')
  String? get receiverPhone;
  @override
  @JsonKey(name: 'consignment_details')
  String? get consignmentDetails;
  @override
  @JsonKey(name: 'contract_id')
  String? get contractId;
  @override
  @JsonKey(name: 'request_id')
  String? get requestId;
  @override
  @JsonKey(name: 'quotation_id')
  String? get quotationId;
  @override
  @JsonKey(name: 'payment_type')
  String? get paymentType;
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
