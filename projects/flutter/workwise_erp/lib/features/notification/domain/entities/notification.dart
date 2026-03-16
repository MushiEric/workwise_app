import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final int id;
  final String title;
  final String message; // raw HTML from server
  final DateTime createdAt;
  final bool isOpened;
  final bool isClicked;
  final String? redirectLink;

  /// Numeric database ID of the related jobcard (when the notification is
  /// about a jobcard). Populated from the backend `jobcard_id` field, or
  /// extracted from the `redirect_link` URI if present.
  final int? jobcardId;

  /// Numeric database ID of the related support ticket (when the notification
  /// is about a support / CRM ticket).
  final int? ticketId;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isOpened,
    required this.isClicked,
    this.redirectLink,
    this.jobcardId,
    this.ticketId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    createdAt,
    isOpened,
    isClicked,
    redirectLink,
    jobcardId,
    ticketId,
  ];
}
