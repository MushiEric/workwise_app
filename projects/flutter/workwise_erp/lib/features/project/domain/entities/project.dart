import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final String? description;
  final String? status;
  final int? progress; // 0-100
  final String? startDate;
  final String? endDate;
  final Map<String, dynamic>? owner; // {id, name, avatar}
  final int? membersCount;
  final int? tasksCount;
  final int? sprintsCount;
  final int? milestonesCount;

  const Project({
    this.id,
    this.name,
    this.code,
    this.description,
    this.status,
    this.progress,
    this.startDate,
    this.endDate,
    this.owner,
    this.membersCount,
    this.tasksCount,
    this.sprintsCount,
    this.milestonesCount,
  });

  @override
  List<Object?> get props => [id, name, code, status, progress];
}
