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
  final String? description; // summary of tasks / description
  final String? contact; // contact number / info
  final String? departments; // raw departments field (stringified JSON array)
  final String? location; // location id or name
  final String? supervisor; // supervisor id
  final List<Map<String, dynamic>>? approvals;
  final Map<String, dynamic>? userCreator; // full user object of creator

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
    this.description,
    this.contact,
    this.departments,
    this.location,
    this.supervisor,
    this.approvals,
    this.userCreator,
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
        description,
        contact,
        departments,
        location,
        supervisor,
        approvals,
        userCreator,
      ];
}
