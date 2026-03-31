import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
  final int id;
  final String? invoiceId;
  final int? customerId;
  final int? vendorId;
  final String? issueDate;
  final String? dueDate;
  final String? invoiceNumber;
  final String? orderId;
  final int? status;
  final String? customerName;
  final String? amount;
  final String? discount;

  const Invoice({
    required this.id,
    this.invoiceId,
    this.customerId,
    this.vendorId,
    this.issueDate,
    this.dueDate,
    this.invoiceNumber,
    this.orderId,
    this.status,
    this.customerName,
    this.amount,
    this.discount,
  });

  @override
  List<Object?> get props => [
    id,
    invoiceId,
    customerId,
    vendorId,
    issueDate,
    dueDate,
    invoiceNumber,
    orderId,
    status,
    customerName,
    amount,
    discount,
  ];
}
