import '../../domain/entities/jobcard.dart';

class JobcardModel extends Jobcard {
  const JobcardModel({
    int? id,
    String? jobcardNumber,
    String? status,
    String? service,
    String? reportedDate,
    String? grandTotal,
    int? itemsCount,
    Map<String, dynamic>? statusRow,
    String? technicianId,
    String? createdAt,
    String? relatedTo,
    String? receiver,
    String? receiverName,
    String? location,
    String? departments,
    int? approvalStatus,
    int? approvalId,
    int? roleUserId,
  }) : super(
         id: id,
         jobcardNumber: jobcardNumber,
         status: status,
         service: service,
         reportedDate: reportedDate,
         grandTotal: grandTotal,
         itemsCount: itemsCount,
         statusRow: statusRow,
         technicianId: technicianId,
         createdAt: createdAt,
         relatedTo: relatedTo,
         receiver: receiver,
         receiverName: receiverName,
         location: location,
         departments: departments,
         approvalStatus: approvalStatus,
         approvalId: approvalId,
         roleUserId: roleUserId,
       );

  factory JobcardModel.fromJson(Map<String, dynamic> json) {
    int? _int(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse('$v');
    }

    String? _str(dynamic v) => v == null ? null : v.toString();

    final items = json['items'];
    int itemsCount = 0;
    if (items is List) itemsCount = items.length;

    Map<String, dynamic>? statusRow;
    if (json['status_row'] is Map)
      statusRow = Map<String, dynamic>.from(json['status_row'] as Map);

    List<Map<String, dynamic>> approvals = [];
    if (json['approvals'] is List) {
      approvals = (json['approvals'] as List)
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    int? approvalStatus;
    int? approvalId;
    int? roleUserId;

    // If the API returns multiple approval records, pick the most recent one.
    // Some backends return the oldest record first, so using the first entry may
    // incorrectly show "pending" even after approval/rejection.
    if (approvals.isNotEmpty) {
      // Prefer the approval record with the highest numeric ID (newest).
      var latestApproval = approvals.first;
      for (final approval in approvals) {
        final currentId = _int(approval['id']) ?? 0;
        final latestId = _int(latestApproval['id']) ?? 0;
        if (currentId > latestId) {
          latestApproval = approval;
        }
      }

      approvalStatus = _int(latestApproval['status']);
      approvalId = _int(latestApproval['id']);
      roleUserId = _int(
        latestApproval['role_user_id'] ??
            latestApproval['roleUserId'] ??
            latestApproval['role_userid'],
      );
    }

    return JobcardModel(
      id: _int(json['id']),
      jobcardNumber: _str(
        json['jobcard_number'] ?? json['jobcard_no'] ?? json['jobcard'],
      ),
      status: _str(json['status']),
      service: _str(json['service']),
      reportedDate: _str(json['reported_date'] ?? json['created_at']),
      grandTotal: _str(json['grand_total'] ?? json['total']),
      itemsCount: itemsCount,
      statusRow: statusRow,
      technicianId: _str(json['technician_id']),
      createdAt: _str(json['created_at']),
      relatedTo: _str(json['related_to']),
      receiver: _str(json['receiver']),
      receiverName: _str(json['receiver_name']),
      location: _str(json['location']),
      departments: _str(json['departments']),
      approvalStatus: approvalStatus,
      approvalId: approvalId,
      roleUserId: roleUserId,
    );
  }
}
