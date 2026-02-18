import 'package:equatable/equatable.dart';
import 'role.dart';

/// Domain entity for User. Implements Equatable per your request.
class User extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? avatar;
  final String? lang;
  final String? mode;
  final bool? isAdmin;
  final bool? isActive;
  final String? messengerColor;
  final bool? darkMode;
  final bool? isEmailVerified;
  final String? phone;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? apiToken;
  final List<Role>? roles;

  const User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.avatar,
    this.lang,
    this.mode,
    this.isAdmin,
    this.isActive,
    this.messengerColor,
    this.darkMode,
    this.isEmailVerified,
    this.phone,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.apiToken,
    this.roles,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        emailVerifiedAt,
        avatar,
        lang,
        mode,
        isAdmin,
        isActive,
        messengerColor,
        darkMode,
        isEmailVerified,
        phone,
        lastLoginAt,
        createdAt,
        updatedAt,
        apiToken,
        roles,
      ];
}
