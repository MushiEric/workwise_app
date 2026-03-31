import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_tab_bar.dart';
import '../../domain/entities/invoice.dart';

class InvoiceViewPage extends ConsumerStatefulWidget {
  final Invoice invoice;
  const InvoiceViewPage({super.key, required this.invoice});

  @override
  ConsumerState<InvoiceViewPage> createState() => _InvoiceViewPageState();
}

class _InvoiceViewPageState extends ConsumerState<InvoiceViewPage>
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

  String _statusLabel(int? status) {
    switch (status) {
      case 0:
        return 'Draft';
      case 1:
        return 'Sent';
      case 2:
        return 'Unpaid';
      case 3:
        return 'Partial paid';
      case 4:
        return 'Paid';
      default:
        return 'Unknown';
    }
  }

  Color _statusColor(int? status) {
    switch (status) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      case 3:
        return Colors.yellow.shade700;
      case 4:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _fmtDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      return DateFormat.yMMMd().format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final invoice = widget.invoice;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0E21)
          : const Color(0xFFF8F9FC),
      appBar: CustomAppBar(
        title: 'Invoice #${invoice.invoiceNumber ?? invoice.id}',
      ),
      body: Column(
        children: [
          AppTabBar(
            controller: _tabController,
            tabs: const ['Overview', 'Payment', 'Credit Notes', 'Print VFD'],
            isScrollable: false,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildOverviewTab(isDark, invoice),
                _buildPlaceholderTab(isDark, 'Payment'),
                _buildPlaceholderTab(isDark, 'Credit Notes'),
                _buildPlaceholderTab(isDark, 'Print VFD'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(bool isDark, Invoice invoice) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _infoRow('Invoice No', invoice.invoiceNumber ?? '-'),
                _infoRow('Customer', invoice.customerName ?? '-'),
                _infoRow('Issue Date', _fmtDate(invoice.issueDate)),
                _infoRow('Due Date', _fmtDate(invoice.dueDate)),
                _infoRow('Payment Method', invoice.paymentMethod ?? '-'),
                _infoRow(
                  'Status',
                  _statusLabel(invoice.status),
                  valueColor: _statusColor(invoice.status),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Line Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A2634),
            ),
          ),
          const SizedBox(height: 12),
          if (invoice.items == null || invoice.items!.isEmpty)
            Center(child: Text('No items found')),
          if (invoice.items != null)
            ...invoice.items!.map((item) => _buildItemTile(isDark, item)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
            ),
            child: Column(
              children: [
                _infoRow('Total Amount', invoice.amount ?? '0.00'),
                _infoRow('Discount', invoice.discount ?? '0.00'),
                const Divider(height: 24),
                _infoRow(
                  'Grand Total',
                  invoice.amount ?? '0.00',
                  valueColor: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildItemTile(bool isDark, InvoiceItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.itemName ?? 'Unknown Item',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${item.subtotal ?? 0.0}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Qty: ${item.quantity ?? 0}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Text(
                'Rate: ${item.rate ?? 0}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(bool isDark, String title) {
    return Center(
      child: Text(
        '$title content placeholder',
        style: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.white60 : Colors.grey.shade700,
        ),
      ),
    );
  }
}
