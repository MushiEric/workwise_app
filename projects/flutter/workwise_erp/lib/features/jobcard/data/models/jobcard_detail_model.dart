import '../../domain/entities/jobcard_detail.dart';

class JobcardDetailModel extends JobcardDetail {
  const JobcardDetailModel({
    int? id,
    String? jobcardNumber,
    String? status,
    String? service,
    String? reportedDate,
    String? dispatchedDate,
    String? grandTotal,
    List<Map<String, dynamic>>? items,
    List<Map<String, dynamic>>? logs,
    Map<String, dynamic>? statusRow,
    String? relatedTo,
    String? receiver,
    String? receiverName,
    String? technicianId,
    String? notes,
  }) : super(
          id: id,
          jobcardNumber: jobcardNumber,
          status: status,
          service: service,
          reportedDate: reportedDate,
          dispatchedDate: dispatchedDate,
          grandTotal: grandTotal,
          items: items,
          logs: logs,
          statusRow: statusRow,
          relatedTo: relatedTo,
          receiver: receiver,
          receiverName: receiverName,
          technicianId: technicianId,
          notes: notes,
        );

  factory JobcardDetailModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> _list(dynamic v) {
      if (v is List) return v.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      return <Map<String, dynamic>>[];
    }

    Map<String, dynamic>? _map(dynamic v) => v is Map ? Map<String, dynamic>.from(v) : null;

    return JobcardDetailModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] != null ? int.tryParse('${json['id']}') : null),
      jobcardNumber: json['jobcard_number']?.toString(),
      status: json['status']?.toString(),
      service: json['service']?.toString(),
      reportedDate: json['reported_date']?.toString(),
      dispatchedDate: json['dispatched_date']?.toString(),
      grandTotal: json['grand_total']?.toString(),
      items: _list(json['items']),
      logs: _list(json['logs']),
      statusRow: _map(json['status_row']),
      relatedTo: json['related_to']?.toString(),
      receiver: json['receiver']?.toString(),
      receiverName: json['receiver_name']?.toString(),
      technicianId: json['technician_id']?.toString(),
      notes: json['notes']?.toString(),
    );
  }
}
