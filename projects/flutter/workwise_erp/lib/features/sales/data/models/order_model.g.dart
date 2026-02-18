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
