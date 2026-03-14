import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import 'package:workwise_erp/features/support/presentation/providers/support_providers.dart';
import 'package:workwise_erp/features/support/domain/entities/support_department.dart';
import '../../data/datasources/jobcard_remote_data_source.dart';
import '../../data/repositories/jobcard_repository_impl.dart';
import '../../domain/entities/jobcard_status.dart';
import '../../domain/repositories/jobcard_repository.dart';
import '../../domain/usecases/get_jobcard_by_id.dart';
import '../../domain/usecases/get_jobcard_settings.dart';
import '../notifier/jobcard_detail_notifier.dart';

final jobcardRemoteDataSourceProviderForDetail =
    Provider<JobcardRemoteDataSource>((ref) {
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

final getJobcardSettingsForDetailUseCaseProvider = Provider((ref) {
  final repo = ref.watch(jobcardRepositoryProviderForDetail);
  return GetJobcardSettings(repo);
});

/// Fetches jobcard statuses once and caches them.
final jobcardStatusesForDetailProvider = FutureProvider<List<JobcardStatus>>((
  ref,
) async {
  final useCase = ref.watch(getJobcardSettingsForDetailUseCaseProvider);
  final result = await useCase.call();
  return result.fold((_) => <JobcardStatus>[], (r) => r);
});

final jobcardDetailNotifierProvider =
    StateNotifierProvider<JobcardDetailNotifier, JobcardDetailState>((ref) {
      final getJobcard = ref.watch(getJobcardByIdUseCaseProvider);
      final repo = ref.watch(jobcardRepositoryProviderForDetail);
      return JobcardDetailNotifier(
        getJobcardById: getJobcard,
        repository: repo,
      );
    });

/// Users list used to resolve staff names and user-type receivers in the detail page.
final jobcardUsersForDetailProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
      final remote = ref.read(jobcardRemoteDataSourceProviderForDetail);
      try {
        return await remote.getUsers();
      } catch (_) {
        return [];
      }
    });

/// Receivers list for a given relatedTo type (used to resolve receiver name in detail page).
/// Pass the raw relatedTo string (e.g. "Customer", "Vehicle", "Employee", "Users").
final jobcardReceiversForDetailProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      relatedTo,
    ) async {
      final remote = ref.read(jobcardRemoteDataSourceProviderForDetail);
      final type = relatedTo.toLowerCase().trim();
      try {
        if (type == 'vehicle') {
          return await remote.getVehicles();
        } else if (type == 'users' || type == 'user' || type == 'employee') {
          return await remote.getUsers();
        } else if (type == 'customer' ||
            type == 'vendor') {
          return await remote.getReceiversByType(type);
        }
        return [];
      } catch (_) {
        return [];
      }
    });

/// Departments list used to resolve department IDs to names in the detail page.
final jobcardDepartmentsForDetailProvider =
    FutureProvider<List<SupportDepartment>>((ref) async {
      final useCase = ref.watch(getSupportDepartmentsUseCaseProvider);
      final result = await useCase.call();
      return result.fold((_) => <SupportDepartment>[], (list) => list);
    });
