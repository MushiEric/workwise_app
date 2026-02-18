import 'package:flutter/material.dart';
import '../../../../core/widgets/app_textfield.dart';
import '../../../../core/themes/app_colors.dart';

class SearchableDialog<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemDisplay;
  final T? initialValue;
  final List<T>? initialMultiValue;
  final bool multiSelect;
  final ValueChanged<T?>? onSelected;
  final ValueChanged<List<T>>? onMultiSelected;

  const SearchableDialog({
    super.key,
    required this.title,
    required this.items,
    required this.itemDisplay,
    this.initialValue,
    this.initialMultiValue,
    this.multiSelect = false,
    this.onSelected,
    this.onMultiSelected,
  });

  @override
  State<SearchableDialog<T>> createState() => _SearchableDialogState<T>();
}

class _SearchableDialogState<T> extends State<SearchableDialog<T>> {
  final _searchController = TextEditingController();
  List<T> _filteredItems = [];
  T? _selectedItem;
  Set<T> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    if (widget.multiSelect) {
      _selectedItems.addAll(widget.initialMultiValue ?? []);
    } else {
      _selectedItem = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() => _filteredItems = widget.items);
    } else {
      setState(() {
        _filteredItems = widget.items.where((item) {
          final display = widget.itemDisplay(item).toLowerCase();
          return display.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Search Field
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppTextField(
                controller: _searchController,
                labelText: 'Search',
                hintText: 'Type to search...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                onChanged: _filterItems,
                // filled: true,
              ),
            ),

            // Items List
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: isDark ? Colors.white24 : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No items found',
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final displayText = widget.itemDisplay(item);
                        final isSelected = widget.multiSelect
                            ? _selectedItems.contains(item)
                            : _selectedItem == item;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? primaryColor.withOpacity(0.1)
                                : null,
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor.withOpacity(0.2)
                                    : (isDark ? Colors.white10 : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                widget.multiSelect
                                    ? (isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded)
                                    : (isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded),
                                size: 18,
                                color: isSelected ? primaryColor : (isDark ? Colors.white54 : Colors.grey.shade600),
                              ),
                            ),
                            title: Text(
                              displayText,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected
                                    ? primaryColor
                                    : (isDark ? Colors.white : const Color(0xFF1A2634)),
                              ),
                            ),
                            onTap: () {
                              if (widget.multiSelect) {
                                setState(() {
                                  if (_selectedItems.contains(item)) {
                                    _selectedItems.remove(item);
                                  } else {
                                    _selectedItems.add(item);
                                  }
                                });
                              } else {
                                setState(() => _selectedItem = item);
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),

            // Footer
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.multiSelect) {
                        widget.onMultiSelected?.call(_selectedItems.toList());
                      } else {
                        widget.onSelected?.call(_selectedItem);
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}