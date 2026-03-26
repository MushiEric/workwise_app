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
    this.notes,
    this.terms,
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
      paymentTermsId: asString(json['payment_terms_id']),
      paymentMethodId: asString(json['payment_method_id']),
      subscriptionStartDate: asString(json['subscription_start_date']),
      subscriptionDuration: asString(json['subscription_duration']),
      subscriptionEndDate: asString(json['subscription_end_date']),
      isRecurring: json['is_recurring'],
      items: (json['items'] as List?)?.map((i) => PfiItemModel.fromJson(i)).toList(),
      notes: asString(json['notes']),
      terms: asString(json['terms_and_conditions']),
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
        notes: notes,
        terms: terms,
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
    return PfiItemModel(
      id: json['id'] as int?,
      itemId: json['item_id']?.toString(),
      isCustom: json['is_custom'],
      description: json['description']?.toString(),
      qty: json['qty'],
      uomId: json['uom_id']?.toString(),
      period: json['period'],
      periodUnit: json['period_unit']?.toString(),
      rate: json['rate'],
      tax: json['tax']?.toString(),
      subtotal: json['subtotal'],
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
