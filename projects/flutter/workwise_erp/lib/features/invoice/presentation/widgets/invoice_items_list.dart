import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/themes/app_icons.dart';
import 'package:workwise_erp/core/widgets/app_smart_dropdown.dart';
import 'package:workwise_erp/core/widgets/app_textfields.dart';
import '../../../../features/sales/presentation/providers/sales_providers.dart';

class InvoiceItemsList extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> items;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;
  final String? exchangeRate;
  final ValueChanged<String?> onExchangeRateChanged;
  final String? defaultUnitLabel;
  final ValueChanged<String?> onDefaultUnitLabelChanged;
  final bool showPeriod;
  final ValueChanged<bool> onShowPeriodChanged;

  const InvoiceItemsList({
    super.key,
    required this.items,
    required this.onChanged,
    this.exchangeRate,
    required this.onExchangeRateChanged,
    this.defaultUnitLabel,
    required this.onDefaultUnitLabelChanged,
    required this.showPeriod,
    required this.onShowPeriodChanged,
  });

  @override
  ConsumerState<InvoiceItemsList> createState() => _InvoiceItemsListState();
}

class _InvoiceItemsListState extends ConsumerState<InvoiceItemsList> {
  void _addItem() {
    final newItem = {
      'item_id': null,
      'description': '',
      'qty': 1.0,
      'rate': 0.0,
      'tax_id': null,
      'subtotal': 0.0,
    };
    widget.onChanged([...widget.items, newItem]);
  }

  void _removeItem(int index) {
    final newItems = List<Map<String, dynamic>>.from(widget.items);
    newItems.removeAt(index);
    widget.onChanged(newItems);
  }

  void _updateItem(int index, String key, dynamic value) {
    final newItems = List<Map<String, dynamic>>.from(widget.items);
    newItems[index][key] = value;
    
    // Recalculate subtotal
    final qty = double.tryParse(newItems[index]['qty'].toString()) ?? 0.0;
    final rate = double.tryParse(newItems[index]['rate'].toString()) ?? 0.0;
    newItems[index]['subtotal'] = qty * rate;
    
    widget.onChanged(newItems);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            TextButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Row'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildExtraFields(isDark),
        const SizedBox(height: 16),
        if (widget.items.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No items added yet',
                style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
              ),
            ),
          )
        else
          ...widget.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildItemCard(index, item, isDark);
          }).toList(),
      ],
    );
  }

  Widget _buildExtraFields(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Exchange rate',
                hintText: '1.0',
                initialValue: widget.exchangeRate,
                onChanged: widget.onExchangeRateChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppTextField(
                label: 'Default Unit Label',
                hintText: 'Qty',
                initialValue: widget.defaultUnitLabel,
                onChanged: widget.onDefaultUnitLabelChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Show Period', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(width: 12),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: widget.showPeriod,
                  onChanged: (v) => widget.onShowPeriodChanged(v!),
                  activeColor: AppColors.primary,
                ),
                const Text('Yes'),
                Radio<bool>(
                  value: false,
                  groupValue: widget.showPeriod,
                  onChanged: (v) => widget.onShowPeriodChanged(v!),
                  activeColor: AppColors.primary,
                ),
                const Text('No'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemCard(int index, Map<String, dynamic> item, bool isDark) {
    final taxes = ref.watch(salesTaxesProvider).valueOrNull ?? [];
    final products = ref.watch(salesProductsProvider).valueOrNull ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Builder(builder: (context) {
                  final list = products.map((p) => {
                    'id': p.id,
                    'name': p.name,
                    'price': double.tryParse(p.salePrice ?? '0') ?? 0.0,
                  }).toList();
                  return AppSmartDropdown<Map<String, dynamic>>(
                    label: 'Item',
                    hintText: 'Select Item',
                    value: list.where((p) => p['id'] == item['item_id']).firstOrNull,
                    items: list,
                    itemBuilder: (p) => (p['name'] ?? '').toString(),
                    onChanged: (val) {
                      if (val != null) {
                        _updateItem(index, 'item_id', val['id']);
                        _updateItem(index, 'rate', val['price'] ?? 0.0);
                      }
                    },
                  );
                }),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _removeItem(index),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppTextField(
            label: 'Description',
            hintText: 'Enter description',
            initialValue: item['description'],
            onChanged: (val) => _updateItem(index, 'description', val),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Qty',
                  hintText: 'Quantity',
                  keyboardType: TextInputType.number,
                  initialValue: item['qty'].toString(),
                  onChanged: (val) => _updateItem(index, 'qty', double.tryParse(val) ?? 0.0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppTextField(
                  label: 'Rate',
                  hintText: 'Price',
                  keyboardType: TextInputType.number,
                  initialValue: item['rate'].toString(),
                  onChanged: (val) => _updateItem(index, 'rate', double.tryParse(val) ?? 0.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppSmartDropdown<Map<String, dynamic>>(
                  label: 'Tax',
                  hintText: 'Select tax',
                  value: taxes.where((t) => t['id'] == item['tax_id']).firstOrNull,
                  items: taxes,
                  itemBuilder: (t) => (t['name'] ?? '').toString(),
                  onChanged: (val) => _updateItem(index, 'tax_id', val?['id']),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppTextField(
                  label: 'Subtotal',
                  readOnly: true,
                  initialValue: (item['subtotal'] as num).toStringAsFixed(2),
                ),
              ),
            ],
          ),
          if (widget.showPeriod) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Period Start',
                    hintText: 'YYYY-MM-DD',
                    initialValue: item['period_start'],
                    onChanged: (val) => _updateItem(index, 'period_start', val),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTextField(
                    label: 'Period End',
                    hintText: 'YYYY-MM-DD',
                    initialValue: item['period_end'],
                    onChanged: (val) => _updateItem(index, 'period_end', val),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
