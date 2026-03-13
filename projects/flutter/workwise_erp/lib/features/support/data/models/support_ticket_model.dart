import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/support_ticket.dart';
import 'priority_model.dart';
import 'status_model.dart';
import 'customer_model.dart';
import 'assigned_user_model.dart';
import 'support_reply_model.dart';

part 'support_ticket_model.freezed.dart';
part 'support_ticket_model.g.dart';

@freezed
class SupportTicketModel with _$SupportTicketModel {
  const factory SupportTicketModel({
    int? id,
    String? subject,
    @JsonKey(name: 'ticket_code') String? ticketCode,
    PriorityModel? priority,
    StatusModel? statuses,
    @JsonKey(name: 'end_date') String? endDate,
    String? description,
    @JsonKey(name: 'customer_row') CustomerModel? customerName,
    List<SupportReplyModel>? replies,
    List<Map<String, dynamic>>? attachments,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') int? createdBy,
    String? category,
    List<String>? services,
    @JsonKey(name: 'assign_user') AssignedUserModel? assignUser,
    String? location,
    String? department,
    List<String>? supervisors,
  }) = _SupportTicketModel;

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) => _$SupportTicketModelFromJson(json);
}

extension SupportTicketModelX on SupportTicketModel {
  SupportTicket toDomain() => SupportTicket(
        id: id,
        subject: subject,
        ticketCode: ticketCode,
        priority: priority?.toDomain(),
        status: statuses?.toDomain(),
        endDate: endDate,
        description: description,
        customer: customerName?.toDomain(),
        replies: replies?.map((r) => r.toDomain()).toList(),
        attachments: attachments,
        createdAt: createdAt,
        createdBy: createdBy,
        category: category,
        services: services,
        assignUser: assignUser?.toDomain(),
        location: location,
        department: department,
        supervisors: supervisors,
      );
}
