import 'package:equatable/equatable.dart';

class ProjectTask extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? status; // e.g. todo/in-progress/done
  final Map<String, dynamic>? assignee; // {id,name,avatar}
  final int? progress; // 0-100
  final String? startDate;
  final String? dueDate;
  final int? priority;

  const ProjectTask({this.id, this.title, this.description, this.status, this.assignee, this.progress, this.startDate, this.dueDate, this.priority});

  @override
  List<Object?> get props => [id, title, status];
}
