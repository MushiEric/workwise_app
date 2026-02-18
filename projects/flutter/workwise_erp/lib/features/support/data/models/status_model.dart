import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/status.dart';

part 'status_model.freezed.dart';
part 'status_model.g.dart';

@freezed
class StatusModel with _$StatusModel {
  const factory StatusModel({
    int? id,
    String? status,
    String? color,
  }) = _StatusModel;

  factory StatusModel.fromJson(Map<String, dynamic> json) => _$StatusModelFromJson(json);
}

extension StatusModelX on StatusModel {
  SupportStatus toDomain() => SupportStatus(id: id, status: status, color: color);
}
