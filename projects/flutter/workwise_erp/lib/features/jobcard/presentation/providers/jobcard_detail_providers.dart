import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/jobcard_remote_data_source.dart';
import '../../data/repositories/jobcard_repository_impl.dart';
import '../../domain/repositories/jobcard_repository.dart';
import '../../domain/usecases/get_jobcard_by_id.dart';
import '../notifier/jobcard_detail_notifier.dart';

final jobcardRemoteDataSourceProviderForDetail = Provider<JobcardRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return JobcardRemoteDataSource(dio);
});

final jobcardRepositoryProviderForDetail = Provider<JobcardRepository>((ref) {
  final remote = ref.watch(jobcardRemoteDataSourceProviderForDetail);
  return JobcardRepositoryImpl(remote);
});

final getJobcardByIdUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProviderForDetail);
  return GetJobcardById(repo);
});

final jobcardDetailNotifierProvider = StateNotifierProvider<JobcardDetailNotifier, JobcardDetailState>((ref) {
  final getJobcard = ref.watch(getJobcardByIdUseCaseProvider);
  return JobcardDetailNotifier(getJobcardById: getJobcard);
});