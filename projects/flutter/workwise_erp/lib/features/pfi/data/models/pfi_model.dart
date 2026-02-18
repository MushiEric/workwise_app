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
      proposalNumber: asString(json['proposal_number']),
      subject: asString(json['subject']),
      customerId: asInt(json['customer_id']),
      requestId: asString(json['request_id']),
      currency: asInt(json['currency']),
      currencyExchangeRate: asString(json['currency_exchange_rate']),
      status: asInt(json['status']),
      createdAt: asString(json['created_at'] ?? json['date']),
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
      );
}
