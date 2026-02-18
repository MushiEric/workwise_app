import '../../domain/entities/operator.dart' as domain;

class OperatorModel {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? avatar;
  final String? licenseNumber;
  final String? status;
  final int? vehicleId;
  final String? createdAt;

  OperatorModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.avatar,
    this.licenseNumber,
    this.status,
    this.vehicleId,
    this.createdAt,
  });

  factory OperatorModel.fromJson(Map<String, dynamic> json) {
    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      if (v is Map && v.containsKey('id')) return asInt(v['id']);
      return null;
    }

    String? asString(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;
      if (v is num || v is bool) return v.toString();
      if (v is Map && v['name'] != null) return v['name'].toString();
      return v.toString();
    }

    // Resolve name: prefer single `name` fields, fall back to concatenating first/middle/last, then nested user.name
    String? resolvedName = asString(json['name'] ?? json['full_name'] ?? json['operator_name']);
    if (resolvedName == null) {
      final f = asString(json['first_name']);
      final m = asString(json['middle_name']);
      final l = asString(json['last_name']);
      final parts = [if (f != null && f.isNotEmpty) f, if (m != null && m.isNotEmpty) m, if (l != null && l.isNotEmpty) l];
      if (parts.isNotEmpty) resolvedName = parts.join(' ');
    }
    if (resolvedName == null && json['user'] is Map) {
      resolvedName = asString((json['user'] as Map)['name']);
    }

    return OperatorModel(
      id: asInt(json['id'] ?? json['operator_id']),
      name: resolvedName,
      phone: asString(json['phone'] ?? json['mobile'] ?? (json['user'] is Map ? (json['user'] as Map)['phone'] : null)),
      email: asString(json['email'] ?? (json['user'] is Map ? (json['user'] as Map)['email'] : null)),
      avatar: asString(json['avatar'] ?? json['image'] ?? (json['user'] is Map ? (json['user'] as Map)['profile'] : null)),
      licenseNumber: asString(json['license_number'] ?? json['license']),
      status: asString(json['status']),
      vehicleId: asInt(json['vehicle_id'] ?? json['assigned_vehicle_id']),
      createdAt: asString(json['created_at']),
    );
  }

  domain.Operator toDomain() => domain.Operator(
        id: id,
        name: name,
        phone: phone,
        email: email,
        avatar: avatar,
        licenseNumber: licenseNumber,
        status: status,
        vehicleId: vehicleId,
        createdAt: createdAt,
      );
}
