import 'package:equatable/equatable.dart';

class Jobcard extends Equatable {
  final int? id;
  final String? jobcardNumber;
  final String? status;
  final String? service;
  final String? reportedDate;
  final String? grandTotal;
  final int? itemsCount;
  final Map<String, dynamic>? statusRow;

  const Jobcard({
    this.id,
    this.jobcardNumber,
    this.status,
    this.service,
    this.reportedDate,
    this.grandTotal,
    this.itemsCount,
    this.statusRow,
  });

  @override
  List<Object?> get props => [id, jobcardNumber, status, service, reportedDate, grandTotal, itemsCount, statusRow];
}
