import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final int id;
  final String title;
  final String message; // raw HTML from server
  final DateTime createdAt;
  final bool isOpened;
  final bool isClicked;
  final String? redirectLink;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isOpened,
    required this.isClicked,
    this.redirectLink,
  });

  @override
  List<Object?> get props => [id, title, message, createdAt, isOpened, isClicked, redirectLink];
}
