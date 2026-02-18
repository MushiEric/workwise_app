import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_textfield.dart';
import '../../../../core/widgets/app_smart_dropdown.dart';
import '../../../../core/themes/app_colors.dart';
import 'searchable_dialog.dart';

class ItemsList extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final num grandTotal;
  final Function(List<Map<String, dynamic>>) onItemsChanged;
  final VoidCallback onAddItem;

  // optional catalogs passed from parent
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> productUnits;
  final List<Map<String, dynamic>> services;

  const ItemsList({
    super.key,
    required this.items,
    required this.grandTotal,
    required this.onItemsChanged,
    required this.onAddItem,
    this.products = const [],
    this.productUnits = const [],
    this.services = const [],
  });

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  void _showAddItemDialog() {
    final nameCtl = TextEditingController();
    final qtyCtl = TextEditingController(text: '1');
    final priceCtl = TextEditingController(text: '0');
    int? selectedProductId;
    int? selectedServiceId;
    int? selectedUnitId;
    // no more 'manual' mode — prefer product then service
    String mode = widget.products.isNotEmpty ? 'product' : (widget.services.isNotEmpty ? 'service' : 'product');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    bool _isServiceItem(Map<String, dynamic>? m) {
      if (m == null) return false;
      final t = (m['type'] ?? m['item_type'] ?? '').toString().toLowerCase();
      return t.contains('service');
    }

    final productCandidates = widget.products.where((m) => !_isServiceItem(m)).toList();
    final serviceCandidates = [
      ...widget.services,
      ...widget.products.where((m) => _isServiceItem(m)),
    ].where((m) => m.isNotEmpty).toList();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(20),
          child: StatefulBuilder(builder: (ctx, setInner) {
            void selectProduct(Map<String, dynamic>? p) {
              if (p == null) return;
              selectedProductId = (p['id'] is int) ? p['id'] as int : int.tryParse(p['id']?.toString() ?? '');
              nameCtl.text = p['name']?.toString() ?? p['title']?.toString() ?? '';
              // try common price fields
              final price = p['sale_price'] ?? p['price'] ?? p['unit_price'] ?? 0;
              priceCtl.text = price?.toString() ?? '0';
              // unit if present
              selectedUnitId = p['unit_id'] is int ? p['unit_id'] as int : int.tryParse(p['unit_id']?.toString() ?? '');
            }

            void selectService(Map<String, dynamic>? s) {
              if (s == null) return;
              selectedServiceId = (s['id'] is int) ? s['id'] as int : int.tryParse(s['id']?.toString() ?? '');
              nameCtl.text = s['name']?.toString() ?? '';
              priceCtl.text = (s['price'] ?? 0).toString();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_2_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('Add Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(icon: Icon(Icons.close_rounded, color: isDark ? Colors.white54 : Colors.grey.shade600), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),

                const SizedBox(height: 12),

                // Mode selector
                Row(children: [
                  ChoiceChip(label: const Text('Product'), selected: mode == 'product', onSelected: (_) => setInner(() => mode = 'product')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Service'), selected: mode == 'service', onSelected: (_) => setInner(() => mode = 'service')),
                ]),

                const SizedBox(height: 12),

                if (mode == 'product')
                  Column(children: [
                    // product selector (searchable)
                    GestureDetector(
                      onTap: () async {
                        if (productCandidates.isEmpty) return;
                        final picked = await showDialog<Map<String, dynamic>?>(
                          context: context,
                          builder: (_) => SearchableDialog<Map<String, dynamic>>(
                            title: 'Select product',
                            items: productCandidates,
                            itemDisplay: (m) => (m['name'] ?? m['title'] ?? m['sku'] ?? 'Product').toString(),
                            onSelected: (_) {},
                          ),
                        );
                        if (picked != null) setInner(() => selectProduct(picked));
                      },
                      child: AbsorbPointer(
                        child: AppTextField(
                          controller: TextEditingController(text: nameCtl.text),
                          labelText: 'Product (tap to choose)',
                          prefixIcon: Icon(Icons.build_rounded, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
                        child: AppTextField(controller: qtyCtl, labelText: 'Quantity', keyboardType: TextInputType.number, prefixIcon: Icon(Icons.numbers_rounded, size: 18)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(controller: priceCtl, labelText: 'Price', keyboardType: TextInputType.number, prefixIcon: Icon(Icons.attach_money_rounded, size: 18)),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    // unit selector
                    if (widget.productUnits.isNotEmpty)
                      AppSmartDropdown<int>(
                        value: selectedUnitId,
                        items: widget.productUnits.map((u) => int.tryParse(u['id']?.toString() ?? '') ?? 0).where((id) => id > 0).toList(),
                        itemBuilder: (id) {
                          final u = widget.productUnits.firstWhere((e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == id, orElse: () => {});
                          return u.isNotEmpty ? (u['name'] ?? u['short_name'] ?? 'Unit $id') : 'Unit $id';
                        },
                        label: 'Unit (optional)',
                        onChanged: (v) => setInner(() => selectedUnitId = v),
                      ),
                  ])

                else if (mode == 'service')
                  Column(children: [
                    GestureDetector(
                      onTap: () async {
                        if (serviceCandidates.isEmpty) return;
                        // dedupe by id (preserve first occurrence)
                        final seen = <String>{};
                        final dedup = <Map<String, dynamic>>[];
                        for (final m in serviceCandidates) {
                          final key = (m['id'] ?? m['name'] ?? m['title'])?.toString() ?? '';
                          if (key.isEmpty || seen.contains(key)) continue;
                          seen.add(key);
                          dedup.add(m);
                        }

                        final picked = await showDialog<Map<String, dynamic>?>(
                          context: context,
                          builder: (_) => SearchableDialog<Map<String, dynamic>>(
                            title: 'Select service',
                            items: dedup,
                            itemDisplay: (m) => (m['name'] ?? m['title'] ?? 'Service').toString(),
                            onSelected: (_) {},
                          ),
                        );
                        if (picked != null) setInner(() => selectService(picked));
                      },
                      child: AbsorbPointer(
                        child: AppTextField(controller: TextEditingController(text: nameCtl.text), labelText: 'Service (tap to choose)', prefixIcon: Icon(Icons.build_circle_rounded, size: 18)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(controller: qtyCtl, labelText: 'Quantity', keyboardType: TextInputType.number, prefixIcon: Icon(Icons.numbers_rounded, size: 18)),
                    const SizedBox(height: 8),
                    AppTextField(controller: priceCtl, labelText: 'Price', keyboardType: TextInputType.number, prefixIcon: Icon(Icons.attach_money_rounded, size: 18)),
                  ])

                else
                  const SizedBox.shrink(),

                const SizedBox(height: 14),

                Row(children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Cancel'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () {
                    final name = nameCtl.text.trim();
                    final qty = int.tryParse(qtyCtl.text) ?? 1;
                    final price = num.tryParse(priceCtl.text) ?? 0;

                    if (mode == 'product' && selectedProductId != null && name.isNotEmpty) {
                      widget.onItemsChanged([...widget.items, {'item_id': selectedProductId, 'item_name': name, 'qty': qty, 'price': price, if (selectedUnitId != null) 'unit_id': selectedUnitId}]);
                    } else if (mode == 'service' && selectedServiceId != null && name.isNotEmpty) {
                      widget.onItemsChanged([...widget.items, {'service_id': selectedServiceId, 'item_name': name, 'qty': qty, 'price': price}]);
                    }

                    Navigator.pop(ctx);
                  }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Add'))),
                ]),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shopping_cart_rounded,
                    size: 16,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Items',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.items.length} item${widget.items.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items list
          if (widget.items.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No items added',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: widget.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final total = (item['qty'] as int) * (item['price'] as num);
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['item_name'] ?? 'Item',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isDark ? Colors.white : const Color(0xFF1A2634),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Qty: ${item['qty']}${item['unit'] != null ? ' ${item['unit']}' : ''} × ${item['price']} = ${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white54 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: Colors.red.shade300,
                        ),
                        onPressed: () {
                          final newList = List<Map<String, dynamic>>.from(widget.items)
                            ..removeAt(index);
                          widget.onItemsChanged(newList);
                        },
                        splashRadius: 20,
                      ),
                    ],
                  ),
                );
              },
            ),

          // Add button and total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                AppButton(
                  text: 'Add Item',
                  icon: Icons.add_rounded,
                  onPressed: _showAddItemDialog,
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.small,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Grand Total',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      widget.grandTotal.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}