import '../../domain/entities/notification.dart' as domain;

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String? createdAt;
  final int isOpened;
  final int isClicked;
  final String? redirectLink;
  final int? jobcardId;
  final int? ticketId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.createdAt,
    required this.isOpened,
    required this.isClicked,
    this.redirectLink,
    this.jobcardId,
    this.ticketId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    int? asNullableInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v == 0 ? null : v;
      if (v is num) return v.toInt() == 0 ? null : v.toInt();
      if (v is String) {
        final i = int.tryParse(v);
        return (i == null || i == 0) ? null : i;
      }
      return null;
    }

    String asString(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      return v.toString();
    }

    final redirectLink = json['redirect_link'] == null
        ? null
        : asString(json['redirect_link']);

    // Prefer explicit backend fields, then attempt to extract from redirectLink.
    int? jobcardId = asNullableInt(
      json['jobcard_id'] ?? json['job_card_id'] ?? json['jobcardId'],
    );
    int? ticketId = asNullableInt(
      json['ticket_id'] ??
          json['support_id'] ??
          json['ticketId'] ??
          json['crm_id'],
    );

    // Fallback: extract from redirect_link URI segments / query params.
    if ((jobcardId == null || ticketId == null) &&
        redirectLink != null &&
        redirectLink.isNotEmpty) {
      final uri = Uri.tryParse(redirectLink);
      if (uri != null) {
        final path = uri.path.toLowerCase();
        final idParam = asNullableInt(uri.queryParameters['id']);
        final segments = uri.pathSegments;
        // Last numeric path segment (e.g. /jobcard/detail/42 → 42).
        final lastNumeric = segments.isNotEmpty
            ? asNullableInt(segments.last)
            : null;
        final resolvedId = idParam ?? lastNumeric;

        final isJobcard =
            path.contains('jobcard') ||
            path.contains('job_card') ||
            path.contains('job-card');

        if (isJobcard && jobcardId == null) {
          jobcardId = resolvedId;
        } else if ((path.contains('support') ||
                path.contains('ticket') ||
                path.contains('crm')) &&
            ticketId == null) {
          ticketId = resolvedId;
        }
      }
    }

    return NotificationModel(
      id: asInt(json['id'] ?? json['notification_id']),
      title: asString(json['title'] ?? ''),
      message: asString(json['message'] ?? ''),
      createdAt: asString(json['created_at'] ?? json['date']),
      isOpened: asInt(json['is_opened']),
      isClicked: asInt(json['is_clicked']),
      redirectLink: redirectLink,
      jobcardId: jobcardId,
      ticketId: ticketId,
    );
  }

  domain.AppNotification toDomain() => domain.AppNotification(
    id: id,
    title: title,
    message: message,
    createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
    isOpened: isOpened == 1,
    isClicked: isClicked == 1,
    redirectLink: redirectLink,
    jobcardId: jobcardId,
    ticketId: ticketId,
  );

  /// Simple helper to convert HTML <br> tags to plain text for display.
  String plainMessage() {
    var s = message.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '\n',
    );
    s = s.replaceAll(RegExp(r'<[^>]*>'), '');
    return s;
  }
}
