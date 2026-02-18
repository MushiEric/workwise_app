import 'package:equatable/equatable.dart';
import 'package:workwise_erp/features/support/domain/entities/customer_summary.dart';
import 'package:workwise_erp/features/auth/domain/entities/user.dart';

import 'order_item.dart';
import 'truck.dart';
import 'order_status.dart';

class SalesOrder extends Equatable {
  final int? id;
  final String? orderNumber;
  final int? customerId;
  final CustomerSummary? customer;
  final User? user;
  final OrderStatus? statusRow;
  final OrderStatus? paymentStatusRow;
  final num? amount;
  final String? startDate;
  final String? createdAt;
  final String? updatedAt;
  final List<OrderItem>? items;
  final List<Truck>? truckList;

  const SalesOrder({
    this.id,
    this.orderNumber,
    this.customerId,
    this.customer,
    this.user,
    this.statusRow,
    this.paymentStatusRow,
    this.amount,
    this.startDate,
    this.createdAt,
    this.updatedAt,
    this.items,
    this.truckList,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    customerId,
    customer,
    user,
    statusRow,
    paymentStatusRow,
    amount,
    startDate,
    createdAt,
    updatedAt,
    items,
    truckList,
  ];
}
