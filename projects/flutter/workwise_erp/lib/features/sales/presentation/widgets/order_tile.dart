import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/sales_order.dart';
import '../../../../core/themes/app_colors.dart';

Color? _colorFromHex(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  final cleaned = hex.replaceAll('#', '').trim();
  try {
    final value = int.parse(cleaned, radix: 16);
    if (cleaned.length == 6) {
      return Color(0xFF000000 | value);
    } else if (cleaned.length == 8) {
      return Color(value);
    }
  } catch (_) {}
  return null;
}

class OrderTile extends StatelessWidget {
  final SalesOrder order;
  final VoidCallback? onTap;

  const OrderTile({super.key, required this.order, this.onTap});

  String _formatDate(String? d) {
    if (d == null || d.isEmpty) return 'No date';
    try {
      final dt = DateTime.parse(d);
      return DateFormat.yMMMd().format(dt);
    } catch (_) {
      // Input may be malformed (e.g. "00000z"), avoid showing raw junk
      return 'unknown date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary;

    final customerName = order.customer?.name ?? order.user?.name ?? '';
    final orderNum = order.orderNumber ?? '-';
    final amountText = order.amount != null
        ? NumberFormat.decimalPattern().format(order.amount)
        : '';

    final statusName = order.statusRow?.name;
    final statusColor = _colorFromHex(order.statusRow?.color) ?? primary;

    final paymentStatusName = order.paymentStatusRow?.name;
    final hasPaymentStatus = paymentStatusName != null && paymentStatusName.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: primary.withOpacity(0.05),
          highlightColor: primary.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon + details
                    Expanded(
                      child: Row(
                        children: [
                          // Removed icon container
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Customer name (primary)
                                Text(
                                  customerName.isNotEmpty ? customerName : orderNum,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Order number (secondary)
                                Text(
                                  orderNum,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Amount + order status + invoice/payment status
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (amountText.isNotEmpty)
                          Text(
                            amountText,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        const SizedBox(height: 6),
                        // Order status chip
                        if (statusName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusName,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        // Invoice / payment status chip — always green
                        if (hasPaymentStatus) ...[  
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              paymentStatusName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Footer: date, items count
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_formatDate(order.createdAt), style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey.shade600)),
                    ),

                    const SizedBox(width: 8),

                    if (order.items != null && order.items!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${order.items!.length} item${order.items!.length > 1 ? 's' : ''}', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey.shade600)),
                      ),

                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
