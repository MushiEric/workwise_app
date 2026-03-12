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

  User copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    String? avatar,
    String? lang,
    String? mode,
    bool? isAdmin,
    bool? isActive,
    String? messengerColor,
    bool? darkMode,
    bool? isEmailVerified,
    String? phone,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? apiToken,
    List<Role>? roles,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      avatar: avatar ?? this.avatar,
      lang: lang ?? this.lang,
      mode: mode ?? this.mode,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
      messengerColor: messengerColor ?? this.messengerColor,
      darkMode: darkMode ?? this.darkMode,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phone: phone ?? this.phone,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      apiToken: apiToken ?? this.apiToken,
      roles: roles ?? this.roles,
    );
  }
}
