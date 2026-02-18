import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';

import '../providers/pfi_providers.dart';
import '../../domain/entities/pfi.dart';


class PfiPage extends ConsumerStatefulWidget {
  const PfiPage({super.key});

  @override
  ConsumerState<PfiPage> createState() => _PfiPageState();
}

class _PfiPageState extends ConsumerState<PfiPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pfiNotifierProvider.notifier).loadPfis();
    });
  }

  String _statusLabel(int? s) {
    switch (s) {
      case 0:
        return 'Draft';
      case 1:
        return 'Sent';
      case 2:
        return 'Accepted';
      case 3:
        return 'Invoiced';
      case 4:
        return 'Declined';
      default:
        return 'Unknown';
    }
  }

  Color _statusColor(int? s, BuildContext ctx) {
    switch (s) {
      case 0:
        return Colors.grey.shade400;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Theme.of(ctx).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pfiNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(title:"PFI"),
      body: RefreshIndicator(
        onRefresh: () => ref.read(pfiNotifierProvider.notifier).loadPfis(),
        child: Builder(builder: (context) {
          if (state.isLoading && state.pfis.isEmpty) return const Center(child: CircularProgressIndicator());
          if (state.pfis.isEmpty) {
            if (state.error != null) {
              return ListView(children: [const SizedBox(height: 120), Center(child: Text('Failed: \'${state.error}\''))]);
            }
            return ListView(children: const [SizedBox(height: 120), Center(child: Text('No PFI found'))]);
          }

          return ListView.separated(
            itemCount: state.pfis.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final Pfi p = state.pfis[i];
              final title = p.proposalNumber ?? ('#${p.id}');
              final subtitle = p.subject ?? '';
              final date = p.createdAt != null ? DateFormat.yMMMd().format(p.createdAt!) : '';

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Row(
                  children: [
                    Expanded(child: Text('$title — ${subtitle.isNotEmpty ? subtitle : ''}', style: const TextStyle(fontWeight: FontWeight.w600))),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(_statusLabel(p.status), style: const TextStyle(color: Colors.white, fontSize: 12)),
                      backgroundColor: _statusColor(p.status, context),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(date, style: const TextStyle(fontSize: 12)),
                ),
                onTap: () {
                  // TODO: navigate to PFI detail when endpoint provided
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('PFI ${p.proposalNumber ?? p.id}'),
                      content: Text(p.subject ?? 'No subject'),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
