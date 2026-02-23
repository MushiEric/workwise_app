import '../../domain/entities/customer_contact.dart' as domain;

class CustomerContactModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profile;
  final int? clientId;
  final String? lastLoginAt;
  final int? isActive;
  final int? pfiView;
  final int? pfiApprove;
  final int? jobcardView;
  final int? jobcardApprove;

  CustomerContactModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profile,
    this.clientId,
    this.lastLoginAt,
    this.isActive,
    this.pfiView,
    this.pfiApprove,
    this.jobcardView,
    this.jobcardApprove,
  });

  factory CustomerContactModel.fromJson(Map<String, dynamic> json) {
    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is bool) return v ? 1 : 0;
      if (v is String) return int.tryParse(v);
      return null;
    }

    String? asString(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    }

    return CustomerContactModel(
      id: asInt(json['id']),
      name: asString(json['name']),
      email: asString(json['email']),
      phone: asString(json['phone']),
      profile: asString(json['profile']),
      clientId: asInt(json['client_id']),
      lastLoginAt: asString(json['last_login_at']),
      isActive: asInt(json['is_active']),
      pfiView: asInt(json['pfi_view']),
      pfiApprove: asInt(json['pfi_approve']),
      jobcardView: asInt(json['jobcard_view']),
      jobcardApprove: asInt(json['jobcard_approve']),
    );
  }

  domain.CustomerContact toDomain() => domain.CustomerContact(
        id: id,
        name: name,
        email: email,
        phone: phone,
        profile: profile,
        clientId: clientId,
        lastLoginAt: lastLoginAt,
        isActive: isActive,
        pfiView: pfiView,
        pfiApprove: pfiApprove,
        jobcardView: jobcardView,
        jobcardApprove: jobcardApprove,
      );
}
