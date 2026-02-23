import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int? id;
  final String? customerNumber;
  final String? name;
  final String? shortName;
  final String? email;
  final String? phone;
  final String? taxNumber; // TIN
  final String? vrn;
  final String? balance;
  final String? currencyCode;
  final String? currencySymbol;
  final int? isActive;
  final String? avatar;
  final String? createdAt;
  final String? updatedAt;

  const Customer({
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

  @override
  List<Object?> get props => [
        id,
        customerNumber,
        name,
        shortName,
        email,
        phone,
        taxNumber,
        vrn,
        balance,
        currencyCode,
        currencySymbol,
        isActive,
        avatar,
        createdAt,
        updatedAt,
      ];
}
