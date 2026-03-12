class SupportCreateParams {
  final String subject;
  final int? priorityId;
  final String? endDate; // ISO string (yyyy-MM-dd or ISO8601)
  final String? description;
  final List<int>? assignees; // assignees[]
  final int? serviceId;
  final int? categoryId;
  final int? locationId;
  final int? supervisorId;
  final int? departmentId;
  final int? statusId;
  final int? customerId;
  final List<int>? contactIds; // contacts[]
  final List<String>? attachmentPaths; // single attachment expected by API but accept list
  final int? userId;
  final List<String>? files; // files[]

  SupportCreateParams({
    required this.subject,
    this.userId,
    this.priorityId,
    this.endDate,
    this.description,
    this.assignees,
    this.serviceId,
    this.categoryId,
    this.locationId,
    this.supervisorId,
    this.departmentId,
    this.statusId,
    this.customerId,
    this.contactIds,
    this.attachmentPaths,
    this.files,
  });
}
