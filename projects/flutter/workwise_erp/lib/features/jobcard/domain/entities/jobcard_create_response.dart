class JobcardCreateResponse {
  /// The newly created jobcard ID, if available.
  final int? id;

  /// A human-readable message returned by the backend.
  final String? message;

  /// Whether the backend reported success.
  final bool success;

  const JobcardCreateResponse({this.id, this.message, this.success = false});
}
