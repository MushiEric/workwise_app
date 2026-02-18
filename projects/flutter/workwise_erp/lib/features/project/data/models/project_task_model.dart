import '../../domain/entities/project_task.dart';

class ProjectTaskModel extends ProjectTask {
  const ProjectTaskModel({int? id, String? title, String? description, String? status, Map<String, dynamic>? assignee, int? progress, String? startDate, String? dueDate, int? priority}) : super(id: id, title: title, description: description, status: status, assignee: assignee, progress: progress, startDate: startDate, dueDate: dueDate, priority: priority);

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
