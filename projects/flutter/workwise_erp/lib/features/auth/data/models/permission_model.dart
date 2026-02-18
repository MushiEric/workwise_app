import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/permission.dart';

part 'permission_model.freezed.dart';
part 'permission_model.g.dart';

@freezed
class PermissionModel with _$PermissionModel {
  const factory PermissionModel({
    int? id,
    String? name,
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) => _$PermissionModelFromJson(json);
}

extension PermissionModelX on PermissionModel {
  Permission toDomain() => Permission(id: id, name: name);
}
