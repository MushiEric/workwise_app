import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_textfields.dart';
import '../../../../core/widgets/app_smart_dropdown.dart';
import '../../../../core/themes/app_colors.dart';
import 'searchable_dialog.dart';

class ItemsList extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final num grandTotal;
  final Function(List<Map<String, dynamic>>) onItemsChanged;
  final VoidCallback onAddItem;

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
  void _showAddItemSheet() {
    final nameCtl = TextEditingController();
    final qtyCtl = TextEditingController(text: '1');
    final descriptionCtl = TextEditingController();
    int? selectedProductId;
    int? selectedServiceId;
    int? selectedUnitId;
    bool qtyEntered = true;
    List<PlatformFile> attachments = [];

    String mode = widget.products.isNotEmpty
        ? 'product'
        : (widget.services.isNotEmpty ? 'service' : 'product');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    bool isServiceItem(Map<String, dynamic>? m) {
      if (m == null) return false;
      final t = (m['type'] ?? m['item_type'] ?? '').toString().toLowerCase();
      return t.contains('service');
    }

    final productCandidates = widget.products
        .where((m) => !isServiceItem(m))
        .toList();
    final serviceCandidates = [
      ...widget.services,
      ...widget.products.where((m) => isServiceItem(m)),
    ].where((m) => m.isNotEmpty).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: StatefulBuilder(
                    builder: (ctx, setInner) {
                      void selectProduct(Map<String, dynamic>? p) {
                        if (p == null) return;
                        selectedProductId = (p['id'] is int)
                            ? p['id'] as int
                            : int.tryParse(p['id']?.toString() ?? '');
                        nameCtl.text =
                            p['name']?.toString() ??
                            p['title']?.toString() ??
                            '';
                        selectedUnitId = p['unit_id'] is int
                            ? p['unit_id'] as int
                            : int.tryParse(p['unit_id']?.toString() ?? '');
                      }

                      void selectService(Map<String, dynamic>? s) {
                        if (s == null) return;
                        selectedServiceId = (s['id'] is int)
                            ? s['id'] as int
                            : int.tryParse(s['id']?.toString() ?? '');
                        nameCtl.text = s['name']?.toString() ?? '';
                      }

                      Future<void> pickAttachments() async {
                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                        );
                        if (result != null) {
                          setInner(
                            () =>
                                attachments = [...attachments, ...result.files],
                          );
                        }
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
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
                              const Text(
                                'Add Material',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey.shade600,
                                ),
                                onPressed: () => Navigator.pop(ctx),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Mode chips
                          Row(
                            children: [
                              ChoiceChip(
                                label: const Text('Material'),
                                selected: mode == 'product',
                                onSelected: (_) => setInner(() {
                                  mode = 'product';
                                  nameCtl.clear();
                                  selectedProductId = null;
                                  selectedServiceId = null;
                                }),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text('Service'),
                                selected: mode == 'service',
                                onSelected: (_) => setInner(() {
                                  mode = 'service';
                                  nameCtl.clear();
                                  selectedProductId = null;
                                  selectedServiceId = null;
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ── Material mode ────────────────────────────────
                          if (mode == 'product')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Material dropdown field
                                AppTextField(
                                  controller: nameCtl,
                                  label: 'Material',
                                  isRequired: true,
                                  isDropdown: true,
                                  onDropdownTap: productCandidates.isEmpty
                                      ? null
                                      : () {
                                          showDialog<void>(
                                            context: context,
                                            builder: (_) =>
                                                SearchableDialog<
                                                  Map<String, dynamic>
                                                >(
                                                  title: 'Select Material',
                                                  items: productCandidates,
                                                  itemDisplay: (m) =>
                                                      (m['name'] ??
                                                              m['title'] ??
                                                              m['sku'] ??
                                                              'Material')
                                                          .toString(),
                                                  onSelected: (item) {
                                                    if (item != null)
                                                      setInner(
                                                        () =>
                                                            selectProduct(item),
                                                      );
                                                  },
                                                ),
                                          );
                                        },
                                ),
                                // Show selected material chip
                                if (selectedProductId != null &&
                                    nameCtl.text.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Chip(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    label: Text(
                                      nameCtl.text,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.1),
                                    deleteIconColor: AppColors.primary,
                                    onDeleted: () => setInner(() {
                                      selectedProductId = null;
                                      nameCtl.clear();
                                    }),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                // Quantity + UOM row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        controller: qtyCtl,
                                        label: 'Quantity',
                                        isRequired: true,
                                        keyboardType: TextInputType.number,
                                        onChanged: (v) => setInner(
                                          () =>
                                              qtyEntered = v.trim().isNotEmpty,
                                        ),
                                      ),
                                    ),
                                    if (widget.productUnits.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: AppSmartDropdown<int>(
                                          value: selectedUnitId,
                                          enabled: qtyEntered,
                                          items: widget.productUnits
                                              .map(
                                                (u) =>
                                                    int.tryParse(
                                                      u['id']?.toString() ?? '',
                                                    ) ??
                                                    0,
                                              )
                                              .where((id) => id > 0)
                                              .toList(),
                                          itemBuilder: (id) {
                                            final u = widget.productUnits
                                                .firstWhere(
                                                  (e) =>
                                                      (int.tryParse(
                                                            e['id']?.toString() ??
                                                                '',
                                                          ) ??
                                                          0) ==
                                                      id,
                                                  orElse: () => {},
                                                );
                                            return u.isNotEmpty
                                                ? (u['name'] ??
                                                      u['short_name'] ??
                                                      'Unit $id')
                                                : 'Unit $id';
                                          },
                                          label: 'UOM',
                                          onChanged: (v) => setInner(
                                            () => selectedUnitId = v,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Attachments
                                _AttachmentField(
                                  attachments: attachments,
                                  isDark: isDark,
                                  onPick: pickAttachments,
                                  onRemove: (i) => setInner(
                                    () =>
                                        attachments = List.from(attachments)
                                          ..removeAt(i),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Description
                                AppTextField(
                                  controller: descriptionCtl,
                                  label: 'Description',
                                  hintText: 'Optional',
                                  maxLines: 2,
                                ),
                              ],
                            )
                          // ── Service mode ────────────────────────────────
                          else if (mode == 'service')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextField(
                                  controller: nameCtl,
                                  label: 'Service',
                                  isRequired: true,
                                  isDropdown: true,
                                  onDropdownTap: serviceCandidates.isEmpty
                                      ? null
                                      : () {
                                          final seen = <String>{};
                                          final dedup =
                                              <Map<String, dynamic>>[];
                                          for (final m in serviceCandidates) {
                                            final key =
                                                (m['id'] ??
                                                        m['name'] ??
                                                        m['title'])
                                                    ?.toString() ??
                                                '';
                                            if (key.isEmpty ||
                                                seen.contains(key))
                                              continue;
                                            seen.add(key);
                                            dedup.add(m);
                                          }
                                          showDialog<void>(
                                            context: context,
                                            builder: (_) =>
                                                SearchableDialog<
                                                  Map<String, dynamic>
                                                >(
                                                  title: 'Select Service',
                                                  items: dedup,
                                                  itemDisplay: (m) =>
                                                      (m['name'] ??
                                                              m['title'] ??
                                                              'Service')
                                                          .toString(),
                                                  onSelected: (item) {
                                                    if (item != null)
                                                      setInner(
                                                        () =>
                                                            selectService(item),
                                                      );
                                                  },
                                                ),
                                          );
                                        },
                                ),
                                // Show selected service chip
                                if (selectedServiceId != null &&
                                    nameCtl.text.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Chip(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    label: Text(
                                      nameCtl.text,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.1),
                                    deleteIconColor: AppColors.primary,
                                    onDeleted: () => setInner(() {
                                      selectedServiceId = null;
                                      nameCtl.clear();
                                    }),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: qtyCtl,
                                  label: 'Quantity',
                                  isRequired: true,
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => setInner(
                                    () => qtyEntered = v.trim().isNotEmpty,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Attachments
                                _AttachmentField(
                                  attachments: attachments,
                                  isDark: isDark,
                                  onPick: pickAttachments,
                                  onRemove: (i) => setInner(
                                    () =>
                                        attachments = List.from(attachments)
                                          ..removeAt(i),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: descriptionCtl,
                                  label: 'Description',
                                  hintText: 'Optional',
                                  maxLines: 2,
                                ),
                              ],
                            )
                          else
                            const SizedBox.shrink(),

                          const SizedBox(height: 14),

                          // Cancel / Add buttons
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final name = nameCtl.text.trim();
                                    final qty = int.tryParse(qtyCtl.text) ?? 1;
                                    final desc = descriptionCtl.text.trim();
                                    final files = attachments
                                        .map(
                                          (f) => {
                                            'name': f.name,
                                            'path': f.path ?? '',
                                          },
                                        )
                                        .toList();

                                    if (mode == 'product' &&
                                        selectedProductId != null &&
                                        name.isNotEmpty) {
                                      widget.onItemsChanged([
                                        ...widget.items,
                                        {
                                          'item_id': selectedProductId,
                                          'item_name': name,
                                          'qty': qty,
                                          if (selectedUnitId != null)
                                            'unit_id': selectedUnitId,
                                          if (desc.isNotEmpty)
                                            'description': desc,
                                          if (files.isNotEmpty)
                                            'attachments': files,
                                        },
                                      ]);
                                    } else if (mode == 'service' &&
                                        selectedServiceId != null &&
                                        name.isNotEmpty) {
                                      widget.onItemsChanged([
                                        ...widget.items,
                                        {
                                          'service_id': selectedServiceId,
                                          'item_name': name,
                                          'qty': qty,
                                          if (desc.isNotEmpty)
                                            'description': desc,
                                          if (files.isNotEmpty)
                                            'attachments': files,
                                        },
                                      ]);
                                    }
                                    Navigator.pop(ctx);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Add'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final effectiveBg = isDark
        ? const Color(0x1AFFFFFF)
        : const Color(0xFFF5F7FA);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row with inline "Add" action
        Row(
          children: [
            Text(
              'Materials',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : const Color(0xFF374151),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _showAddItemSheet,
              icon: Icon(Icons.add_rounded, size: 16, color: primaryColor),
              label: Text(
                'Add',
                style: TextStyle(fontSize: 13, color: primaryColor),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Items container — compact dropdown-style
        GestureDetector(
          onTap: widget.items.isEmpty ? _showAddItemSheet : null,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: effectiveBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: widget.items.isEmpty
                ? Row(
                    children: [
                      Text(
                        'Tap to add materials',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white38 : Colors.grey.shade400,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: 18,
                        color: isDark ? Colors.white24 : Colors.grey.shade400,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.items.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;
                      final files = item['attachments'] as List? ?? const [];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: i < widget.items.length - 1 ? 10 : 0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Index badge
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Item info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['item_name'] ?? 'Item',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1A2634),
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${item['qty']}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                  if (files.isNotEmpty)
                                    Text(
                                      '${files.length} file(s) attached',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: primaryColor,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Remove
                            GestureDetector(
                              onTap: () {
                                final newList = List<Map<String, dynamic>>.from(
                                  widget.items,
                                )..removeAt(i);
                                widget.onItemsChanged(newList);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Colors.red.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }
}

// ── Attachment picker field used inside the Add Material / Service sheet ──────
class _AttachmentField extends StatelessWidget {
  final List<PlatformFile> attachments;
  final bool isDark;
  final VoidCallback onPick;
  final void Function(int index) onRemove;

  const _AttachmentField({
    required this.attachments,
    required this.isDark,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Attachments',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        // Picker button
        GestureDetector(
          onTap: onPick,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0x1AFFFFFF) : const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.attach_file_rounded,
                  size: 18,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  attachments.isEmpty ? 'Choose files' : 'Add more files',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                  ),
                ),
                const Spacer(),
                if (attachments.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${attachments.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Selected file chips
        if (attachments.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...attachments.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 16,
                      color: primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        e.value.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF374151),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onRemove(e.key),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
