import '../../domain/entities/notification.dart' as domain;

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String? createdAt;
  final int isOpened;
  final int isClicked;
  final String? redirectLink;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.createdAt,
    required this.isOpened,
    required this.isClicked,
    this.redirectLink,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    String asString(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      return v.toString();
    }

    return NotificationModel(
      id: asInt(json['id'] ?? json['notification_id']),
      title: asString(json['title'] ?? ''),
      message: asString(json['message'] ?? ''),
      createdAt: asString(json['created_at'] ?? json['date']),
      isOpened: asInt(json['is_opened']),
      isClicked: asInt(json['is_clicked']),
      redirectLink: json['redirect_link'] == null ? null : asString(json['redirect_link']),
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
      );

  /// Simple helper to convert HTML <br> tags to plain text for display.
  String plainMessage() {
    var s = message.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'<[^>]*>'), '');
    return s;
  }
}
