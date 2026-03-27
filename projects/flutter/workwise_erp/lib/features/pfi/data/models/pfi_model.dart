import '../../domain/entities/pfi.dart' as domain;

class PfiModel {
  final int id;
  final String? proposalNumber;
  final String? subject;
  final int? customerId;
  final String? requestId;
  final int? currency;
  final String? currencyExchangeRate;
  final int? status;
  final String? createdAt;
  final String? customerName;
  final dynamic total;
  
  // New fields from Image
  final String? issueDate;
  final String? dueDate;
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
  final String? subscriptionStartDate;
  final String? subscriptionDuration;
  final String? subscriptionEndDate;
  final dynamic isRecurring;

  // Items & Footer
  final List<PfiItemModel>? items;
  final List<PfiPaymentModel>? payments;
  final String? notes;
  final String? terms;

  PfiModel({
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

  factory PfiModel.fromJson(Map<String, dynamic> json) {
    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    String? asString(dynamic v) {
      if (v == null) return null;
      return v.toString();
    }

    String? parseHtml(dynamic v) {
      final str = asString(v);
      if (str == null) return null;
      var s = str;
      s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
      s = s.replaceAll(RegExp(r'</(p|div)>', caseSensitive: false), '\n\n');
      s = s.replaceAll(RegExp(r'</li>', caseSensitive: false), '\n');
      s = s.replaceAll(RegExp(r'<li>', caseSensitive: false), '• ');
      s = s.replaceAll(RegExp(r'&nbsp;', caseSensitive: false), ' ');
      s = s.replaceAll(RegExp(r'&amp;', caseSensitive: false), '&');
      s = s.replaceAll(RegExp(r'&lt;', caseSensitive: false), '<');
      s = s.replaceAll(RegExp(r'&gt;', caseSensitive: false), '>');
      s = s.replaceAll(RegExp(r'&quot;', caseSensitive: false), '"');
      s = s.replaceAll(RegExp(r'<[^>]*>'), '');
      s = s.replaceAll(RegExp(r'\n{3,}'), '\n\n');
      return s.trim();
    }

    return PfiModel(
      id: asInt(json['id']) ?? 0,
      proposalNumber: asString(json['proposal_number'] ?? json['form_number']),
      subject: asString(json['subject']),
      customerId: asInt(json['customer_id']),
      requestId: asString(json['request_id']),
      currency: asInt(json['currency'] ?? json['currency_id']),
      currencyExchangeRate: asString(json['currency_exchange_rate'] ?? json['exchange_rate']),
      status: asInt(json['status']),
      createdAt: asString(json['created_at'] ?? json['date']),
      issueDate: asString(json['issue_date']),
      dueDate: asString(json['due_date']),
      discountType: asString(json['discount_type']),
      showDiscountPerItem: asString(json['show_discount_per_item']),
      showTaxPerItem: asString(json['show_tax_per_item']),
      supportTicketId: asString(json['support_ticket_id']),
      jobcardId: asString(json['jobcard_id']),
      projectId: asString(json['project_id']),
      tripId: asString(json['trip_id']),
      warehouseId: asString(json['warehouse_id']),
      salesAgentId: asString(json['sales_agent_id']),
      attachmentPath: asString(json['attachment']),
      subscriptionStartDate: asString(json['subscription_start_date']),
      subscriptionDuration: asString(json['subscription_duration']),
      subscriptionEndDate: asString(json['subscription_end_date']),
      isRecurring: json['is_recurring'],
      items: (json['items'] as List?)?.map((i) => PfiItemModel.fromJson(i)).toList(),
      payments: (json['payments'] as List?)?.map((p) => PfiPaymentModel.fromJson(p)).toList(),
      notes: parseHtml(json['pfi_client_notes'] ?? json['notes']),
      terms: parseHtml(json['pfi_terms_condition'] ?? json['terms_and_conditions']),
      customerName: () {
        // 1. Direct top-level string fields
        String? name = asString(
          json['company'] ??
          json['customer_name'] ??
          json['client_name'] ??
          json['billing_name'] ??
          json['display_name'] ??
          json['contact_name'],
        );
        if (name != null && name.isNotEmpty) return name;

        // 2. Nested map — try every common key the API might use
        for (final key in ['customer', 'client', 'customer_row', 'customer_data', 'billing_info', 'contact']) {
          final v = json[key];
          if (v is Map) {
            name = asString(
              v['company'] ??
              v['name'] ??
              v['short_name'] ??
              v['display_name'] ??
              v['full_name'] ??
              v['billing_name'] ??
              v['contact_name'] ??
              v['client_name'],
            );
            if (name != null && name.isNotEmpty) return name;
          }
        }

        return null;
      }(),
      total: json['total'] ?? json['grand_total'] ?? json['amount'] ?? () {
        final items = json['items'];
        if (items is List) {
          double sum = 0;
          for (var it in items) {
             final q = double.tryParse(it['quantity']?.toString() ?? '0') ?? 0;
             final p = double.tryParse(it['price']?.toString() ?? '0') ?? 0;
             sum += (q * p);
          }
          return sum > 0 ? sum : null;
        }
        return null;
      }(),
      paymentMethodId: json['payment_method'] is Map ? json['payment_method']['name']?.toString() : asString(json['payment_method_id'] ?? json['payment_method']),
      paymentTermsId: json['payment_term'] is Map ? json['payment_term']['name']?.toString() : asString(json['payment_terms_id'] ?? json['payment_term']),
    );
  }

  domain.Pfi toDomain() => domain.Pfi(
        id: id,
        proposalNumber: proposalNumber,
        subject: subject,
        customerId: customerId,
        requestId: requestId,
        currency: currency,
        currencyExchangeRate: currencyExchangeRate,
        status: status,
        createdAt: DateTime.tryParse(createdAt ?? ''),
        issueDate: DateTime.tryParse(issueDate ?? ''),
        dueDate: DateTime.tryParse(dueDate ?? ''),
        discountType: discountType,
        showDiscountPerItem: showDiscountPerItem,
        showTaxPerItem: showTaxPerItem,
        supportTicketId: supportTicketId,
        jobcardId: jobcardId,
        projectId: projectId,
        tripId: tripId,
        warehouseId: warehouseId,
        salesAgentId: salesAgentId,
        attachmentPath: attachmentPath,
        paymentTermsId: paymentTermsId,
        paymentMethodId: paymentMethodId,
        subscriptionStartDate: DateTime.tryParse(subscriptionStartDate ?? ''),
        subscriptionDuration: subscriptionDuration,
        subscriptionEndDate: DateTime.tryParse(subscriptionEndDate ?? ''),
        isRecurring: isRecurring == 1 || isRecurring == true,
        items: items?.map((i) => i.toDomain()).toList(),
        payments: payments?.map((p) => p.toDomain()).toList(),
        notes: notes,
        terms: terms,
        customerName: customerName,
        total: double.tryParse((total ?? '0').toString().replaceAll(',', '')),
      );
}

class PfiItemModel {
  final int? id;
  final String? itemId;
  final dynamic isCustom;
  final String? description;
  final dynamic qty;
  final String? uomId;
  final dynamic period;
  final String? periodUnit;
  final dynamic rate;
  final String? tax;
  final dynamic subtotal;

  PfiItemModel({
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

  factory PfiItemModel.fromJson(Map<String, dynamic> json) {
    double? asDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v.replaceAll(',', ''));
      return null;
    }
    String? parseHtml(dynamic v) {
      if (v == null) return null;
      var s = v.toString();
      s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
      s = s.replaceAll(RegExp(r'</(p|div)>', caseSensitive: false), '\n\n');
      s = s.replaceAll(RegExp(r'</li>', caseSensitive: false), '\n');
      s = s.replaceAll(RegExp(r'<li>', caseSensitive: false), '• ');
      s = s.replaceAll(RegExp(r'&nbsp;', caseSensitive: false), ' ');
      s = s.replaceAll(RegExp(r'&amp;', caseSensitive: false), '&');
      s = s.replaceAll(RegExp(r'&lt;', caseSensitive: false), '<');
      s = s.replaceAll(RegExp(r'&gt;', caseSensitive: false), '>');
      s = s.replaceAll(RegExp(r'&quot;', caseSensitive: false), '"');
      s = s.replaceAll(RegExp(r'<[^>]*>'), '');
      s = s.replaceAll(RegExp(r'\n{3,}'), '\n\n');
      return s.trim();
    }
    
    // Helper: safely extract int from dynamic
    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return PfiItemModel(
      // id may come as int or string
      id: asInt(json['id']),
      // item label is 'item_name' in the API
      itemId: (json['item_name'] ?? json['item_id'] ?? json['product_id'])?.toString(),
      isCustom: json['is_custom'] ?? json['is_custom_item'],
      description: parseHtml(json['description']),
      // quantity arrives as int from the API
      qty: json['quantity'] ?? json['qty'],
      uomId: (json['unit_id'] ?? json['uom_id'])?.toString(),
      // period is usually empty string; period_qty holds the value
      period: json['period_qty'] ?? json['period'],
      periodUnit: json['period_unit']?.toString(),
      // base_price is the reliable price field; fall back to price/rate
      rate: json['price'] ?? json['base_price'] ?? json['rate'],
      // tax_rate holds the percentage; tax may hold the display label
      tax: (json['tax_rate'] ?? json['tax'])?.toString(),
      subtotal: json['total'] ?? json['subtotal'],
    );
  }

  domain.PfiItem toDomain() {
    double? asDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v.replaceAll(',', ''));
      return null;
    }
    return domain.PfiItem(
      id: id,
      itemId: itemId,
      isCustom: isCustom == 1 || isCustom == true,
      description: description,
      qty: asDouble(qty),
      uomId: uomId,
      period: asDouble(period),
      periodUnit: periodUnit,
      rate: asDouble(rate),
      tax: tax,
      subtotal: asDouble(subtotal),
    );
  }
}

class PfiPaymentModel {
  final int? id;
  final String? paymentReceipt;
  final String? date;
  final num? amount;
  final String? paymentType;
  final String? reference;

  PfiPaymentModel({
    this.id,
    this.paymentReceipt,
    this.date,
    this.amount,
    this.paymentType,
    this.reference,
  });

  factory PfiPaymentModel.fromJson(Map<String, dynamic> json) {
    return PfiPaymentModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      paymentReceipt: json['payment_receipt']?.toString() ?? json['receipt_no']?.toString(),
      date: json['date']?.toString() ?? json['payment_date']?.toString(),
      amount: json['amount'] is num ? json['amount'] : num.tryParse(json['amount']?.toString().replaceAll(',', '') ?? ''),
      paymentType: json['payment_type']?.toString() ?? json['method']?.toString(),
      reference: json['reference']?.toString() ?? json['ref']?.toString(),
    );
  }

  domain.PfiPayment toDomain() => domain.PfiPayment(
    id: id,
    paymentReceipt: paymentReceipt,
    date: DateTime.tryParse(date ?? ''),
    amount: amount?.toDouble(),
    paymentType: paymentType,
    reference: reference,
  );
}
