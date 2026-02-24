import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/sales_order.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

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
    _tabController = TabController(length: 6, vsync: this);
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
        'action': 'Order created',
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
    final primaryColor = AppColors.primary;

    return Column(
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Items'),
              Tab(text: 'Status Log'),
              Tab(text: 'Print Logs'),
              Tab(text: 'Truck List'),
              Tab(text: 'Loading'),
            ],
            labelColor: primaryColor,
            unselectedLabelColor: isDark
                ? Colors.white54
                : Colors.grey.shade600,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: primaryColor.withOpacity(0.12),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
        ),

        const SizedBox(height: 12),

        // Tab Bar Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildOverviewTab(isDark),
              _buildItemsTab(isDark),
              _buildStatusLogTab(isDark),
              _buildPrintLogsTab(isDark),
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
    final paymentName = order.paymentStatusRow?.name ?? '-';

    Color getStatusColor(String? status) {
      switch (status?.toLowerCase()) {
        case 'pending':
          return Colors.orange;
        case 'processing':
          return Colors.blue;
        case 'completed':
          return Colors.green;
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Order icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.shopping_cart_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),

                // Order details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderNumber ?? '—',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A2634),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.customer?.name ?? order.user?.name ?? '—',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount and payment status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatAmount(order.amount),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(paymentName).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: getStatusColor(paymentName).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        paymentName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: getStatusColor(paymentName),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Info chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildInfoChip(
                  icon: Icons.flag_rounded,
                  label: 'Status',
                  value: statusName,
                  color: getStatusColor(statusName),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  icon: Icons.event_rounded,
                  label: 'Start date',
                  value: order.startDate ?? '-',
                  color: Colors.blue,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  icon: Icons.access_time_rounded,
                  label: 'Created',
                  value: _formatDate(order.createdAt),
                  color: Colors.purple,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Summary Card
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.summarize_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildKeyValueRow(
                    'Order number',
                    order.orderNumber ?? '-',
                    isDark,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Divider(height: 1),
                  ),
                  _buildKeyValueRow(
                    'Customer',
                    order.customer?.name ?? '-',
                    isDark,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Divider(height: 1),
                  ),
                  _buildKeyValueRow(
                    'Created by',
                    order.user?.name ?? '-',
                    isDark,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Edit Order',
                  icon: Icons.edit_rounded,
                  onPressed: () {},
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.medium,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: 'Convert to Invoice',
                  textColor: AppColors.white,
                  icon: Icons.receipt_long_rounded,
                  onPressed: () {},
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.medium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============= ITEMS TAB =============
  Widget _buildItemsTab(bool isDark) {
    final items = widget.order.items ?? [];
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
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
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, idx) {
        final it = items[idx];
        final productName = it.product?.name ?? 'Item ${it.itemId ?? ''}';
        final quantity = it.quantity ?? 0;
        final unit = it.packageUnit?.shortName ?? '';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with product name and quantity
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2634),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Item #${it.itemId ?? idx + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Qty: $quantity ${unit.isNotEmpty ? unit : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Price
                Row(
                  children: [
                    Icon(
                      Icons.price_change_rounded,
                      size: 16,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Price: ${it.price ?? '-'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),

                // Loading instruction if exists
                if (it.loadingInstruction != null &&
                    it.loadingInstruction!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_alt_rounded,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Loading: ${it.loadingInstruction}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ============= STATUS LOG TAB =============
  Widget _buildStatusLogTab(bool isDark) {
    final history = _generateHistory();
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 64,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No history available',
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
      itemCount: history.length,
      itemBuilder: (context, idx) {
        final h = history[idx];
        final type = h['type'] ?? 'default';

        IconData icon;
        Color iconColor;

        switch (type) {
          case 'create':
            icon = Icons.add_circle_rounded;
            iconColor = Colors.green;
            break;
          case 'status':
            icon = Icons.compare_arrows_rounded;
            iconColor = Colors.blue;
            break;
          case 'payment':
            icon = Icons.payment_rounded;
            iconColor = Colors.orange;
            break;
          default:
            icon = Icons.history_rounded;
            iconColor = Colors.grey;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 18, color: iconColor),
                  ),
                  if (idx < history.length - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.03)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h['action'] ?? '-',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A2634),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(h['timestamp']?.toString()),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============= PRINT LOGS TAB =============
  Widget _buildPrintLogsTab(bool isDark) {
    // Print logs are not modelled yet — show placeholder
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.print_disabled_rounded,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No print logs',
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

  // ============= TRUCK LIST TAB =============
  Widget _buildTruckListTab(bool isDark) {
    final trucks = widget.order.truckList ?? [];
    if (trucks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 64,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
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

    String _unitLabel(String? id) {
      if (id == null) return 'KG';
      if (id == '1' || id.toUpperCase() == 'KG') return 'KG';
      return id;
    }

    Widget _weightCard(
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                hasValue
                    ? '${NumberFormat.decimalPattern().format(num.tryParse((weight ?? '0').replaceAll(',', '')) ?? 0)} ${_unitLabel(unit)}'
                    : '-',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                timestamp != null && timestamp.isNotEmpty
                    ? _formatDate(timestamp)
                    : (hasValue ? 'Calculated' : '-'),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: trucks.length,
      itemBuilder: (context, idx) {
        final t = trucks[idx];
        final completed =
            (t.checkinStatus?.toLowerCase() == 'completed') ||
            (t.checkoutStatus?.toLowerCase() == 'completed');

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '#${idx + 1}  ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        t.vehicleName ?? 'TRUCK',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  if (completed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Completed',
                            style: TextStyle(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Vehicle information
              const Text(
                'Vehicle Information',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children:
                    [
                          Expanded(
                            child: Text(
                              'Plate Number:\n${t.vehiclePlateNumber ?? '-'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Trailer Number:\n${t.vehicleTrailerNumber ?? '-'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ]
                        .map(
                          (w) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: w,
                          ),
                        )
                        .toList(),
              ),

              const SizedBox(height: 12),

              // Driver information
              const Text(
                'Driver Information',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children:
                    [
                          Expanded(
                            child: Text(
                              'Driver Name:\n${t.driverName ?? '-'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Phone:\n${t.driverPhone ?? '-'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ]
                        .map(
                          (w) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: w,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 6),
              Text(
                'License:\n${t.driverLicenseNumber ?? '-'}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              // Weight information
              const Text(
                'Weight Information',
                style: TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _weightCard(
                    'Check-in',
                    t.checkinWeight,
                    t.checkinWeightUnit,
                    t.checkinDatetime,
                    valueColor: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _weightCard(
                    'Checkout',
                    t.checkoutWeight,
                    t.checkoutWeightUnit,
                    t.checkoutDatetime,
                  ),
                  const SizedBox(width: 8),
                  _weightCard(
                    'Net Weight',
                    t.netWeight,
                    t.netWeightUnit,
                    null,
                    valueColor: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Actions similar to web screenshot
              Row(
                children: [
                  Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: Colors.green.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Colors.green.withOpacity(0.3),
      width: 1,
    ),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(
        Icons.check_circle_rounded,
        size: 14,
        color: Colors.green,
      ),
      SizedBox(width: 4),
      Text(
        'Completed',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color:AppColors.muted,
        ),
      ),
    ],
  ),
)
   ,               const SizedBox(width: 8),
               
                ],
              ),
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
            Icon(
              Icons.note_alt_outlined,
              size: 64,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.note_alt_rounded,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Column(
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
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(String key, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF1A2634),
            ),
          ),
        ],
      ),
    );
  }
}
