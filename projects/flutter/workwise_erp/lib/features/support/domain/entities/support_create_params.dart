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
  final List<String>? attachmentPaths; // single attachment expected by API but accept list
  final List<String>? files; // files[]

  SupportCreateParams({
    required this.subject,
    this.priorityId,
    this.endDate,
    this.description,
    this.assignees,
    this.serviceId,
    this.categoryId,
    this.locationId,
    this.supervisorId,
    this.attachmentPaths,
    this.files,
  });
}
