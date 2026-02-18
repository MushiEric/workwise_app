import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_smart_dropdown.dart';
import '../../../../core/themes/app_colors.dart';
import 'searchable_dialog.dart';

class ReceiverSelector extends ConsumerStatefulWidget {
  final String? receiverType;
  final int? receiverId;
  final List<Map<String, dynamic>> receivers;
  final Function(String?) onTypeChanged;
  final Function(int?) onIdChanged;

  const ReceiverSelector({
    super.key,
    required this.receiverType,
    required this.receiverId,
    required this.receivers,
    required this.onTypeChanged,
    required this.onIdChanged,
  });

  @override
  ConsumerState<ReceiverSelector> createState() => _ReceiverSelectorState();
}

class _ReceiverSelectorState extends ConsumerState<ReceiverSelector> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 16,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Receiver Information',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Receiver Type
          AppSmartDropdown<String>(
            value: widget.receiverType,
            items: const ['user', 'customer', 'vendor', 'employee'],
            itemBuilder: (item) => item.toUpperCase(),
            label: 'Receiver Type',
            onChanged: widget.onTypeChanged,
          ),
          
          const SizedBox(height: 12),
          
          // Receiver selection
          if (widget.receiverType != null && widget.receivers.isNotEmpty) ...[
            AppButton(
              text: widget.receiverId == null
                  ? 'Select Receiver'
                  : 'Change Receiver',
              icon: Icons.person_search_rounded,
              onPressed: () async {
                final selected = await showDialog<int?>(
                  context: context,
                  builder: (ctx) => SearchableDialog<int>(
                    title: 'Select Receiver',
                    items: widget.receivers.map((r) => int.tryParse(r['id']?.toString() ?? '') ?? 0).where((id) => id > 0).toList(),
                    itemDisplay: (id) {
                      final r = widget.receivers.firstWhere(
                        (e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == id,
                        orElse: () => {},
                      );
                      return r.isNotEmpty ? (r['name'] ?? r['title'] ?? 'Receiver $id') : 'Receiver $id';
                    },
                    initialValue: widget.receiverId,
                    onSelected: (selected) => widget.onIdChanged(selected),
                  ),
                );
              },
              variant: widget.receiverId == null ? AppButtonVariant.primary : AppButtonVariant.outline,
              size: AppButtonSize.small,
              fullWidth: true,
            ),
            
            if (widget.receiverId != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.receivers.firstWhere(
                          (e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == widget.receiverId,
                          orElse: () => {'name': 'Selected'}
                        )['name'] ?? 'Receiver selected',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}