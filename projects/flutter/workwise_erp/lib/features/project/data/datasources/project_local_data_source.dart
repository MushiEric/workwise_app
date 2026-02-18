import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/project_model.dart';

/// Simple local cache for projects using SharedPreferences.
/// Stores a JSON payload with a timestamp so callers can respect TTL.
class ProjectLocalDataSource {
  static const _cacheKey = 'projects_cache_v1';

  /// Save list of project JSON maps with timestamp
  Future<void> cacheProjects(List<ProjectModel> projects) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = {
        'ts': DateTime.now().millisecondsSinceEpoch,
        'data': projects.map((p) => _projectToMap(p)).toList(),
      };
      await prefs.setString(_cacheKey, json.encode(payload));
    } catch (_) {
      // ignore cache failures
    }
  }

  /// Return cached projects or null when not present / expired
  Future<List<ProjectModel>?> getCachedProjects({int maxAgeSeconds = 300}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final s = prefs.getString(_cacheKey);
      if (s == null) return null;
      final m = json.decode(s) as Map<String, dynamic>;
      final ts = m['ts'] as int?;
      final data = m['data'];
      if (ts == null || data == null) return null;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > maxAgeSeconds * 1000) {
        await prefs.remove(_cacheKey);
        return null;
      }
      if (data is List) {
        return data.map((e) => ProjectModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
    } catch (_) {}
  }

  Map<String, dynamic> _projectToMap(ProjectModel p) => {
        if (p.id != null) 'id': p.id,
        if (p.name != null) 'name': p.name,
        if (p.code != null) 'code': p.code,
        if (p.description != null) 'description': p.description,
        if (p.status != null) 'status': p.status,
        if (p.progress != null) 'progress': p.progress,
        if (p.startDate != null) 'start_date': p.startDate,
        if (p.endDate != null) 'end_date': p.endDate,
        if (p.owner != null) 'owner': p.owner,
        if (p.membersCount != null) 'members_count': p.membersCount,
        if (p.tasksCount != null) 'tasks_count': p.tasksCount,
        if (p.sprintsCount != null) 'sprints_count': p.sprintsCount,
        if (p.milestonesCount != null) 'milestones_count': p.milestonesCount,
      }..removeWhere((k, v) => v == null);
}
