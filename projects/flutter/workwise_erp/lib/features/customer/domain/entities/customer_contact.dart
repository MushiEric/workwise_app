import 'package:equatable/equatable.dart';

class CustomerContact extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profile; // avatar URL
  final int? clientId;   // links to Customer.id
  final String? customerName; // enriched at notifier level
  final String? lastLoginAt;
  final int? isActive;
  // permission flags (1 = YES, 0 = NO, null = unknown)
  final int? pfiView;
  final int? pfiApprove;
  final int? jobcardView;
  final int? jobcardApprove;

  const CustomerContact({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profile,
    this.clientId,
    this.customerName,
    this.lastLoginAt,
    this.isActive,
    this.pfiView,
    this.pfiApprove,
    this.jobcardView,
    this.jobcardApprove,
  });

  CustomerContact copyWith({String? customerName}) => CustomerContact(
        id: id,
        name: name,
        email: email,
        phone: phone,
        profile: profile,
        clientId: clientId,
        customerName: customerName ?? this.customerName,
        lastLoginAt: lastLoginAt,
        isActive: isActive,
        pfiView: pfiView,
        pfiApprove: pfiApprove,
        jobcardView: jobcardView,
        jobcardApprove: jobcardApprove,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        profile,
        clientId,
        customerName,
        lastLoginAt,
        isActive,
        pfiView,
        pfiApprove,
        jobcardView,
        jobcardApprove,
      ];
}
