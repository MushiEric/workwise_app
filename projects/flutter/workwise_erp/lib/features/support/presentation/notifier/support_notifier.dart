import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_support_tickets.dart';
import '../state/support_state.dart';

class SupportNotifier extends StateNotifier<SupportState> {
  final GetSupportTickets getSupportTickets;
  SupportNotifier({required this.getSupportTickets}) : super(const SupportState.initial());

  Future<void> loadTickets({int limit = 20}) async {
    state = const SupportState.loading();
    final res = await getSupportTickets.call(page: 1, limit: limit);
    res.fold(
      (failure) => state = SupportState.error(failure.message),
      (list) => state = SupportState.loaded(
        tickets: list,
        page: 1,
        hasMore: list.length >= limit,
      ),
    );
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
