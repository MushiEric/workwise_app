import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/operator_remote_data_source.dart';
import '../../data/repositories/operator_repository_impl.dart';
import '../../domain/repositories/operator_repository.dart';
import '../../domain/usecases/get_operators.dart';
import '../notifier/operators_notifier.dart';
import '../state/operators_state.dart';

final operatorRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return OperatorRemoteDataSource(dio);
});

final operatorRepositoryProvider = Provider<OperatorRepository>((ref) {
  final remote = ref.watch(operatorRemoteDataSourceProvider);
  return OperatorRepositoryImpl(remote);
});

final getOperatorsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(operatorRepositoryProvider);
  return GetOperators(repo);
});

final operatorsNotifierProvider = StateNotifierProvider<OperatorsNotifier, OperatorsState>((ref) {
  final getOperators = ref.watch(getOperatorsUseCaseProvider);
  return OperatorsNotifier(getOperators: getOperators);
});
