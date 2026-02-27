import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({super.id, super.name, super.code, super.description, super.status, super.progress, super.startDate, super.endDate, super.owner, super.membersCount, super.tasksCount, super.sprintsCount, super.milestonesCount});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // helper to coerce different field names / shapes into a String
    String? extractString(List<String> keys) {
      for (final k in keys) {
        if (!json.containsKey(k)) continue;
        final v = json[k];
        if (v == null) continue;
        if (v is String) return v;
        if (v is num || v is bool) return v.toString();
        if (v is Map) {
          if (v.containsKey('name') && v['name'] is String) return v['name'] as String;
          if (v.containsKey('title') && v['title'] is String) return v['title'] as String;
        }
      }
      return null;
    }

    return ProjectModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] != null ? int.tryParse('${json['id']}') : null),
      name: extractString(['name', 'title', 'project_name', 'project_title']),
      code: extractString(['code', 'project_code', 'project_code_value']) ?? (json['code'] as String?),
      description: extractString(['description', 'details', 'short_description']) ?? (json['description'] as String?),
      status: json['status'] as String?,
      progress: json['progress'] is int ? json['progress'] as int : (json['progress'] != null ? int.tryParse('${json['progress']}') : null),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      owner: json['owner'] is Map ? Map<String, dynamic>.from(json['owner'] as Map) : null,
      membersCount: json['members_count'] is int ? json['members_count'] as int : (json['members_count'] != null ? int.tryParse('${json['members_count']}') : null),
      tasksCount: json['tasks_count'] is int ? json['tasks_count'] as int : (json['tasks_count'] != null ? int.tryParse('${json['tasks_count']}') : null),
      sprintsCount: json['sprints_count'] is int ? json['sprints_count'] as int : (json['sprints_count'] != null ? int.tryParse('${json['sprints_count']}') : null),
      milestonesCount: json['milestones_count'] is int ? json['milestones_count'] as int : (json['milestones_count'] != null ? int.tryParse('${json['milestones_count']}') : null),
    );
  }
}
