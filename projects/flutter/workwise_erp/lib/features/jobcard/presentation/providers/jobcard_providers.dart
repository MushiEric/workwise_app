import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/jobcard_remote_data_source.dart';
import '../../data/repositories/jobcard_repository_impl.dart';
import '../../domain/repositories/jobcard_repository.dart';
import '../../domain/usecases/get_jobcards.dart';
import '../../domain/usecases/get_jobcard_settings.dart';
import '../../domain/usecases/get_jobcard_config.dart';
import '../../domain/usecases/delete_jobcard.dart';
import '../../domain/usecases/create_jobcard.dart';
import '../../domain/usecases/generate_jobcard_number.dart';
import '../notifier/jobcard_notifier.dart';

final jobcardRemoteDataSourceProvider = Provider<JobcardRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return JobcardRemoteDataSource(dio);
});

final jobcardRepositoryProvider = Provider<JobcardRepository>((ref) {
  final remote = ref.watch(jobcardRemoteDataSourceProvider);
  return JobcardRepositoryImpl(remote);
});

final getJobcardsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return GetJobcards(repo);
});

final getJobcardSettingsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return GetJobcardSettings(repo);
});

final deleteJobcardUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return DeleteJobcard(repo);
});

final getJobcardConfigUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return GetJobcardConfig(repo);
});

final createJobcardUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return CreateJobcard(repo);
});

final generateJobcardNumberUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return GenerateJobcardNumber(repo);
});

final jobcardNotifierProvider = StateNotifierProvider<JobcardNotifier, JobcardState>((ref) {
  final getJobcards = ref.watch(getJobcardsUseCaseProvider);
  return JobcardNotifier(getJobcards: getJobcards);
});
