import '../../domain/entities/pfi.dart';

class PfiState {
  final bool isLoading;
  final String? error;
  final List<Pfi> pfis;

  PfiState({required this.isLoading, required this.pfis, this.error});

  factory PfiState.initial() => PfiState(isLoading: false, pfis: []);
  factory PfiState.loading(List<Pfi> prev) => PfiState(isLoading: true, pfis: prev);
  factory PfiState.loaded(List<Pfi> list) => PfiState(isLoading: false, pfis: list);
  factory PfiState.errorState(String message, List<Pfi> prev) => PfiState(isLoading: false, pfis: prev, error: message);
}
