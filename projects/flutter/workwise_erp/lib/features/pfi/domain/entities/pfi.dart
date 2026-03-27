import 'package:equatable/equatable.dart';

class Pfi extends Equatable {
  final int id;
  final String? proposalNumber;
  final String? subject;
  final int? customerId;
  final String? requestId;
  final int? currency;
  final String? currencyExchangeRate;
  final int? status;
  final DateTime? createdAt;
  final String? customerName;
  final double? total;

  // New fields from Image
  final DateTime? issueDate;
  final DateTime? dueDate;
  final String? discountType;
  final String? showDiscountPerItem;
  final String? showTaxPerItem;
  final String? supportTicketId;
  final String? jobcardId;
  final String? projectId;
  final String? tripId;
  final String? warehouseId;
  final String? salesAgentId;
  final String? attachmentPath;
  final String? paymentTermsId;
  final String? paymentMethodId;
  
  // Subscription fields
  final DateTime? subscriptionStartDate;
  final String? subscriptionDuration;
  final DateTime? subscriptionEndDate;
  final bool? isRecurring;

  // Items & Footer
  final List<PfiItem>? items;
  final List<PfiPayment>? payments;
  final String? notes;
  final String? terms;

  const Pfi({
    required this.id,
    this.proposalNumber,
    this.subject,
    this.customerId,
    this.requestId,
    this.currency,
    this.currencyExchangeRate,
    this.status,
    this.createdAt,
    this.issueDate,
    this.dueDate,
    this.discountType,
    this.showDiscountPerItem,
    this.showTaxPerItem,
    this.supportTicketId,
    this.jobcardId,
    this.projectId,
    this.tripId,
    this.warehouseId,
    this.salesAgentId,
    this.attachmentPath,
    this.paymentTermsId,
    this.paymentMethodId,
    this.subscriptionStartDate,
    this.subscriptionDuration,
    this.subscriptionEndDate,
    this.isRecurring,
    this.items,
    this.payments,
    this.notes,
    this.terms,
    this.customerName,
    this.total,
  });

  @override
  List<Object?> get props => [
    id, proposalNumber, subject, customerId, requestId, currency, 
    currencyExchangeRate, status, createdAt, issueDate, dueDate,
    discountType, showDiscountPerItem, showTaxPerItem, supportTicketId,
    jobcardId, projectId, tripId, warehouseId, salesAgentId,
    attachmentPath, paymentTermsId, paymentMethodId,
    subscriptionStartDate, subscriptionDuration, subscriptionEndDate,
    isRecurring, items, payments, notes, terms,
    customerName, total,
  ];
}

class PfiPayment extends Equatable {
  final int? id;
  final String? paymentReceipt;
  final DateTime? date;
  final double? amount;
  final String? paymentType;
  final String? reference;

  const PfiPayment({
    this.id,
    this.paymentReceipt,
    this.date,
    this.amount,
    this.paymentType,
    this.reference,
  });

  @override
  List<Object?> get props => [id, paymentReceipt, date, amount, paymentType, reference];
}

class PfiItem extends Equatable {
  final int? id;
  final String? itemId;
  final bool? isCustom;
  final String? description;
  final double? qty;
  final String? uomId;
  final double? period;
  final String? periodUnit;
  final double? rate;
  final String? tax;
  final double? subtotal;

  const PfiItem({
    this.id,
    this.itemId,
    this.isCustom,
    this.description,
    this.qty,
    this.uomId,
    this.period,
    this.periodUnit,
    this.rate,
    this.tax,
    this.subtotal,
  });

  @override
  List<Object?> get props => [
    id, itemId, isCustom, description, qty, uomId, 
    period, periodUnit, rate, tax, subtotal,
  ];
}
