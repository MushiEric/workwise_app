import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/jobcard_remote_data_source.dart';
import '../../data/repositories/jobcard_repository_impl.dart';
import '../../domain/entities/jobcard_status.dart';
import '../../domain/repositories/jobcard_repository.dart';
import '../../domain/usecases/get_jobcards.dart';
import '../../domain/usecases/get_jobcard_settings.dart';
import '../../domain/usecases/get_jobcard_config.dart';
import '../../domain/usecases/delete_jobcard.dart';
import '../../domain/usecases/create_jobcard.dart';
import '../../domain/usecases/generate_jobcard_number.dart';
import '../../domain/usecases/get_jobcard_form_data.dart';
import '../../domain/usecases/get_receivers_by_type.dart';
import '../../domain/usecases/check_approval_eligibility.dart';
import '../../domain/usecases/approve_jobcard.dart';
import '../../domain/usecases/reject_jobcard.dart';
import '../notifier/jobcard_notifier.dart';

final jobcardRemoteDataSourceProvider = Provider<JobcardRemoteDataSource>((
  ref,
) {
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

final getJobcardFormDataUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return GetJobcardFormData(repo);
});

final getReceiversByTypeUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return GetReceiversByType(repo);
});

final checkApprovalEligibilityUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return CheckApprovalEligibility(repo);
});

final approveJobcardUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return ApproveJobcard(repo);
});

final rejectJobcardUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProvider);
  return RejectJobcard(repo);
});

final jobcardNotifierProvider =
    StateNotifierProvider<JobcardNotifier, JobcardState>((ref) {
      final getJobcards = ref.watch(getJobcardsUseCaseProvider);
      return JobcardNotifier(getJobcards: getJobcards);
    });

/// Users list used in the filter drawer on the list page.
final jobcardUsersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final remote = ref.watch(jobcardRemoteDataSourceProvider);
  try {
    return await remote.getUsers();
  } catch (_) {
    return [];
  }
});

/// Customers list used in the list page for receiver name resolution.
final jobcardCustomersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final remote = ref.watch(jobcardRemoteDataSourceProvider);
  try {
    return await remote.getCustomers();
  } catch (_) {
    return [];
  }
});

/// Vehicles list used in the list page for receiver name resolution.
final jobcardVehiclesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final remote = ref.watch(jobcardRemoteDataSourceProvider);
  try {
    return await remote.getVehicles();
  } catch (_) {
    return [];
  }
});

/// Jobcard statuses list used in the filter drawer on the list page.
final jobcardStatusesProvider = FutureProvider<List<JobcardStatus>>((
  ref,
) async {
  final uc = ref.watch(getJobcardSettingsUseCaseProvider);
  final result = await uc.call();
  return result.fold((_) => <JobcardStatus>[], (r) => r);
});

/// Dashboard statistics fetched from /jobcard/getJobCardDashboardData.
/// Returns a list of { id, name, color, total } maps directly from the API.
final jobcardDashboardProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final repo = ref.watch(jobcardRepositoryProvider);
  final result = await repo.getDashboardData();
  return result.fold((_) => <Map<String, dynamic>>[], (r) => r);
});

/// Cached jobcard general configuration (enable_reminder, show_approval_reject, etc.)
final jobcardConfigProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final uc = ref.watch(getJobcardConfigUseCaseProvider);
  final result = await uc.call();
  return result.fold((_) => <String, dynamic>{}, (r) => r);
});
