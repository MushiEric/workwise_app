import 'package:equatable/equatable.dart';

class SupportDepartment extends Equatable {
  final int? id;
  final String? customerId;
  final String? clientId;
  final String? name;
  final int? updatedBy;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final int? archive;

  const SupportDepartment({
    this.id,
    this.customerId,
    this.clientId,
    this.name,
    this.updatedBy,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.archive,
  });

  @override
  List<Object?> get props => [id, customerId, clientId, name, updatedBy, createdBy, createdAt, updatedAt, archive];
}
