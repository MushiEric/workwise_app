import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_icons.dart';

/// A smart dropdown that renders its label ABOVE the tappable field (not as a
/// floating label inside the input box) and opens a searchable bottom sheet.
class AppSmartDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemBuilder;
  final String label;
  final void Function(T?) onChanged;
  final String? hintText;
  final bool enabled;
  final String? errorText;
  // style
  final Color? backgroundColor;
  final double borderRadius;
  final Color? borderColor;

  const AppSmartDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemBuilder,
    required this.label,
    required this.onChanged,
    this.hintText,
    this.enabled = true,
    this.errorText,
    this.backgroundColor,
    this.borderRadius = 12,
    this.borderColor,
  });

  @override
  State<AppSmartDropdown<T>> createState() => _AppSmartDropdownState<T>();
}

class _AppSmartDropdownState<T> extends State<AppSmartDropdown<T>> {
  Future<void> _openSheet() async {
    if (!widget.enabled) return;
    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SelectionBottomSheet<T>(
        items: widget.items,
        itemBuilder: widget.itemBuilder,
        label: widget.label,
        selectedValue: widget.value,
      ),
    );
    if (result != null) widget.onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasValue = widget.value != null;
    final hasError = widget.errorText != null;
    final displayText = hasValue
        ? widget.itemBuilder(widget.value as T)
        : (widget.hintText ?? 'Select ${widget.label.replaceAll(' *', '')}');

    final effectiveBg =
        widget.backgroundColor ??
        (isDark ? const Color(0x1AFFFFFF) : const Color(0xFFF5F7FA));

    // Strip trailing ' *' for display in label span, handle asterisk separately
    final labelBase = widget.label.endsWith(' *')
        ? widget.label.substring(0, widget.label.length - 2)
        : widget.label;
    final isRequired = widget.label.endsWith(' *');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label above field ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: hasError
                    ? Colors.red.shade400
                    : (isDark ? Colors.white70 : const Color(0xFF374151)),
              ),
              children: [
                TextSpan(text: labelBase),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red.shade400),
                  ),
              ],
            ),
          ),
        ),

        // ── Tappable field ────────────────────────────────────────────────
        GestureDetector(
          onTap: widget.enabled ? _openSheet : null,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.enabled
                  ? effectiveBg
                  : (isDark ? Colors.white12 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: hasError
                    ? Colors.red.shade400
                    : (widget.borderColor ??
                          (isDark ? Colors.white24 : Colors.grey.shade300)),
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
                      color: hasValue
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? Colors.white38 : Colors.grey.shade500),
                    ),
                  ),
                ),
                Icon(
                  AppIcons.arrowdropDown,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  size: 22,
                ),
              ],
            ),
          ),
        ),

        // ── Inline error ──────────────────────────────────────────────────
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 6),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 12, color: Colors.red.shade400),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.errorText!,
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

// ─── Bottom Sheet ─────────────────────────────────────────────────────────────

class _SelectionBottomSheet<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemBuilder;
  final String label;
  final T? selectedValue;

  const _SelectionBottomSheet({
    required this.items,
    required this.itemBuilder,
    required this.label,
    this.selectedValue,
  });

  @override
  State<_SelectionBottomSheet<T>> createState() =>
      _SelectionBottomSheetState<T>();
}

class _SelectionBottomSheetState<T> extends State<_SelectionBottomSheet<T>> {
  final _searchCtl = TextEditingController();
  late List<T> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  void _filter(String q) {
    setState(() {
      _filtered = q.isEmpty
          ? widget.items
          : widget.items.where((item) {
              return widget
                  .itemBuilder(item)
                  .toLowerCase()
                  .contains(q.toLowerCase());
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1A2234) : Colors.white;
    final showSearch = widget.items.length > 5;

    return DraggableScrollableSheet(
      initialChildSize: showSearch ? 0.75 : 0.55,
      minChildSize: 0.3,
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
            // Title row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select ${widget.label.replaceAll(' *', '')}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(ctx).pop(),
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            // Search
            if (showSearch)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchCtl,
                  onChanged: _filter,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.07)
                        : Colors.grey.shade100,
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
            // List
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No results',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollCtl,
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final item = _filtered[i];
                        final label = widget.itemBuilder(item);
                        final isSelected = item == widget.selectedValue;
                        return ListTile(
                          title: Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                        ? Colors.white70
                                        : Colors.grey.shade800),
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: AppColors.primary,
                                  size: 18,
                                )
                              : null,
                          onTap: () => Navigator.of(ctx).pop(item),
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
