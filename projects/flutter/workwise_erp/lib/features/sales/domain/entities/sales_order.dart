import 'package:equatable/equatable.dart';
import 'package:workwise_erp/features/support/domain/entities/customer_summary.dart';
import 'package:workwise_erp/features/auth/domain/entities/user.dart';

import 'order_item.dart';
import 'truck.dart';
import 'order_status.dart';

class SalesOrder extends Equatable {
  final int? id;
  final String? orderNumber;
  final String? invoiceNumber;
  final String? title;
  final String? quotation;
  final String? lpoNumber;
  final int? customerId;
  final String? currencyId;
  final String? exchangeRate;
  final String? cargoValue;
  final String? cargoUnit;
  final String? priority;
  final int? warehouseId;
  final int? statusId;
  final int? assignUserId;
  final String? packageType;
  final String? senderName;
  final String? senderPhone;
  final String? receiverName;
  final String? receiverPhone;
  final String? consignmentDetails;
  final String? contractId;
  final String? requestId;
  final String? quotationId;
  final String? paymentType;
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
    this.invoiceNumber,
    this.title,
    this.quotation,
    this.lpoNumber,
    this.customerId,
    this.currencyId,
    this.exchangeRate,
    this.cargoValue,
    this.cargoUnit,
    this.priority,
    this.warehouseId,
    this.statusId,
    this.assignUserId,
    this.packageType,
    this.senderName,
    this.senderPhone,
    this.receiverName,
    this.receiverPhone,
    this.consignmentDetails,
    this.contractId,
    this.requestId,
    this.quotationId,
    this.paymentType,
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
    invoiceNumber,
    title,
    quotation,
    lpoNumber,
    customerId,
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
