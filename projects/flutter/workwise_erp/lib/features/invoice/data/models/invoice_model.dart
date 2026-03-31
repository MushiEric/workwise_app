import '../../domain/entities/invoice.dart';

class InvoiceModel {
  final int? id;
  final String? invoiceId;
  final String? subject;
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
  final List<InvoiceItemModel>? items;

  InvoiceModel({
    this.id,
    this.invoiceId,
    this.subject,
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

    bool? _asBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value == 1 || value == '1' || value == 'yes') return true;
      if (value == 0 || value == '0' || value == 'no') return false;
      return null;
    }

    return InvoiceModel(
      id: _asInt(json['id']),
      invoiceId: _asString(json['invoice_id']),
      subject: _asString(json['subject']),
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
      discountType: _asString(json['discount_type']),
      showDiscountPerItem: _asBool(json['show_discount_per_item']),
      showTaxPerItem: _asBool(json['show_tax_per_item']),
      ticketId: _asInt(json['ticket_id']),
      jobcardId: _asInt(json['jobcard_id']),
      projectId: _asInt(json['project_id']),
      tripId: _asInt(json['trip_id']),
      deliveryNoteId: _asInt(json['delivery_note_id']),
      warehouseId: _asInt(json['warehouse_id']),
      agentId: _asInt(json['agent_id']),
      paymentTermId: _asInt(json['payment_term_id']),
      paymentMethod: _asString(json['payment_method']),
      notes: _asString(json['notes']),
      termsConditions: _asString(json['terms_conditions']),
      items: (json['items'] as List?)
          ?.map((e) => InvoiceItemModel.fromJson(e))
          .toList(),
    );
  }

  Invoice toDomain() {
    return Invoice(
      id: id ?? 0,
      invoiceId: invoiceId,
      subject: subject,
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
      discountType: discountType,
      showDiscountPerItem: showDiscountPerItem,
      showTaxPerItem: showTaxPerItem,
      ticketId: ticketId,
      jobcardId: jobcardId,
      projectId: projectId,
      tripId: tripId,
      deliveryNoteId: deliveryNoteId,
      warehouseId: warehouseId,
      agentId: agentId,
      paymentTermId: paymentTermId,
      paymentMethod: paymentMethod,
      notes: notes,
      termsConditions: termsConditions,
      items: items?.map((e) => e.toDomain()).toList(),
    );
  }
}

class InvoiceItemModel {
  final int? id;
  final int? itemId;
  final String? itemName;
  final String? description;
  final double? quantity;
  final double? rate;
  final int? taxId;
  final double? subtotal;

  InvoiceItemModel({
    this.id,
    this.itemId,
    this.itemName,
    this.description,
    this.quantity,
    this.rate,
    this.taxId,
    this.subtotal,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    double? _asDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    int? _asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return InvoiceItemModel(
      id: _asInt(json['id']),
      itemId: _asInt(json['item_id']),
      itemName: json['item_name'] ?? json['subject'],
      description: json['description'],
      quantity: _asDouble(json['quantity'] ?? json['qty']),
      rate: _asDouble(json['rate'] ?? json['price']),
      taxId: _asInt(json['tax_id']),
      subtotal: _asDouble(json['subtotal'] ?? json['total']),
    );
  }

  InvoiceItem toDomain() {
    return InvoiceItem(
      id: id,
      itemId: itemId,
      itemName: itemName,
      description: description,
      quantity: quantity,
      rate: rate,
      taxId: taxId,
      subtotal: subtotal,
    );
  }
}
