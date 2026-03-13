import '../../domain/entities/jobcard_detail.dart';

class JobcardDetailModel extends JobcardDetail {
  const JobcardDetailModel({
    super.id,
    super.jobcardNumber,
    super.status,
    super.service,
    super.reportedDate,
    super.dispatchedDate,
    super.grandTotal,
    super.items,
    super.logs,
    super.statusRow,
    super.relatedTo,
    super.receiver,
    super.receiverName,
    super.technicianId,
    super.notes,
    super.description,
    super.contact,
    super.departments,
    super.location,
    super.supervisor,
    super.approvals,
    super.userCreator,
  });

  factory JobcardDetailModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> list(dynamic v) {
      if (v is List) return v.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      return <Map<String, dynamic>>[];
    }

    Map<String, dynamic>? map(dynamic v) => v is Map ? Map<String, dynamic>.from(v) : null;

    return JobcardDetailModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] != null ? int.tryParse('${json['id']}') : null),
      jobcardNumber: json['jobcard_number']?.toString(),
      status: json['status']?.toString(),
      service: json['service']?.toString(),
      reportedDate: json['reported_date']?.toString(),
      dispatchedDate: json['dispatched_date']?.toString(),
      grandTotal: json['grand_total']?.toString(),
      items: list(json['items']),
      logs: list(json['logs']),
      statusRow: map(json['status_row']),
      relatedTo: json['related_to']?.toString(),
      receiver: json['receiver']?.toString(),
      receiverName: json['receiver_name']?.toString(),
      technicianId: json['technician_id']?.toString(),
      notes: json['notes']?.toString(),
      description: json['description']?.toString(),
      contact: json['contact']?.toString(),
      departments: json['departments']?.toString(),
      location: json['location']?.toString(),
      supervisor: json['supervisor']?.toString(),
      approvals: list(json['approvals']),
      userCreator: map(json['user_creator']),
    );
  }
}
