import 'package:equatable/equatable.dart';

class SupportService extends Equatable {
  final int? id;
  final String? name;
  final int? createdBy;
  final int? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final int? archive;

  const SupportService({
    this.id,
    this.name,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.archive,
  });

  @override
  List<Object?> get props => [id, name, createdBy, updatedBy, createdAt, updatedAt, archive];
}
