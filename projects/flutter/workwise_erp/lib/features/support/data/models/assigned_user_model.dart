import '../../domain/entities/assigned_user.dart';

class AssignedUserModel {
  final int? id;
  final String? name;
  final String? type;

  AssignedUserModel({this.id, this.name, this.type});

  factory AssignedUserModel.fromJson(Map<String, dynamic> json) {
    return AssignedUserModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] is String ? int.tryParse(json['id']) : null),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (type != null) 'type': type,
      };

  AssignedUser toDomain() => AssignedUser(id: id, name: name, type: type);
}
