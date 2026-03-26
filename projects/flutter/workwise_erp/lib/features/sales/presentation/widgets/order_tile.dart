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
    
    final orderNum = (order.orderNumber ?? '-').replaceAll(RegExp(r'\s*unpaid\s*', caseSensitive: false), '').trim();
    
    final amountText = order.amount != null
        ? NumberFormat.decimalPattern().format(order.amount)
        : '';

    final statusName = order.statusRow?.name;
    Color statusColor = _colorFromHex(order.statusRow?.color) ?? primary;
    if (statusName != null && statusName.toLowerCase().contains('invoice')) {
      statusColor = Colors.green.shade600;
    }

    // Payment status handling: color it green if it contains "Invoiced"
    final paymentStatusName = order.paymentStatusRow?.name;
    final isPaymentInvoiced = paymentStatusName != null &&
        paymentStatusName.toLowerCase().contains('invoice');
    final showPaymentStatus = paymentStatusName != null &&
        paymentStatusName.toLowerCase() != 'unpaid';

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
                                // Order number + optional Invoiced badge on same line
                                Row(
                                  children: [
                                    Flexible(
                                      child: _buildHighlightedText(orderNum, 'invoiced', isDark),
                                    ),
                                    if (showPaymentStatus) ...[  
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: (isPaymentInvoiced ? Colors.green : Colors.grey).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          paymentStatusName,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isPaymentInvoiced ? Colors.green.shade700 : Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
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
                        if (statusName != null && statusName.toLowerCase() != 'unpaid')
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

  Widget _buildHighlightedText(String text, String highlight, bool isDark) {
    if (text.isEmpty) return const SizedBox.shrink();
    
    final pattern = RegExp(RegExp.escape(highlight), caseSensitive: false);
    final matches = pattern.allMatches(text);
    
    if (matches.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.white54 : Colors.grey.shade600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    
    final List<TextSpan> spans = [];
    int start = 0;
    
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      // Add a clear space before the highlighted word if not at the beginning
      if (match.start > 0) {
        spans.add(const TextSpan(text: ' '));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          color: Colors.green.shade600,
          fontWeight: FontWeight.bold,
        ),
      ));
      start = match.end;
    }
    
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.white54 : Colors.grey.shade600,
        ),
        children: spans,
      ),
    );
  }
}
