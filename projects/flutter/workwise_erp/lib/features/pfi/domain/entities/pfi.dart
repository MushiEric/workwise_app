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
  });

  @override
  List<Object?> get props => [id, proposalNumber, subject, customerId, requestId, currency, currencyExchangeRate, status, createdAt];
}
