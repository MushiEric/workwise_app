import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_trips.dart';
import '../state/trips_state.dart';

class TripsNotifier extends StateNotifier<TripsState> {
  final GetTrips getTrips;
  TripsNotifier({required this.getTrips}) : super(const TripsState.initial());

  Future<void> loadTrips() async {
    state = const TripsState.loading();
    final res = await getTrips.call();
    res.fold(
      (f) => state = TripsState.error(f.message),
      (list) => state = TripsState.loaded(list),
    );
  }
}
