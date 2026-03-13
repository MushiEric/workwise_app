import 'package:equatable/equatable.dart';

class SupportReply extends Equatable {
  final int? id;
  final String? message;
  final int? user;
  final int? createdBy;
  final int? isRead;
  final String? name;
  final DateTime? createdAt;

  const SupportReply({
    this.id,
    this.message,
    this.user,
    this.createdBy,
    this.isRead,
    this.name,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, message, user, createdBy, isRead, name, createdAt];
}
