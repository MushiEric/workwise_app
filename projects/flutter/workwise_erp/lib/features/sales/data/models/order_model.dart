import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/sales_order.dart';
import 'order_item_model.dart';
import 'order_status_model.dart';
import 'truck_model.dart';
import 'package:workwise_erp/features/support/data/models/customer_model.dart';
import 'package:workwise_erp/features/auth/data/models/user_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
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
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

extension OrderModelX on OrderModel {
  SalesOrder toDomain() => SalesOrder(
    id: id,
    orderNumber: orderNumber,
    invoiceNumber: invoiceNumber,
    title: title,
    quotation: quotation,
    lpoNumber: lpoNumber,
    customerId: customerId,
    currencyId: currencyId,
    exchangeRate: exchangeRate,
    cargoValue: cargoValue,
    cargoUnit: cargoUnit,
    priority: priority,
    warehouseId: warehouseId,
    statusId: statusId,
    assignUserId: assignUserId,
    packageType: packageType,
    senderName: senderName,
    senderPhone: senderPhone,
    receiverName: receiverName,
    receiverPhone: receiverPhone,
    consignmentDetails: consignmentDetails,
    contractId: contractId,
    requestId: requestId,
    quotationId: quotationId,
    paymentType: paymentType,
    customer: customer?.toDomain(),
    user: user?.toDomain(),
    statusRow: statusRow?.toDomain(),
    paymentStatusRow: paymentStatusRow?.toDomain(),
    amount: amount,
    startDate: startDate,
    createdAt: createdAt,
    updatedAt: updatedAt,
    items: items?.map((i) => i.toDomain()).toList(),
    truckList: truckList?.map((t) => t.toDomain()).toList(),
  );
}
