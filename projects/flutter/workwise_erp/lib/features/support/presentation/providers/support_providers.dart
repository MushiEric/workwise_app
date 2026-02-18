import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/support_remote_data_source.dart';
import '../../data/repositories/support_repository_impl.dart';
import '../../domain/usecases/get_support_tickets.dart';
import '../../domain/usecases/get_support_statuses.dart';
import '../../domain/usecases/get_support_priorities.dart';
import '../../domain/usecases/get_support_categories.dart';
import '../../domain/usecases/get_support_departments.dart';
import '../../domain/usecases/get_support_locations.dart';
import '../../domain/usecases/get_support_supervisors.dart';
import '../../domain/usecases/get_support_services.dart';
import '../../domain/usecases/create_support_ticket.dart';
import '../../domain/usecases/change_ticket_status.dart';
import '../../domain/usecases/change_ticket_priority.dart';
import '../../domain/usecases/delete_support_ticket.dart';
import '../notifier/support_notifier.dart';
import '../state/support_state.dart';

final supportRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return SupportRemoteDataSource(dio);
});

final supportRepositoryProvider = Provider((ref) {
  final remote = ref.watch(supportRemoteDataSourceProvider);
  return SupportRepositoryImpl(remote);
});

final getSupportTicketsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return GetSupportTickets(repo);
});

final getSupportStatusesUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return GetSupportStatuses(repo);
});

final getSupportPrioritiesUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return GetSupportPriorities(repo);
});

final getSupportCategoriesUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return GetSupportCategories(repo);
});

final getSupportDepartmentsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return GetSupportDepartments(repo);
});

final getSupportLocationsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return GetSupportLocations(repo);
});

final getSupportSupervisorsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return GetSupportSupervisors(repo);
});

final getSupportServicesUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return GetSupportServices(repo);
});

final changeTicketStatusUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return ChangeTicketStatus(repo);
});

final changeTicketPriorityUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return ChangeTicketPriority(repo);
});

final deleteSupportTicketUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return DeleteSupportTicket(repo);
});

final createSupportTicketUseCaseProvider = Provider((ref) {
  final repo = ref.watch(supportRepositoryProvider);
  return CreateSupportTicket(repo);
});

final supportNotifierProvider = StateNotifierProvider<SupportNotifier, SupportState>((ref) {
  final getTickets = ref.watch(getSupportTicketsUseCaseProvider);
  return SupportNotifier(getSupportTickets: getTickets);
});