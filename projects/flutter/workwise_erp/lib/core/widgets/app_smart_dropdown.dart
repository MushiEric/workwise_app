import 'package:flutter/material.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';

class AppSmartDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemBuilder;
  final String label;
  final void Function(T?) onChanged;
  final String? hintText;
  final bool enabled;
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
    this.backgroundColor,
    this.borderRadius = 16,
    this.borderColor,
  });

  @override
  State<AppSmartDropdown<T>> createState() => _AppSmartDropdownState<T>();
}

class _AppSmartDropdownState<T> extends State<AppSmartDropdown<T>> {
  void _showSelectionDialog(BuildContext context) async {
    if (!widget.enabled) return;

    final result = await showDialog<T>(
      context: context,
      builder: (ctx) => _SelectionDialog<T>(
        items: widget.items,
        itemBuilder: widget.itemBuilder,
        label: widget.label,
      ),
    );

    if (result != null) {
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.value != null
        ? widget.itemBuilder(widget.value as T)
        : (widget.hintText ?? 'Select ${widget.label}');

    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        filled: widget.backgroundColor != null,
        fillColor: widget.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).dividerColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).dividerColor,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      child: Text(
        displayText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: widget.value == null ? Theme.of(context).hintColor : null,
        ),
      ),
    );
  }
}

class _SelectionDialog<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemBuilder;
  final String label;

  const _SelectionDialog({
    required this.items,
    required this.itemBuilder,
    required this.label,
  });

  @override
  State<_SelectionDialog<T>> createState() => _SelectionDialogState<T>();
}

class _SelectionDialogState<T> extends State<_SelectionDialog<T>> {
  final _searchController = TextEditingController();
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          return widget
              .itemBuilder(item)
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showSearch = widget.items.length > 10;

    return AlertDialog(
      title: Text('Select ${widget.label}'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showSearch)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: AppSearchField(
                  controller: _searchController,
                  hintText: 'Search ${widget.label}...',
                  onChanged: _filterItems,
                  onClear: () => _filterItems(''),
                ),
              ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (ctx, index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    title: Text(widget.itemBuilder(item)),
                    onTap: () => Navigator.of(ctx).pop(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
