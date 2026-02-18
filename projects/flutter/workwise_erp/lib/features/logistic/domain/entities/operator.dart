import 'package:equatable/equatable.dart';

class Operator extends Equatable {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? avatar;
  final String? licenseNumber;
  final String? status;
  final int? vehicleId;
  final String? createdAt;

  const Operator({
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

  @override
  List<Object?> get props => [id, name, phone, email, avatar, licenseNumber, status, vehicleId, createdAt];
}
