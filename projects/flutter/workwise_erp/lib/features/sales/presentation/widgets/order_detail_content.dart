import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/sales_order.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_tab_bar.dart';
import '../../../../core/themes/app_icons.dart';

class OrderDetailContent extends ConsumerStatefulWidget {
  final SalesOrder order;
  const OrderDetailContent({super.key, required this.order});

  @override
  ConsumerState<OrderDetailContent> createState() => _OrderDetailContentState();
}

class _OrderDetailContentState extends ConsumerState<OrderDetailContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '-';
    try {
      final dt = DateTime.parse(value).toLocal();
      return DateFormat.yMMMd().add_jm().format(dt);
    } catch (_) {
      // malformed date (e.g. "00000z")
      return 'unknown date';
    }
  }

  String _formatAmount(dynamic amt) {
    if (amt == null) return '-';
    try {
      return NumberFormat.decimalPattern().format(amt);
    } catch (_) {
      return amt.toString();
    }
  }

  List<Map<String, dynamic>> _generateHistory() {
    final out = <Map<String, dynamic>>[];
    if (widget.order.createdAt != null) {
      out.add({
        'action': 'Order created by ${widget.order.user?.name ?? 'system'}',
        'timestamp': widget.order.createdAt,
        'type': 'create',
      });
    }

    if (widget.order.statusRow != null) {
      out.add({
        'action': 'Status: ${widget.order.statusRow?.name}',
        'timestamp': widget.order.updatedAt ?? widget.order.createdAt,
        'type': 'status',
      });
    }

    if (widget.order.paymentStatusRow != null) {
      out.add({
        'action': 'Payment: ${widget.order.paymentStatusRow?.name}',
        'timestamp': widget.order.updatedAt ?? widget.order.createdAt,
        'type': 'payment',
      });
    }

    // sort newest first when possible
    out.sort((a, b) {
      final aT = a['timestamp'] is String
          ? DateTime.tryParse(a['timestamp'])
          : a['timestamp'] as DateTime?;
      final bT = b['timestamp'] is String
          ? DateTime.tryParse(b['timestamp'])
          : b['timestamp'] as DateTime?;
      if (aT != null && bT != null) return bT.compareTo(aT);
      return 0;
    });

    return out;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Tab Bar
        AppTabBar(
          controller: _tabController,
          tabs: const [
            'Overview',
            'Status Log',
            'Truck List',
            'Loading',
          ],
        ),

        const SizedBox(height: 12),

        // Tab Bar Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildOverviewTab(isDark),
              _buildStatusLogTab(isDark),
              _buildTruckListTab(isDark),
              _buildLoadingInstructionTab(isDark),
            ],
          ),
        ),
      ],
    );
  }

  // ============= OVERVIEW TAB =============
  Widget _buildOverviewTab(bool isDark) {
    final order = widget.order;
    final statusName = order.statusRow?.name ?? '-';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildKeyValueRow(
                  'Customer Name',
                  order.customer?.name ?? order.user?.name ?? '—',
                  isDark,
                ),
                _buildKeyValueRow(
                  'Start Date',
                  order.startDate ?? '—',
                  isDark,
                  icon: Icons.event_rounded, // Calendar icon as requested
                ),
                _buildKeyValueRow(
                  'End Date',
                  order.updatedAt != null ? _formatDate(order.updatedAt) : '—',
                  isDark,
                ),
                _buildKeyValueRow(
                  'Order Status',
                  statusName,
                  isDark,
                  valueColor: _parseColor(order.statusRow?.color),
                ),
                _buildKeyValueRow(
                  'Order Number',
                  _extractOrderNumber(order.orderNumber),
                  isDark,
                ),
                if (statusName.toLowerCase().contains('invoice') ||
                    (order.paymentStatusRow?.name
                            ?.toLowerCase()
                            .contains('invoice') ??
                        false) ||
                    (order.invoiceNumber != null &&
                        order.invoiceNumber!.isNotEmpty)) ...[
                  _buildKeyValueRow(
                    'Invoice Number',
                    order.invoiceNumber ?? _extractInvoiceNumber(order.orderNumber),
                    isDark,
                    onTap: () {
                      final inv = order.invoiceNumber ?? _extractInvoiceNumber(order.orderNumber);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Navigating to Invoice $inv...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
                _buildKeyValueRow(
                  'Assigned User',
                  order.user?.name ?? '—',
                  isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Ordered Items Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Ordered Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Items List
          ... (order.items ?? []).map((it) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151A2E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildKeyValueRow(
                    'Item Name',
                    it.product?.name ?? '—',
                    isDark,
                  ),
                  _buildKeyValueRow(
                    'Quantity',
                    '${it.quantity ?? '0'} ${it.packageUnit?.shortName ?? it.packageUnit?.name ?? it.product?.unitName ?? ''}'
                        .trim(),
                    isDark,
                  ),
                  _buildKeyValueRow(
                    'Price',
                    it.price ?? '—',
                    isDark,
                  ),
                  _buildKeyValueRow(
                    'Tax',
                    it.tax ?? '—',
                    isDark,
                  ),
                  if (it.discount != null && it.discount != '0' && it.discount!.isNotEmpty)
                    _buildKeyValueRow(
                      'Discount',
                      it.discount!,
                      isDark,
                    ),
                  if (it.duration != null && it.duration != '0' && it.duration!.isNotEmpty)
                    _buildKeyValueRow(
                      'Duration',
                      '${it.duration!} ${it.durationUnit ?? ''}'.trim(),
                      isDark,
                    ),
                ],
              ),
            );
          }).toList(),

          if ((order.items ?? []).isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No items found',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }


  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.primary;
    try {
      final clean = hex.replaceFirst('#', '');
      return Color(int.parse(
        clean.length == 6 ? 'FF$clean' : clean,
        radix: 16,
      ));
    } catch (_) {
      return AppColors.primary;
    }
  }

  // ============= STATUS LOG TAB =============
  Widget _buildStatusLogTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildKeyValueRow(
              'User Created',
              widget.order.user?.name ?? '—',
              isDark,
            ),
            _buildKeyValueRow(
              'Order Status',
              widget.order.statusRow?.name ?? '—',
              isDark,
              valueColor: _parseColor(widget.order.statusRow?.color),
            ),
            _buildKeyValueRow(
              'Payment Status',
              widget.order.paymentStatusRow?.name ?? '—',
              isDark,
              valueColor: _parseColor(widget.order.paymentStatusRow?.color),
            ),
            _buildKeyValueRow(
              'Created Date',
              _formatDate(widget.order.createdAt),
              isDark,
            ),
          ],
        ),
      ),
    );
  }


  // ============= TRUCK LIST TAB =============
  Widget _buildTruckListTab(bool isDark) {
    final trucks = widget.order.truckList ?? [];
    if (trucks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'No trucks assigned',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    }

    String unitLabel(String? id) {
      if (id == null) return 'KG';
      if (id == '1' || id.toUpperCase() == 'KG') return 'KG';
      return id;
    }

    Widget weightCard(
      String title,
      String? weight,
      String? unit,
      String? timestamp, {
      Color? valueColor,
    }) {
      final hasValue = (weight ?? '').isNotEmpty;
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                hasValue
                    ? '${NumberFormat.decimalPattern().format(num.tryParse((weight ?? '0').replaceAll(',', '')) ?? 0)} ${unitLabel(unit)}'
                    : '-',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? (isDark ? Colors.white : const Color(0xFF1A2634)),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                timestamp != null && timestamp.isNotEmpty
                    ? _formatDate(timestamp)
                    : (hasValue ? 'Calculated' : '-'),
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trucks.length,
      itemBuilder: (context, idx) {
        final t = trucks[idx];
        final completed = (t.checkinStatus?.toLowerCase() == 'completed') ||
            (t.checkoutStatus?.toLowerCase() == 'completed');

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '#${idx + 1}  ${t.vehicleName ?? 'TRUCK'}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color:
                              isDark ? Colors.white : const Color(0xFF1A2634),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (completed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              _buildKeyValueRow(
                'Plate Number',
                t.vehiclePlateNumber ?? '—',
                isDark,
                verticalPadding: 6.0,
              ),
              _buildKeyValueRow(
                'Trailer Number',
                t.vehicleTrailerNumber ?? '—',
                isDark,
                verticalPadding: 6.0,
              ),

              const SizedBox(height: 3),

              _buildKeyValueRow(
                'Driver Name',
                t.driverName ?? '—',
                isDark,
                verticalPadding: 6.0,
              ),
              _buildKeyValueRow(
                'Driver Phone',
                t.driverPhone ?? '—',
                isDark,
                verticalPadding: 6.0,
              ),
              _buildKeyValueRow(
                'License Number',
                t.driverLicenseNumber ?? '—',
                isDark,
                verticalPadding: 6.0,
              ),

              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    weightCard(
                      'Gross Weight',
                      t.checkinWeight,
                      t.checkinWeightUnit,
                      t.checkinDatetime,
                      valueColor: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    weightCard(
                      'Tare Weight',
                      t.checkoutWeight,
                      t.checkoutWeightUnit,
                      t.checkoutDatetime,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    weightCard(
                      'Net Weight',
                      t.netWeight,
                      t.netWeightUnit,
                      null,
                      valueColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ============= LOADING INSTRUCTION TAB =============
  Widget _buildLoadingInstructionTab(bool isDark) {
    final items = widget.order.items ?? [];
    final list = items
        .where((i) => (i.loadingInstruction ?? '').isNotEmpty)
        .toList();

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'No loading instructions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final it = list[idx];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      it.product?.name ?? 'Item',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      it.loadingInstruction ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============= HELPER WIDGETS =============
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.white38 : Colors.grey.shade500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A2634),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(String key, String value, bool isDark,
      {IconData? icon,
      Color? valueColor,
      double verticalPadding = 10.0,
      VoidCallback? onTap}) {
    final Widget content = Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              key,
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: valueColor ??
                          (isDark ? Colors.white : const Color(0xFF1A2634)),
                      decoration:
                          onTap != null ? TextDecoration.underline : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  String _extractInvoiceNumber(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    // Matches "INV-1234", "IV-1234", "invoice 1234" etc.
    final reg = RegExp(r'(?:invoice|inv|iv)\s*[:\-\s]*([A-Z0-9-/]+)',
        caseSensitive: false);
    final match = reg.firstMatch(raw);
    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? '—';
    }
    // Fallback: If it's invoiced but we can't find clear pattern, clean it
    if (raw.toLowerCase().contains('invoiced')) {
      return raw
          .replaceAll(RegExp(r'\s*invoiced\s*', caseSensitive: false), '')
          .replaceAll(RegExp(r'[()]', caseSensitive: false), '')
          .trim();
    }
    return '—';
  }

  String _extractOrderNumber(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    // If it contains "invoiced", only take the part before it
    final lower = raw.toLowerCase();
    if (lower.contains('invoiced')) {
      final idx = lower.indexOf('invoiced');
      final pre = raw.substring(0, idx).trim();
      if (pre.isNotEmpty) return pre;
    }
    // Clean up "unpaid"
    return raw
        .replaceAll(RegExp(r'\s*unpaid\s*', caseSensitive: false), '')
        .trim();
  }
}
