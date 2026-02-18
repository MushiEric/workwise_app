import 'package:equatable/equatable.dart';

class SupportReply extends Equatable {
  final int? id;
  final String? message;
  final int? createdBy;
  final DateTime? createdAt;

  const SupportReply({this.id, this.message, this.createdBy, this.createdAt});

  @override
  List<Object?> get props => [id, message, createdBy, createdAt];
}
