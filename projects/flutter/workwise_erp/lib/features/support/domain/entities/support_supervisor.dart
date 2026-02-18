import 'package:equatable/equatable.dart';

import 'assigned_user.dart';

class SupportSupervisor extends Equatable {
  final int? id;
  final String? entryNumber;
  final int? userId;
  final String? relatedTo;
  final String? supervisorCustomer;
  final String? customersAll;
  final String? locationAll;
  final String? departmentAll;
  final String? branchesAll;
  final String? servicesAll;
  final int? createdBy;
  final int? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final int? archive;
  final AssignedUser? user;

  const SupportSupervisor({
    this.id,
    this.entryNumber,
    this.userId,
    this.relatedTo,
    this.supervisorCustomer,
    this.customersAll,
    this.locationAll,
    this.departmentAll,
    this.branchesAll,
    this.servicesAll,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.archive,
    this.user,
  });

  @override
  List<Object?> get props => [
        id,
        entryNumber,
        userId,
        relatedTo,
        supervisorCustomer,
        customersAll,
        locationAll,
        departmentAll,
        branchesAll,
        servicesAll,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        archive,
        user,
      ];
}
