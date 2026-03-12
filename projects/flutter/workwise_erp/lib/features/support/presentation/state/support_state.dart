import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/support_ticket.dart';

part 'support_state.freezed.dart';

@freezed
class SupportState with _$SupportState {
  const factory SupportState.initial() = _Initial;
  const factory SupportState.loading() = _Loading;
  const factory SupportState.loaded({
    required List<SupportTicket> tickets,
    required int page,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _Loaded;
  const factory SupportState.error(String message) = _Error;
}
