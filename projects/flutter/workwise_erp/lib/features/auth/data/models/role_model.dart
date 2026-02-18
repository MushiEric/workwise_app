import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/role.dart';
import 'permission_model.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

@freezed
class RoleModel with _$RoleModel {
  const factory RoleModel({
    int? id,
    String? name,
    List<PermissionModel>? permissions,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);
}

extension RoleModelX on RoleModel {
  Role toDomain() => Role(
        id: id,
        name: name,
        permissions: permissions?.map((p) => p.toDomain()).toList(),
      );
}
