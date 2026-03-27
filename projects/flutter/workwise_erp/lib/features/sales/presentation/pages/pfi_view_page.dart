import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_tab_bar.dart';
import '../../../pfi/domain/entities/pfi.dart';

class PfiViewPage extends ConsumerStatefulWidget {
  final Pfi pfi;
  const PfiViewPage({super.key, required this.pfi});

  @override
  ConsumerState<PfiViewPage> createState() => _PfiViewPageState();
}

class _PfiViewPageState extends ConsumerState<PfiViewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat.yMMMd().format(dt);
  }

  String _fmtAmount(double? v) {
    if (v == null) return '—';
    return NumberFormat.decimalPattern().format(v);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pfi = widget.pfi;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
      appBar: CustomAppBar(
        title: 'PFI #${pfi.proposalNumber ?? pfi.id}',
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded, color: isDark ? Colors.white70 : Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/sales/pfi/edit', arguments: pfi),
          ),
        ],
      ),
      body: Column(
        children: [
          // Pill-shaped tab bar — matches orders UI
          AppTabBar(
            controller: _tabController,
            tabs: const ['Overview', 'Payments'],
            isScrollable: false,
          ),

          const SizedBox(height: 12),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildOverviewTab(isDark),
                _buildPaymentsTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── OVERVIEW TAB ───────────────────────────────

  Widget _buildOverviewTab(bool isDark) {
    final pfi = widget.pfi;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // General info card
          _card(
            isDark: isDark,
            children: [
              _row('Customer',      pfi.customerName ?? '—', isDark),
              _row('Subject',       pfi.subject ?? '—', isDark),
              _row('Quotation #',   pfi.proposalNumber ?? '—', isDark),
              _row('Status',        _statusLabel(pfi.status), isDark,
                  valueColor: _statusColor(pfi.status)),
              _row('Issue Date',    _fmt(pfi.issueDate), isDark),
              _row('Due Date',      _fmt(pfi.dueDate), isDark),
              _row('Created Date',  _fmt(pfi.createdAt), isDark),
            ],
          ),

          const SizedBox(height: 20),

          // Financial / logistics card
          _card(
            isDark: isDark,
            header: 'Logistics & Billing',
            children: [
              _row('Warehouse',       pfi.warehouseId ?? '—', isDark),
              _row('Sales Agent',     pfi.salesAgentId ?? '—', isDark),
              _row('Payment Method',  pfi.paymentMethodId ?? '—', isDark),
              _row('Payment Terms',   pfi.paymentTermsId ?? '—', isDark),
              if (pfi.projectId != null)
                _row('Project', pfi.projectId!, isDark),
              if (pfi.tripId != null)
                _row('Trip', pfi.tripId!, isDark),
            ],
          ),

          if (pfi.notes != null && pfi.notes!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _card(
              isDark: isDark,
              header: 'Client Notes',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    pfi.notes!,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Line items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Line Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
          ),
          const SizedBox(height: 12),

          if (pfi.items == null || pfi.items!.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No items listed',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ),
            )
          else
            ...pfi.items!.map((item) => _card(
              isDark: isDark,
              children: [
                _row('Item',     item.itemId ?? '—', isDark),
                _row('Qty',      '${item.qty ?? 0}  ${item.uomId ?? ''}'.trim(), isDark),
                _row('Rate',     _fmtAmount(item.rate), isDark),
                _row('Tax',      item.tax != null ? '${item.tax}%' : '—', isDark),
                if (item.period != null)
                  _row('Period', '${item.period} ${item.periodUnit ?? ''}'.trim(), isDark),
                _row('Subtotal', _fmtAmount(item.subtotal), isDark,
                    valueColor: AppColors.primary),
              ],
            )),

          // Grand total
          if (pfi.total != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${_fmtAmount(pfi.total)} TSh',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (pfi.terms != null && pfi.terms!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _card(
              isDark: isDark,
              header: 'Terms & Conditions',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    pfi.terms!,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ─────────────────────────── PAYMENTS TAB ───────────────────────────────

  Widget _buildPaymentsTab(bool isDark) {
    final payments = widget.pfi.payments ?? [];

    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment_rounded, size: 64.r, color: Colors.grey.withOpacity(0.4)),
            SizedBox(height: 16.h),
            Text(
              'No payments recorded yet',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final p = payments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _card(
            isDark: isDark,
            children: [
              _row('Receipt #',     p.paymentReceipt ?? '—', isDark),
              _row('Date',          _fmt(p.date), isDark),
              _row('Amount',        '${_fmtAmount(p.amount)} TSh', isDark,
                  valueColor: AppColors.primary),
              _row('Payment Type',  p.paymentType ?? '—', isDark),
              _row('Reference',     p.reference ?? '—', isDark),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────── SHARED HELPERS ─────────────────────────────

  /// Card with the same rounded shadow style as the orders detail screen.
  Widget _card({
    required bool isDark,
    required List<Widget> children,
    String? header,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                header,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
            ),
          ],
          ...children,
        ],
      ),
    );
  }

  /// Key-value row — identical layout to orders `_buildKeyValueRow`.
  Widget _row(String key, String value, bool isDark, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: valueColor ?? (isDark ? Colors.white : const Color(0xFF1A2634)),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(int? s) {
    switch (s) {
      case 0: return 'Draft';
      case 1: return 'Sent';
      case 2: return 'Accepted';
      case 3: return 'Invoiced';
      case 4: return 'Declined';
      default: return 'Unknown';
    }
  }

  Color _statusColor(int? s) {
    switch (s) {
      case 0: return Colors.grey;
      case 1: return Colors.orange;
      case 2: return Colors.green;
      case 3: return Colors.blue;
      case 4: return Colors.red;
      default: return AppColors.primary;
    }
  }
}
