import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';

import '../../data/datasources/pfi_remote_data_source.dart';
import '../../data/repositories/pfi_repository_impl.dart';
import '../../domain/repositories/pfi_repository.dart';
import '../../domain/usecases/get_pfis.dart';
import '../notifier/pfi_notifier.dart';
import '../state/pfi_state.dart';

final pfiRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return PfiRemoteDataSource(dio);
});

final pfiRepositoryProvider = Provider<PfiRepository>((ref) {
  final remote = ref.watch(pfiRemoteDataSourceProvider);
  return PfiRepositoryImpl(remote);
});

final getPfisUseCaseProvider = Provider((ref) {
  final repo = ref.watch(pfiRepositoryProvider);
  return GetPfis(repo);
});

final pfiNotifierProvider = StateNotifierProvider<PfiNotifier, PfiState>((ref) {
  final uc = ref.watch(getPfisUseCaseProvider);
  return PfiNotifier(getPfis: uc);
});
