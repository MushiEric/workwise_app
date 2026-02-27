import '../../domain/entities/project_task.dart';

class ProjectTaskModel extends ProjectTask {
  const ProjectTaskModel({super.id, super.title, super.description, super.status, super.assignee, super.progress, super.startDate, super.dueDate, super.priority});

  factory ProjectTaskModel.fromJson(Map<String, dynamic> json) {
    return ProjectTaskModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] != null ? int.tryParse('${json['id']}') : null),
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      assignee: json['assignee'] is Map ? Map<String, dynamic>.from(json['assignee'] as Map) : null,
      progress: json['progress'] is int ? json['progress'] as int : (json['progress'] != null ? int.tryParse('${json['progress']}') : null),
      startDate: json['start_date'] as String?,
      dueDate: json['due_date'] as String?,
      priority: json['priority'] is int ? json['priority'] as int : (json['priority'] != null ? int.tryParse('${json['priority']}') : null),
    );
  }
}
