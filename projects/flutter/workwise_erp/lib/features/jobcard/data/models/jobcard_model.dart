import '../../domain/entities/jobcard.dart';

class JobcardModel extends Jobcard {
  const JobcardModel({
    super.id,
    super.jobcardNumber,
    super.status,
    super.service,
    super.reportedDate,
    super.grandTotal,
    super.itemsCount,
    super.statusRow,
    super.technicianId,
    super.createdAt,
    super.relatedTo,
    super.receiver,
    super.receiverName,
    super.location,
    super.departments,
    super.approvalStatus,
    super.approvalId,
    super.roleUserId,
  });

  factory JobcardModel.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse('$v');
    }

    String? str(dynamic v) => v?.toString();

    final items = json['items'];
    int itemsCount = 0;
    if (items is List) itemsCount = items.length;

    Map<String, dynamic>? statusRow;
    if (json['status_row'] is Map) {
      statusRow = Map<String, dynamic>.from(json['status_row'] as Map);
    }

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
        final currentId = toInt(approval['id']) ?? 0;
        final latestId = toInt(latestApproval['id']) ?? 0;
        if (currentId > latestId) {
          latestApproval = approval;
        }
      }

      approvalStatus = toInt(latestApproval['status']);
      approvalId = toInt(latestApproval['id']);
      roleUserId = toInt(
        latestApproval['role_user_id'] ??
            latestApproval['roleUserId'] ??
            latestApproval['role_userid'],
      );
    }

    return JobcardModel(
      id: toInt(json['id']),
      jobcardNumber: str(
        json['jobcard_number'] ?? json['jobcard_no'] ?? json['jobcard'],
      ),
      status: str(json['status']),
      service: str(json['service']),
      reportedDate: str(json['reported_date'] ?? json['created_at']),
      grandTotal: str(json['grand_total'] ?? json['total']),
      itemsCount: itemsCount,
      statusRow: statusRow,
      technicianId: str(json['technician_id']),
      createdAt: str(json['created_at']),
      relatedTo: str(json['related_to']),
      receiver: str(json['receiver']),
      receiverName: str(json['receiver_name']),
      location: str(json['location']),
      departments: str(json['departments']),
      approvalStatus: approvalStatus,
      approvalId: approvalId,
      roleUserId: roleUserId,
    );
  }
}
