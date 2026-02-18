import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_drawer.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';
import '../../../../core/themes/app_colors.dart';
import '../providers/operators_providers.dart';
import '../../domain/entities/operator.dart' as domain;

class OperatorDetailPage extends ConsumerStatefulWidget {
  const OperatorDetailPage({super.key});

  @override
  ConsumerState<OperatorDetailPage> createState() => _OperatorDetailPageState();
}

class _OperatorDetailPageState extends ConsumerState<OperatorDetailPage> {
  int? _idFromArgs;
  domain.Operator? _operatorFromArgs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is int) {
      _idFromArgs = arg;
      // ensure list is loaded so we can find item by id
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(operatorsNotifierProvider.notifier).loadOperators());
    } else if (arg is domain.Operator) {
      _operatorFromArgs = arg;
    }
  }

  Widget _infoRow(String label, String? value, {bool emphasize = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelWidth = MediaQuery.of(context).size.width >= 600 ? 160.0 : 120.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: labelWidth, child: Text(label, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value ?? '-', style: TextStyle(fontWeight: emphasize ? FontWeight.w600 : FontWeight.w400, color: isDark ? Colors.white : const Color(0xFF1A2634))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(operatorsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve operator to display (argument preferred, then lookup by id)
    domain.Operator? op = _operatorFromArgs;
    if (op == null && _idFromArgs != null) {
      state.maybeWhen(loaded: (list) {
        try {
          op = list.firstWhere((x) => x.id == _idFromArgs);
        } catch (_) {
          op = null;
        }
      }, orElse: () {});
    }

    final loading = state.maybeWhen(loading: () => true, orElse: () => false) && op == null;

    // Return early so the analyzer understands `op` is non-null in the main UI branch.
    if (loading) {
      return Scaffold(appBar: CustomAppBar(title: 'Operator Detail'), drawer: const AppDrawer(), body: const Center(child: CircularProgressIndicator()));
    }

    if (op == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Operator Detail'),
        drawer: const AppDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 64, color: isDark ? Colors.red.shade300 : Colors.red.shade400),
                const SizedBox(height: 12),
                Text('Operator not found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2634))),
                const SizedBox(height: 8),
                Text('The requested operator could not be loaded. Try refreshing the operators list.', textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600)),
                const SizedBox(height: 16),
                ElevatedButton.icon(onPressed: () => ref.read(operatorsNotifierProvider.notifier).loadOperators(), icon: const Icon(Icons.refresh_rounded), label: const Text('Reload'))
              ],
            ),
          ),
        ),
      );
    }

    final domain.Operator operator = op!; // non-null from checks above

    return Scaffold(
      appBar: CustomAppBar(title: 'Operator Detail'),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151A2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary.withOpacity(0.08),
                    backgroundImage: imageProviderFromUrl(operator.avatar),
                    child: operator.avatar == null || operator.avatar!.isEmpty ? Icon(Icons.person, color: AppColors.primary, size: 36) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(operator.name ?? 'Unnamed operator', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2634))),
                        const SizedBox(height: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (operator.phone != null && operator.phone!.isNotEmpty) Text(operator.phone!, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700)),
                            if (operator.email != null && operator.email!.isNotEmpty) Text(operator.email!, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(
                          (operator.status ?? 'Active').toString(),
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Information card (single-column for clarity)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151A2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('First name', _firstName(operator.name)),
                  _infoRow('Middle name', _middleName(operator.name)),
                  _infoRow('Last name', _lastName(operator.name)),
                  _infoRow('Gender', null),
                  _infoRow('Date Of Birth', null),
                  _infoRow('Driving Licence', operator.licenseNumber),
                  _infoRow('Issue date', null),
                  _infoRow('Expire date', null),
                  _infoRow('Email', operator.email),
                  _infoRow('Phone Number', operator.phone),
                  _infoRow('Address', null),
                  _infoRow('Status', operator.status, emphasize: true),
                  _infoRow('Employee Profile', null),
                  _infoRow('User Access', operator.createdAt != null ? 'Yes' : 'No'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Attachments / Documents table (empty state similar to web)
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151A2E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.attachment_outlined, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('Attachments', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1A2634))),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(isDark ? Colors.white10 : Colors.grey.shade100),
                      columns: const [
                        DataColumn(label: Text('S/N')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Expire Date')),
                        DataColumn(label: Text('File')),
                      ],
                      rows: const [],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _firstName(String? full) {
    if (full == null) return null;
    final parts = full.split(' ');
    return parts.isNotEmpty ? parts.first : null;
  }

  String? _lastName(String? full) {
    if (full == null) return null;
    final parts = full.split(' ');
    return parts.length > 1 ? parts.last : null;
  }

  String? _middleName(String? full) {
    if (full == null) return null;
    final parts = full.split(' ');
    if (parts.length <= 2) return null;
    return parts.sublist(1, parts.length - 1).join(' ');
  }
}
