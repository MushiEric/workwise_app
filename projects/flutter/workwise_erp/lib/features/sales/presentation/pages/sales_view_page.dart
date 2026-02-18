import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/order_detail_content.dart';
import '../../domain/entities/sales_order.dart';
import '../../../../core/widgets/app_bar.dart';

class SalesViewPage extends ConsumerWidget {
  final SalesOrder order;
  const SalesViewPage({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order #${order.orderNumber ?? order.id}',
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded, color: isDark ? Colors.white70 : Colors.grey.shade600),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share order — not implemented'))),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: isDark ? Colors.white70 : Colors.grey.shade600),
            onSelected: (v) {
              // placeholder actions
              switch (v) {
                case 'print':
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Print order — not implemented')));
                  break;
                case 'more':
                default:
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('More options')));
              }
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'print', child: Text('Print')),
              PopupMenuItem(value: 'more', child: Text('More...')),
            ],
          ),
        ],
      ),
      body: DefaultTabController(length: 6, child: OrderDetailContent(order: order)),
    );
  }
}
