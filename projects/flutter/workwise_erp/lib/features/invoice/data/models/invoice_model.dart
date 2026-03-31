import '../../domain/entities/invoice.dart';

class InvoiceModel {
  final int? id;
  final String? invoiceId;
  final int? customerId;
  final int? vendorId;
  final String? issueDate;
  final String? dueDate;
  final String? invoiceNumber;
  final String? orderId;
  final int? status;
  final String? amount;
  final String? discount;
  final String? customerName;

  InvoiceModel({
    this.id,
    this.invoiceId,
    this.customerId,
    this.vendorId,
    this.issueDate,
    this.dueDate,
    this.invoiceNumber,
    this.orderId,
    this.status,
    this.amount,
    this.discount,
    this.customerName,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    int? _asInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    String? _asString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    return InvoiceModel(
      id: _asInt(json['id']),
      invoiceId: _asString(json['invoice_id']),
      customerId: _asInt(json['customer_id']),
      vendorId: _asInt(json['vendor_id']),
      issueDate: _asString(json['issue_date']),
      dueDate: _asString(json['due_date']),
      invoiceNumber: _asString(json['invoice_number']),
      orderId: _asString(json['order_id']),
      status: _asInt(json['status']),
      customerName: _asString(
        json['customer'] is Map
            ? (json['customer']['name'] ?? '')
            : json['customer'],
      ),
      amount: _asString(
        json['total'] ?? json['amount'] ?? json['invoice_amount'],
      ),
      discount: _asString(
        json['totalDiscount'] ?? json['discount'] ?? json['totalDiscountType'],
      ),
    );
  }

  Invoice toDomain() {
    return Invoice(
      id: id ?? 0,
      invoiceId: invoiceId,
      customerId: customerId,
      vendorId: vendorId,
      issueDate: issueDate,
      dueDate: dueDate,
      invoiceNumber: invoiceNumber,
      orderId: orderId,
      status: status,
      customerName: customerName,
      amount: amount,
      discount: discount,
    );
  }
}
