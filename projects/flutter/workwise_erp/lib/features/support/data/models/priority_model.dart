import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/priority.dart';

part 'priority_model.freezed.dart';
part 'priority_model.g.dart';

@freezed
class PriorityModel with _$PriorityModel {
  const factory PriorityModel({
    int? id,
    String? priority,
    String? color,
  }) = _PriorityModel;

  factory PriorityModel.fromJson(Map<String, dynamic> json) => _$PriorityModelFromJson(json);
}

extension PriorityModelX on PriorityModel {
  Priority toDomain() => Priority(id: id, priority: priority, color: color);
}
