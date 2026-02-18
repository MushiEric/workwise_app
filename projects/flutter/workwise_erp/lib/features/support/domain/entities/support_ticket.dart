import 'package:equatable/equatable.dart';

import 'priority.dart';
import 'status.dart';
import 'customer_summary.dart';
import 'assigned_user.dart';
import 'support_reply.dart';

class SupportTicket extends Equatable {
  final int? id;
  final String? subject;
  final String? ticketCode;
  final SupportStatus? status;
  final Priority? priority;
  final String? endDate;
  final String? description;
  final CustomerSummary? customer;
  final List<SupportReply>? replies;
  final List<Map<String, dynamic>>? attachments;
  final String? createdAt;
  final int? createdBy;
  final String? category;
  final List<String>? services;
  final AssignedUser? assignUser;
  final String? location;
  final String? department;
  final List<String>? supervisors;

  const SupportTicket({
    this.id,
    this.subject,
    this.ticketCode,
    this.status,
    this.priority,
    this.endDate,
    this.description,
    this.customer,
    this.replies,
    this.attachments,
    this.createdAt,
    this.createdBy,
    this.category,
    this.services,
    this.assignUser,
    this.location,
    this.department,
    this.supervisors,
  });

  @override
  List<Object?> get props => [
        id,
        subject,
        ticketCode,
        status,
        priority,
        endDate,
        description,
        customer,
        replies,
        attachments,
        createdAt,
        createdBy,
        category,
        services,
        assignUser,
        location,
        department,
        supervisors,
      ];
}
