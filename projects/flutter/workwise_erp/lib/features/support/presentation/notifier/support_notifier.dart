import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_support_tickets.dart';
import '../state/support_state.dart';
import 'package:workwise_erp/core/errors/failure.dart';

class SupportNotifier extends StateNotifier<SupportState> {
  final GetSupportTickets getSupportTickets;
  SupportNotifier({required this.getSupportTickets})
    : super(const SupportState.initial());

  Future<void> loadTickets({int limit = 20}) async {
    state = const SupportState.loading();
    final res = await getSupportTickets.call(page: 1, limit: limit);
    res.fold(
      (failure) =>
          state = SupportState.error(_friendlyMessageForFailure(failure)),
      (list) => state = SupportState.loaded(
        tickets: list,
        page: 1,
        hasMore: list.length >= limit,
      ),
    );
  }

  String _friendlyMessageForFailure(Failure failure) {
    // When in release builds, avoid showing raw server/technical errors to users.
    // Keep the raw message in dev mode to help debugging.
    if (!kReleaseMode) return failure.message;

    if (failure is ServerFailure) {
      final msg = failure.message;
      if (msg.toLowerCase().contains('permission')) {
        return 'You do not have permission to view support tickets. Please contact your administrator.';
      }
      if (msg.isNotEmpty && msg.toLowerCase() != 'server failure') {
        return msg;
      }
      return 'Unable to load support tickets. Please try again later.';
    }

    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (failure is TimeoutFailure) {
      return 'Request timed out. Please try again.';
    }

    return 'Something went wrong. Please try again.';
  }

  Future<void> loadMoreTickets({int limit = 20}) async {
    state.maybeWhen(
      loaded: (tickets, page, hasMore, isLoadingMore) async {
        if (!hasMore || isLoadingMore) return;

        state = state.maybeMap(
          loaded: (s) => s.copyWith(isLoadingMore: true),
          orElse: () => state,
        );

        final nextPage = page + 1;
        final res = await getSupportTickets.call(page: nextPage, limit: limit);

        res.fold(
          (failure) => state = state.maybeMap(
            loaded: (s) => s.copyWith(isLoadingMore: false),
            orElse: () => state,
          ),
          (newList) {
            state = SupportState.loaded(
              tickets: [...tickets, ...newList],
              page: nextPage,
              hasMore: newList.length >= limit,
              isLoadingMore: false,
            );
          },
        );
      },
      orElse: () {},
    );
  }
}
