class JobcardCreateParams {
  final String jobcardNumber;
  final String subject;
  final String? reportedDate;
  final String? dispatchedDate;
  final int? vehicleId;
  final List<int>? technicianIds;
  final List<int>? departmentIds;
  final String? service;
  final String? description;
  final String? notes;
  final String? relatedTo;
  final int? receiverId;
  final String? receiverName;
  final int? supportId;
  final int? status;
  final int? supervisorId;
  final int? locationId;
  final int? proposalId;
  final int? separationItem; // 0/1
  final num? grandTotal;
  final List<Map<String, dynamic>>? items;
  final List<String>? itemAttachmentPaths;
  final List<String>? serviceAttachmentPaths;

  JobcardCreateParams({
    required this.jobcardNumber,
    required this.subject,
    this.reportedDate,
    this.dispatchedDate,
    this.vehicleId,
    this.technicianIds,
    this.departmentIds,
    this.service,
    this.description,
    this.notes,
    this.relatedTo,
    this.receiverId,
    this.receiverName,
    this.supportId,
    this.status,
    this.supervisorId,
    this.locationId,
    this.proposalId,
    this.separationItem,
    this.grandTotal,
    this.items,
    this.itemAttachmentPaths,
    this.serviceAttachmentPaths,
  });

  Map<String, dynamic> toMap() => {
        'jobcard_number': jobcardNumber,
        'subject': subject,
        if (reportedDate != null) 'reported_date': reportedDate,
        if (dispatchedDate != null) 'dispatched_date': dispatchedDate,
        if (vehicleId != null) 'vehicle_id': vehicleId,
        if (technicianIds != null) 'technician_id': technicianIds, // numeric array
        if (departmentIds != null) 'departments': departmentIds,
        if (service != null) 'service': service,
        if (description != null) 'description': description,
        if (notes != null) 'notes': notes,
        if (relatedTo != null) 'related_to': relatedTo,
        if (receiverId != null) 'receiver': receiverId,
        if (receiverName != null) 'receiver_name': receiverName,
        if (supportId != null) 'support_id': supportId,
        if (status != null) 'status': status,
        if (supervisorId != null) 'supervisor_id': supervisorId,
        if (locationId != null) 'location': locationId,
        if (proposalId != null) 'proposal_id': proposalId,
        if (separationItem != null) 'separation_item': separationItem,
        if (grandTotal != null) 'grand_total': grandTotal,
        if (items != null) 'items': items,
        // Attachments (local file paths) - server expects these form fields: `item_attachemt`, `service_attachemt`
        if (itemAttachmentPaths != null) 'item_attachemt': itemAttachmentPaths,
        if (serviceAttachmentPaths != null) 'service_attachemt': serviceAttachmentPaths,
      };

  Map<String, dynamic> toJson() => toMap();
}
