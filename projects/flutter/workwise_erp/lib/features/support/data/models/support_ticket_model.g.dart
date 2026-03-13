// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupportTicketModelImpl _$$SupportTicketModelImplFromJson(
  Map<String, dynamic> json,
) => _$SupportTicketModelImpl(
  id: (json['id'] as num?)?.toInt(),
  subject: json['subject'] as String?,
  ticketCode: json['ticket_code'] as String?,
  priority: json['priority'] == null
      ? null
      : PriorityModel.fromJson(json['priority'] as Map<String, dynamic>),
  statuses: json['statuses'] == null
      ? null
      : StatusModel.fromJson(json['statuses'] as Map<String, dynamic>),
  endDate: json['end_date'] as String?,
  description: json['description'] as String?,
  customerName: json['customer_row'] == null
      ? null
      : CustomerModel.fromJson(json['customer_row'] as Map<String, dynamic>),
  replies: (json['replies'] as List<dynamic>?)
      ?.map((e) => SupportReplyModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  createdAt: json['created_at'] as String?,
  createdBy: (json['created_by'] as num?)?.toInt(),
  category: json['category'] as String?,
  services: (json['services'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  assignUser: json['assign_user'] == null
      ? null
      : AssignedUserModel.fromJson(json['assign_user'] as Map<String, dynamic>),
  location: json['location'] as String?,
  department: json['department'] as String?,
  supervisors: (json['supervisors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$SupportTicketModelImplToJson(
  _$SupportTicketModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'subject': instance.subject,
  'ticket_code': instance.ticketCode,
  'priority': instance.priority,
  'statuses': instance.statuses,
  'end_date': instance.endDate,
  'description': instance.description,
  'customer_row': instance.customerName,
  'replies': instance.replies,
  'attachments': instance.attachments,
  'created_at': instance.createdAt,
  'created_by': instance.createdBy,
  'category': instance.category,
  'services': instance.services,
  'assign_user': instance.assignUser,
  'location': instance.location,
  'department': instance.department,
  'supervisors': instance.supervisors,
};
