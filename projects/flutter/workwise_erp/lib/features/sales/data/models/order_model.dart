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
    customerId: customerId,
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
