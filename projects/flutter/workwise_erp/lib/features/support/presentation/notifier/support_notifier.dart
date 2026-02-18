import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_support_tickets.dart';
import '../state/support_state.dart';

class SupportNotifier extends StateNotifier<SupportState> {
  final GetSupportTickets getSupportTickets;
  SupportNotifier({required this.getSupportTickets}) : super(const SupportState.initial());

  Future<void> loadTickets() async {
    state = const SupportState.loading();
    final res = await getSupportTickets.call();
    res.fold(
      (failure) => state = SupportState.error(failure.message),
      (list) => state = SupportState.loaded(list),
    );
  }
}
