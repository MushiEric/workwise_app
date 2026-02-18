import 'package:equatable/equatable.dart';

class JobcardDetail extends Equatable {
  final int? id;
  final String? jobcardNumber;
  final String? status;
  final String? service;
  final String? reportedDate; // reported / started
  final String? dispatchedDate; // completed / dispatched
  final String? grandTotal;
  final List<Map<String, dynamic>>? items;
  final List<Map<String, dynamic>>? logs;
  final Map<String, dynamic>? statusRow;

  // additional metadata parsed from backend
  final String? relatedTo;
  final String? receiver; // id or short value from API
  final String? receiverName;
  final String? technicianId; // raw technician_id field (may be stringified list)
  final String? notes; // recommendation / notes

  const JobcardDetail({
    this.id,
    this.jobcardNumber,
    this.status,
    this.service,
    this.reportedDate,
    this.dispatchedDate,
    this.grandTotal,
    this.items,
    this.logs,
    this.statusRow,
    this.relatedTo,
    this.receiver,
    this.receiverName,
    this.technicianId,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        jobcardNumber,
        status,
        service,
        reportedDate,
        dispatchedDate,
        grandTotal,
        items,
        logs,
        statusRow,
        relatedTo,
        receiver,
        receiverName,
        technicianId,
        notes,
      ];
}
