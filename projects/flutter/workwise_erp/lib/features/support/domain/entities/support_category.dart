import 'package:equatable/equatable.dart';

class SupportCategory extends Equatable {
  final int? id;
  final String? name;
  final int? isDefault;
  final int? createdBy;
  final int? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final int? archive;

  const SupportCategory({
    this.id,
    this.name,
    this.isDefault,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.archive,
  });

  @override
  List<Object?> get props => [id, name, isDefault, createdBy, updatedBy, createdAt, updatedAt, archive];
}
