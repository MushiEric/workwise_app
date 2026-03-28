import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';

import '../../data/datasources/pfi_remote_data_source.dart';
import '../../data/repositories/pfi_repository_impl.dart';
import '../../domain/repositories/pfi_repository.dart';
import '../../domain/usecases/get_pfis.dart';
import '../notifier/pfi_notifier.dart';
import '../state/pfi_state.dart';
import '../../../sales/data/datasources/sales_remote_data_source.dart';

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

/// PFI settings fetched from the shared sales settings endpoint.
/// Returns a typed map of PFI-specific flags driven by the backend.
final pfiSettingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final remote = SalesRemoteDataSource(dio);
  try {
    final raw = await remote.getSalesSettings();
    // Extract only pfi_* keys (and shared ones like tax_per_item)
    bool _b(dynamic v, {bool def = false}) {
      if (v == null) return def;
      if (v is bool) return v;
      if (v is int) return v != 0;
      final s = v.toString().trim().toLowerCase();
      return s != '0' && s != 'false' && s != 'no' && s != 'off';
    }

    return {
      // Visibility flags
      'pfi_allow_attachment': _b(raw['pfi_allow_attachment'], def: true),
      'pfi_show_sale_agent': _b(raw['pfi_show_sale_agent'], def: true),
      'pfi_show_project_agent': _b(raw['pfi_show_project_agent'], def: true),
      'pfi_subscription': _b(raw['pfi_subscription'], def: true),
      'pfi_subscription_recurring': _b(raw['pfi_subscription_recurring'], def: true),
      'pfi_recurring_generate_new_pfi': _b(raw['pfi_recurring_generate_new_pfi'], def: true),
      'pfi_show_period': _b(raw['pfi_show_period'], def: true),
      'pfi_allow_signature': _b(raw['pfi_allow_signature'], def: true),
      'pfi_allow_footer': _b(raw['pfi_allow_footer'], def: true),
      'pfi_show_paid_amount': _b(raw['pfi_show_paid_amount'], def: true),
      'pfi_show_due_amount': _b(raw['pfi_show_due_amount'], def: true),
      'pfi_enable_payment': _b(raw['pfi_enable_payment'], def: true),
      'pfi_allow_staff_view': _b(raw['pfi_allow_staff_view'], def: true),
      'pfi_exclude_draft_from_customer': _b(raw['pfi_exclude_draft_from_customer'], def: true),
      'pfi_client_accept_convert_to_invoice': _b(raw['pfi_client_accept_convert_to_invoice'], def: true),
      // Meta
      'pfi_prefix': raw['pfi_prefix']?.toString() ?? 'QT',
      'pfi_number_format': raw['pfi_number_format']?.toString() ?? 'number',
      'pfi_due_after': raw['pfi_due_after'] ?? 0,
      'pfi_short_name': raw['pfi_short_name']?.toString() ?? 'PFI',
      'pfi_full_name': raw['pfi_full_name']?.toString() ?? '',
      // Shared
      'tax_per_item': raw['tax_per_item'] ?? 1,
      'discount_per_item': raw['discount_per_item'] ?? 1,
      // Pre-defined content
      'pfi_client_notes': raw['pfi_client_notes']?.toString() ?? '',
      'pfi_terms_condition': raw['pfi_terms_condition']?.toString() ?? '',
    };
  } catch (_) {
    // Defaults — show everything so the form remains usable
    return {
      'pfi_allow_attachment': true,
      'pfi_show_sale_agent': true,
      'pfi_show_project_agent': true,
      'pfi_subscription': true,
      'pfi_subscription_recurring': true,
      'pfi_recurring_generate_new_pfi': true,
      'pfi_show_period': true,
      'pfi_allow_signature': true,
      'pfi_allow_footer': true,
      'pfi_show_paid_amount': true,
      'pfi_show_due_amount': true,
      'pfi_enable_payment': true,
      'pfi_allow_staff_view': true,
      'pfi_exclude_draft_from_customer': true,
      'pfi_client_accept_convert_to_invoice': true,
    };
  }
});
