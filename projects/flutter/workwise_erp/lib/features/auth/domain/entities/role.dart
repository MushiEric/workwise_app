import 'package:equatable/equatable.dart';

import 'permission.dart';

class Role extends Equatable {
  final int? id;
  final String? name;
  final List<Permission>? permissions;

  const Role({this.id, this.name, this.permissions});

  @override
  List<Object?> get props => [id, name, permissions];
}
