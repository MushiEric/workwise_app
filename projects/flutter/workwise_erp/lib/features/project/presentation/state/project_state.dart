import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/project.dart';

part 'project_state.freezed.dart';

@freezed
class ProjectState with _$ProjectState {
  const factory ProjectState.initial() = _Initial;
  const factory ProjectState.loading() = _Loading;
  const factory ProjectState.loaded(List<Project> projects) = _Loaded;
  const factory ProjectState.detail(Project project) = _Detail;
  const factory ProjectState.error(String message) = _Error;
}
