import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/support_reply.dart';

part 'support_reply_model.freezed.dart';
part 'support_reply_model.g.dart';

@freezed
class SupportReplyModel with _$SupportReplyModel {
  const factory SupportReplyModel({
    int? id,
    String? message,
    @JsonKey(name: 'created_by') int? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _SupportReplyModel;

  factory SupportReplyModel.fromJson(Map<String, dynamic> json) => _$SupportReplyModelFromJson(json);
}

extension SupportReplyModelX on SupportReplyModel {
  SupportReply toDomain() => SupportReply(id: id, message: message, createdBy: createdBy, createdAt: createdAt);
}
