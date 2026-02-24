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

    final statusName = order.statusRow?.name ?? order.paymentStatusRow?.name;
    final statusColor = _colorFromHex(order.statusRow?.color ?? order.paymentStatusRow?.color) ?? primary;

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
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  primary.withOpacity(0.12),
                                  primary.withOpacity(0.04),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: primary.withOpacity(0.15), width: 1),
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
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

                    // Amount + status
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
                        if (statusName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  statusName,
                                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Container(height: 1, color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),

                const SizedBox(height: 12),

                // Footer: date, items count
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 12, color: isDark ? Colors.white38 : Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(_formatDate(order.createdAt), style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey.shade600)),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    if (order.items != null && order.items!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.inventory_2_rounded, size: 12, color: isDark ? Colors.white38 : Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text('${order.items!.length} item${order.items!.length > 1 ? 's' : ''}', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey.shade600)),
                          ],
                        ),
                      ),

                    const Spacer(),

                    if (order.customer?.phone != null)
                      Text(order.customer!.phone!, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey.shade600)),
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
