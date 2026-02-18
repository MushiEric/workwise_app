import 'package:equatable/equatable.dart';

class CustomerSummary extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;

  const CustomerSummary({this.id, this.name, this.email, this.phone});

  @override
  List<Object?> get props => [id, name, email, phone];
}
