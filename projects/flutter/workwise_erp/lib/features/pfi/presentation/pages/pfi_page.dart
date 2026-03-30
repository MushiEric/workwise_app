import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';

import '../providers/pfi_providers.dart';
import '../../domain/entities/pfi.dart';
import '../../../../core/themes/app_colors.dart';


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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey))),
          Expanded(flex: 3, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
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

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.pfis.length,
            itemBuilder: (ctx, i) {
              final Pfi p = state.pfis[i];
              final pfiNumber = p.proposalNumber ?? ('#${p.id}');
              final subject = p.subject ?? '';
              final customerName = p.customer?.name ?? '-';
              final status = p.status ?? '-'; 
              final date = p.createdAt != null ? DateFormat.yMMMd().format(p.createdAt!) : 'No Date';
              final totalAmount = p.total != null 
                  ? NumberFormat.currency(symbol: '').format(p.total) 
                  : '-';
              
              final isDark = Theme.of(context).brightness == Brightness.dark;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: Text('PFI $pfiNumber', style: const TextStyle(fontWeight: FontWeight.bold)),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow('Customer', p.customer?.name ?? customerName),
                                  if (p.customer?.email != null) _buildDetailRow('Email', p.customer!.email!),
                                  if (p.customer?.phone != null) _buildDetailRow('Contact', p.customer!.phone!),
                                  const Divider(),
                                  _buildDetailRow('Subject', subject),
                                  _buildDetailRow('Status', _statusLabel(p.status)),
                                  _buildDetailRow('Issue Date', p.issue_date != null ? DateFormat.yMMMd().format(p.issue_date!) : date),
                                  if (p.due_date != null) _buildDetailRow('Due Date', DateFormat.yMMMd().format(p.due_date!)),
                                  const Divider(),
                                  if (p.currencySymbol != null) _buildDetailRow('Currency', p.currencySymbol!),
                                  _buildDetailRow('Total Tax', p.totalTax?.toString() ?? '-'),
                                  _buildDetailRow('Total', totalAmount),
                                  if (p.totalDiscountType != null && p.totalDiscountType!.isNotEmpty) 
                                    _buildDetailRow('Discount Type', p.totalDiscountType!),
                                  if (p.pfiShowPeriod != null) _buildDetailRow('Show Period', p.pfiShowPeriod.toString()),
                                  if (p.showQuantityAs != null) _buildDetailRow('Qty Display', p.showQuantityAs!),
                                  if (p.notes != null && p.notes!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(p.notes!, style: const TextStyle(fontSize: 13)),
                                  ],
                                  if (p.terms != null && p.terms!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    const Text('Terms:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(p.terms!, style: const TextStyle(fontSize: 13)),
                                  ],
                                  if (p.items != null && p.items!.isNotEmpty) ...[
                                    const Divider(),
                                    const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 8),
                                    ...p.items!.map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.itemId ?? 'Unknown Item', style: const TextStyle(fontWeight: FontWeight.bold)),
                                            if (item.description != null && item.description!.isNotEmpty)
                                               Text(item.description!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Qty: ${item.qty ?? 1} ${item.uomId ?? ''}'),
                                                Text('Rate: ${item.rate ?? item.basePrice ?? '-'}'),
                                              ],
                                            ),
                                            if (item.tax != null || item.discount != null)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  if (item.tax != null) Text('Tax: ${item.tax}'),
                                                  if (item.discount != null) Text('Desc: ${item.discount} (${item.discountType ?? ''})'),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    )).toList(),
                                  ]
                                ],
                              ),
                            ),
                          ),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                     child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customerName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      pfiNumber,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    totalAmount,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _statusColor(p.status, context).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _statusLabel(p.status),
                                      style: TextStyle(
                                        color: _statusColor(p.status, context),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (subject.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              subject,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 12, color: isDark ? Colors.white38 : Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text(
                                'Issue: ${p.issue_date != null ? DateFormat.yMMMd().format(p.issue_date!) : date}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white38 : Colors.grey.shade600,
                                ),
                              ),
                              if (p.due_date != null) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.event_busy_outlined, size: 12, color: isDark ? Colors.white38 : Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Text(
                                  'Due: ${DateFormat.yMMMd().format(p.due_date!)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.white38 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                              if (p.items != null && p.items!.isNotEmpty) ...[
                                const Spacer(),
                                Icon(Icons.inventory_2_outlined, size: 12, color: isDark ? Colors.white38 : Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Text(
                                  '${p.items!.length} item${p.items!.length > 1 ? 's' : ''}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.white38 : Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
