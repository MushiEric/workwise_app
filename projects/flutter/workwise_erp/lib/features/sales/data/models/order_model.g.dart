// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      quotation: json['quotation'] as String?,
      orderNumber: json['order_number'] as String?,
      invoiceNumber: json['invoice_number'] as String?,
      lpoNumber: json['lpo_number'] as String?,
      currencyId: json['currency_id'] as String?,
      exchangeRate: json['exchange_rate'] as String?,
      cargoValue: json['cargo_value'] as String?,
      cargoUnit: json['cargo_unit'] as String?,
      priority: json['priority'] as String?,
      warehouseId: (json['warehouse_id'] as num?)?.toInt(),
      statusId: (json['status_id'] as num?)?.toInt(),
      assignUserId: (json['assign_user_id'] as num?)?.toInt(),
      packageType: json['package_type'] as String?,
      senderName: json['sender_name'] as String?,
      senderPhone: json['sender_phone'] as String?,
      receiverName: json['receiver_name'] as String?,
      receiverPhone: json['receiver_phone'] as String?,
      consignmentDetails: json['consignment_details'] as String?,
      contractId: json['contract_id'] as String?,
      requestId: json['request_id'] as String?,
      quotationId: json['quotation_id'] as String?,
      paymentType: json['payment_type'] as String?,
      customerId: (json['customer_id'] as num?)?.toInt(),
      startDate: json['start_date'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      amount: json['amount'] as num?,
      paymentStatus: (json['payment_status'] as num?)?.toInt(),
      customer: json['customer'] == null
          ? null
          : CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      statusRow: json['status_row'] == null
          ? null
          : OrderStatusModel.fromJson(
              json['status_row'] as Map<String, dynamic>,
            ),
      paymentStatusRow: json['payment_status_row'] == null
          ? null
          : OrderStatusModel.fromJson(
              json['payment_status_row'] as Map<String, dynamic>,
            ),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      truckList: (json['truck_list'] as List<dynamic>?)
          ?.map((e) => TruckModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'quotation': instance.quotation,
      'order_number': instance.orderNumber,
      'invoice_number': instance.invoiceNumber,
      'lpo_number': instance.lpoNumber,
      'currency_id': instance.currencyId,
      'exchange_rate': instance.exchangeRate,
      'cargo_value': instance.cargoValue,
      'cargo_unit': instance.cargoUnit,
      'priority': instance.priority,
      'warehouse_id': instance.warehouseId,
      'status_id': instance.statusId,
      'assign_user_id': instance.assignUserId,
      'package_type': instance.packageType,
      'sender_name': instance.senderName,
      'sender_phone': instance.senderPhone,
      'receiver_name': instance.receiverName,
      'receiver_phone': instance.receiverPhone,
      'consignment_details': instance.consignmentDetails,
      'contract_id': instance.contractId,
      'request_id': instance.requestId,
      'quotation_id': instance.quotationId,
      'payment_type': instance.paymentType,
      'customer_id': instance.customerId,
      'start_date': instance.startDate,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'amount': instance.amount,
      'payment_status': instance.paymentStatus,
      'customer': instance.customer,
      'user': instance.user,
      'status_row': instance.statusRow,
      'payment_status_row': instance.paymentStatusRow,
      'items': instance.items,
      'truck_list': instance.truckList,
    };
