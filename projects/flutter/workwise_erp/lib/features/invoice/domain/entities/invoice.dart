import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
  final int id;
  final String? invoiceId;
  final String? subject;
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
  final String? discountType;
  final bool? showDiscountPerItem;
  final bool? showTaxPerItem;
  final int? ticketId;
  final int? jobcardId;
  final int? projectId;
  final int? tripId;
  final int? deliveryNoteId;
  final int? warehouseId;
  final int? agentId;
  final int? paymentTermId;
  final String? paymentMethod;
  final String? notes;
  final String? termsConditions;
  final List<InvoiceItem>? items;

  const Invoice({
    required this.id,
    this.invoiceId,
    this.subject,
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
    this.discountType,
    this.showDiscountPerItem,
    this.showTaxPerItem,
    this.ticketId,
    this.jobcardId,
    this.projectId,
    this.tripId,
    this.deliveryNoteId,
    this.warehouseId,
    this.agentId,
    this.paymentTermId,
    this.paymentMethod,
    this.notes,
    this.termsConditions,
    this.items,
  });

  @override
  List<Object?> get props => [
    id,
    invoiceId,
    subject,
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
    discountType,
    showDiscountPerItem,
    showTaxPerItem,
    ticketId,
    jobcardId,
    projectId,
    tripId,
    deliveryNoteId,
    warehouseId,
    agentId,
    paymentTermId,
    paymentMethod,
    notes,
    termsConditions,
    items,
  ];
}

class InvoiceItem extends Equatable {
  final int? id;
  final int? itemId;
  final String? itemName;
  final String? description;
  final double? quantity;
  final double? rate;
  final int? taxId;
  final double? subtotal;

  const InvoiceItem({
    this.id,
    this.itemId,
    this.itemName,
    this.description,
    this.quantity,
    this.rate,
    this.taxId,
    this.subtotal,
  });

  @override
  List<Object?> get props => [
    id,
    itemId,
    itemName,
    description,
    quantity,
    rate,
    taxId,
    subtotal,
  ];
}
