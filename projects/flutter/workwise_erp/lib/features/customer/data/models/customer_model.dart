import '../../domain/entities/customer.dart' as domain;

class CustomerModel {
  final int? id;
  final String? customerNumber;
  final String? name;
  final String? shortName;
  final String? email;
  final String? phone;
  final String? taxNumber;
  final String? vrn;
  final String? balance;
  final String? currencyCode;
  final String? currencySymbol;
  final int? isActive;
  final String? avatar;
  final String? createdAt;
  final String? updatedAt;

  CustomerModel({
    this.id,
    this.customerNumber,
    this.name,
    this.shortName,
    this.email,
    this.phone,
    this.taxNumber,
    this.vrn,
    this.balance,
    this.currencyCode,
    this.currencySymbol,
    this.isActive,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    String? asString(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    }

    // Extract currency from nested currency_user → currency
    String? currencyCode;
    String? currencySymbol;
    final cu = json['currency_user'];
    if (cu is Map) {
      final c = cu['currency'];
      if (c is Map) {
        currencyCode = asString(c['currency_code']);
        currencySymbol = asString(c['currency_symbol']);
      }
    }

    return CustomerModel(
      id: asInt(json['id']),
      customerNumber: asString(json['customer_number']),
      name: asString(json['name']),
      shortName: asString(json['short_name']),
      email: asString(json['email']),
      phone: asString(json['contact']),
      taxNumber: asString(json['tax_number']),
      vrn: asString(json['vrn']),
      balance: asString(json['balance']),
      currencyCode: currencyCode,
      currencySymbol: currencySymbol,
      isActive: asInt(json['is_active']),
      avatar: asString(json['avatar']),
      createdAt: asString(json['created_at']),
      updatedAt: asString(json['updated_at']),
    );
  }

  domain.Customer toDomain() => domain.Customer(
        id: id,
        customerNumber: customerNumber,
        name: name,
        shortName: shortName,
        email: email,
        phone: phone,
        taxNumber: taxNumber,
        vrn: vrn,
        balance: balance,
        currencyCode: currencyCode,
        currencySymbol: currencySymbol,
        isActive: isActive,
        avatar: avatar,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
