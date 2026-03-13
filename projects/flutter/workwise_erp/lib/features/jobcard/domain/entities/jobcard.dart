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
  final String? technicianId; // raw technician_id for filter
  final String? createdAt; // ISO timestamp for date filter
  final String? relatedTo;
  final String? receiver;
  final String? receiverName;
  final String? location;
  final String? departments;

  const Jobcard({
    this.id,
    this.jobcardNumber,
    this.status,
    this.service,
    this.reportedDate,
    this.grandTotal,
    this.itemsCount,
    this.statusRow,
    this.technicianId,
    this.createdAt,
    this.relatedTo,
    this.receiver,
    this.receiverName,
    this.location,
    this.departments,
  });

  @override
  List<Object?> get props => [
    id,
    jobcardNumber,
    status,
    service,
    reportedDate,
    grandTotal,
    itemsCount,
    statusRow,
    technicianId,
    createdAt,
    relatedTo,
    receiver,
    receiverName,
    location,
    departments,
  ];
}
