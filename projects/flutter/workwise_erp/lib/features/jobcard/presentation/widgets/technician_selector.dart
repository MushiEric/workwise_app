import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';

/// Dropdown-style staff selector (label above, grey field, chevron).
/// On tap opens a searchable multi-select bottom sheet.
class TechnicianSelector extends StatelessWidget {
  final List<int> selectedIds;
  final List<Map<String, dynamic>> users;
  final Function(List<int>) onChanged;
  final String? errorText;

  const TechnicianSelector({
    super.key,
    required this.selectedIds,
    required this.users,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = errorText != null;

    // Build display text
    String displayText;
    if (selectedIds.isEmpty) {
      displayText = 'Tap to select staff';
    } else {
      final names = selectedIds.map((id) {
        final u = users.firstWhere(
          (e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == id,
          orElse: () => {},
        );
        return u.isNotEmpty
            ? (u['name'] ?? u['username'] ?? 'Staff $id').toString()
            : 'Staff $id';
      }).toList();
      displayText = names.length <= 2
          ? names.join(', ')
          : '${names.take(2).join(', ')} +${names.length - 2} more';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label above field ────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'Assigned Staff',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              color: hasError
                  ? Colors.red.shade400
                  : (isDark ? Colors.white70 : const Color(0xFF374151)),
            ),
          ),
        ),

        // ── Tappable field ────────────────────────────────────────────
        GestureDetector(
          onTap: () async {
            final selected = await showModalBottomSheet<List<int>>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) =>
                  _StaffPickerSheet(users: users, selectedIds: selectedIds),
            );
            if (selected != null) onChanged(selected);
          },
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0x1AFFFFFF) : const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? Colors.red.shade400
                    : (isDark ? Colors.white24 : Colors.grey.shade300),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: selectedIds.isEmpty
                          ? (isDark ? Colors.white38 : Colors.grey.shade500)
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  size: 22,
                ),
              ],
            ),
          ),
        ),

        // ── Inline error ──────────────────────────────────────────────
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 6),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 12, color: Colors.red.shade400),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText!,
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Staff Picker Bottom Sheet ────────────────────────────────────────────────

class _StaffPickerSheet extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<int> selectedIds;

  const _StaffPickerSheet({required this.users, required this.selectedIds});

  @override
  State<_StaffPickerSheet> createState() => _StaffPickerSheetState();
}

class _StaffPickerSheetState extends State<_StaffPickerSheet> {
  final _searchCtl = TextEditingController();
  late List<Map<String, dynamic>> _filtered;
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _filtered = widget.users;
    _selected = Set.from(widget.selectedIds);
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  void _filter(String q) {
    setState(() {
      _filtered = q.isEmpty
          ? widget.users
          : widget.users.where((u) {
              final name = (u['name'] ?? u['username'] ?? '')
                  .toString()
                  .toLowerCase();
              return name.contains(q.toLowerCase());
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1A2234) : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (ctx, scrollCtl) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title + Done
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Staff',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(_selected.toList()),
                    child: Text(
                      'Done (${_selected.length})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchCtl,
                onChanged: _filter,
                decoration: InputDecoration(
                  hintText: 'Search staff...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.greyFill
                      : AppColors.greyFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            // List with checkboxes
            Expanded(
              child: ListView.builder(
                controller: scrollCtl,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final u = _filtered[i];
                  final id = int.tryParse(u['id']?.toString() ?? '') ?? 0;
                  final name = (u['name'] ?? u['username'] ?? 'Staff $id')
                      .toString();
                  final isChecked = _selected.contains(id);
                  return CheckboxListTile(
                    value: isChecked,
                    onChanged: (v) {
                      setState(() {
                        if (v == true) {
                          _selected.add(id);
                        } else {
                          _selected.remove(id);
                        }
                      });
                    },
                    title: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey.shade800,
                      ),
                    ),
                    activeColor: AppColors.primary,
                    controlAffinity: ListTileControlAffinity.trailing,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
