import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../themes/app_colors.dart';
import 'app_textfield.dart';

/// Holds the active filter state returned by [DrawerFilter].
class DrawerFilterValue {
  final String? dateRangeType; // 'daily' | 'weekly' | 'monthly' | 'annually'
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final int? staffId;
  final String? staffName;
  final String? statusId;
  final String? statusName;

  const DrawerFilterValue({
    this.dateRangeType,
    this.dateFrom,
    this.dateTo,
    this.staffId,
    this.staffName,
    this.statusId,
    this.statusName,
  });

  bool get isEmpty =>
      dateRangeType == null &&
      dateFrom == null &&
      dateTo == null &&
      staffId == null &&
      statusId == null;

  DrawerFilterValue copyWith({
    String? dateRangeType,
    DateTime? dateFrom,
    DateTime? dateTo,
    int? staffId,
    String? staffName,
    String? statusId,
    String? statusName,
  }) {
    return DrawerFilterValue(
      dateRangeType: dateRangeType ?? this.dateRangeType,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      staffId: staffId ?? this.staffId,
      staffName: staffName ?? this.staffName,
      statusId: statusId ?? this.statusId,
      statusName: statusName ?? this.statusName,
    );
  }
}

/// Reusable right-side end-drawer filter panel.
///
/// Usage:
/// ```dart
/// Scaffold(
///   key: _scaffoldKey,
///   endDrawer: DrawerFilter(
///     users: _users,
///     statuses: _statuses,
///     initialValue: _activeFilter,
///     onApply: (v) => setState(() => _activeFilter = v),
///     onReset: () => setState(() => _activeFilter = null),
///   ),
/// )
/// // Open it:
/// _scaffoldKey.currentState?.openEndDrawer();
/// ```
class DrawerFilter extends StatefulWidget {
  /// List of users: each map should contain `id` (int or string) and `name`.
  final List<Map<String, dynamic>> users;

  /// List of statuses: each map should contain `id` (string), `name`, and optionally `color`.
  final List<Map<String, dynamic>> statuses;

  /// Pre-populate the filter with a previous value.
  final DrawerFilterValue? initialValue;

  /// Called when the user presses "Apply Filters". Also closes the drawer.
  final void Function(DrawerFilterValue) onApply;

  /// Called when the user presses "Reset". Also closes the drawer.
  final VoidCallback? onReset;

  const DrawerFilter({
    super.key,
    required this.users,
    required this.statuses,
    required this.onApply,
    this.initialValue,
    this.onReset,
  });

  @override
  State<DrawerFilter> createState() => _DrawerFilterState();
}

class _DrawerFilterState extends State<DrawerFilter> {
  String? _dateRangeType;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  int? _staffId;
  String? _staffName;
  String? _statusId;
  String? _statusName;

  final _dateFromCtrl = TextEditingController();
  final _dateToCtrl = TextEditingController();
  final _staffCtrl = TextEditingController();
  final _statusCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final v = widget.initialValue;
    if (v != null) {
      _dateRangeType = v.dateRangeType;
      _dateFrom = v.dateFrom;
      _dateTo = v.dateTo;
      _staffId = v.staffId;
      _staffName = v.staffName;
      _statusId = v.statusId;
      _statusName = v.statusName;
      _dateFromCtrl.text = _fmtDate(_dateFrom);
      _dateToCtrl.text = _fmtDate(_dateTo);
      _staffCtrl.text = _staffName ?? '';
      _statusCtrl.text = _statusName ?? '';
    }
  }

  @override
  void dispose() {
    _dateFromCtrl.dispose();
    _dateToCtrl.dispose();
    _staffCtrl.dispose();
    _statusCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  void _selectPreset(String type) {
    final now = DateTime.now();
    DateTime from, to;
    switch (type) {
      case 'daily':
        from = DateTime(now.year, now.month, now.day);
        to = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'weekly':
        final offset = now.weekday - 1; // Monday = 0
        from = DateTime(now.year, now.month, now.day - offset);
        to = DateTime(from.year, from.month, from.day + 6, 23, 59, 59);
        break;
      case 'monthly':
        from = DateTime(now.year, now.month, 1);
        to = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case 'annually':
        from = DateTime(now.year, 1, 1);
        to = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      default:
        return;
    }
    setState(() {
      _dateRangeType = type;
      _dateFrom = from;
      _dateTo = to;
      _dateFromCtrl.text = _fmtDate(from);
      _dateToCtrl.text = _fmtDate(to);
    });
  }

  Future<void> _pickDate(bool isFrom) async {
    final initial = isFrom
        ? (_dateFrom ?? DateTime.now())
        : (_dateTo ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _dateFrom = picked;
        _dateFromCtrl.text = _fmtDate(picked);
      } else {
        _dateTo = picked;
        _dateToCtrl.text = _fmtDate(picked);
      }
      _dateRangeType = null; // manual selection overrides preset
    });
  }

  Future<void> _pickStaff() async {
    if (widget.users.isEmpty) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            maxChildSize: 0.85,
            builder: (_, controller) => Column(
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    'Select Staff',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: widget.users.length,
                    itemBuilder: (_, i) {
                      final u = widget.users[i];
                      final id = int.tryParse(u['id']?.toString() ?? '');
                      final name = u['name']?.toString() ?? '';
                      final selected = id == _staffId;
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: selected
                                ? AppColors.primary
                                : (isDark
                                      ? Colors.white
                                      : const Color(0xFF1A2634)),
                          ),
                        ),
                        trailing: selected
                            ? Icon(
                                LucideIcons.checkCircle,
                                color: AppColors.primary,
                                size: 18.r,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _staffId = id;
                            _staffName = name;
                            _staffCtrl.text = name;
                          });
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickStatus() async {
    if (widget.statuses.isEmpty) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.4,
            maxChildSize: 0.8,
            builder: (_, controller) => Column(
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    'Select Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: widget.statuses.length,
                    itemBuilder: (_, i) {
                      final s = widget.statuses[i];
                      final id = s['id']?.toString() ?? '';
                      final name = s['name']?.toString() ?? '';
                      final colorHex = s['color']?.toString();
                      final selected = id == _statusId;
                      return ListTile(
                        leading: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _hexColor(colorHex),
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: selected
                                ? AppColors.primary
                                : (isDark
                                      ? Colors.white
                                      : const Color(0xFF1A2634)),
                          ),
                        ),
                        trailing: selected
                            ? Icon(
                                LucideIcons.checkCircle,
                                color: AppColors.primary,
                                size: 18.r,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _statusId = id;
                            _statusName = name;
                            _statusCtrl.text = name;
                          });
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _hexColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.primary;
    try {
      final h = hex.trim().replaceFirst('#', '');
      if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
      return Color(int.parse(h, radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  void _reset() {
    setState(() {
      _dateRangeType = null;
      _dateFrom = null;
      _dateTo = null;
      _staffId = null;
      _staffName = null;
      _statusId = null;
      _statusName = null;
      _dateFromCtrl.clear();
      _dateToCtrl.clear();
      _staffCtrl.clear();
      _statusCtrl.clear();
    });
    widget.onReset?.call();
    Navigator.pop(context);
  }

  void _apply() {
    widget.onApply(
      DrawerFilterValue(
        dateRangeType: _dateRangeType,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        staffId: _staffId,
        staffName: _staffName,
        statusId: _statusId,
        statusName: _statusName,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF151A2E) : Colors.white;
    final cardColor = bgColor;
    final labelColor = isDark ? Colors.white60 : Colors.grey.shade600;

    return Drawer(
      width: 0.85.sw,
      backgroundColor: bgColor,
      child: Column(
        children: [
          // ── Header (match support drawer style exactly) ──
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.h,
              bottom: 16.h,
              left: 20.w,
              right: 12.w,
            ),
            color: isDark ? const Color(0xFF0A0E21) : AppColors.primary,
            child: Row(
              children: [
                Icon(LucideIcons.filter, size: 18.r, color: Colors.white70),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Filter Jobcards',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // ── Scrollable body ───────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Date Range Presets ────────────────────────────
                  _sectionLabel('Date Range', labelColor),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: const ['Daily', 'Weekly', 'Monthly', 'Annually']
                        .map((label) {
                          final key = label.toLowerCase();
                          final active = _dateRangeType == key;
                          return GestureDetector(
                            onTap: () => _selectPreset(key),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primary.withOpacity(0.12)
                                    : (isDark
                                          ? Colors.white.withOpacity(0.05)
                                          : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: active
                                      ? AppColors.primary
                                      : (isDark
                                            ? Colors.white24
                                            : Colors.grey.shade300),
                                  width: active ? 1.5 : 1,
                                ),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: active
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: active
                                      ? AppColors.primary
                                      : (isDark
                                            ? Colors.white70
                                            : Colors.grey.shade700),
                                ),
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                  SizedBox(height: 20.h),

                  // ── Date From ─────────────────────────────────────
                  _sectionLabel('Date From', labelColor),
                  SizedBox(height: 8.h),
                  AppTextField(
                    controller: _dateFromCtrl,
                    hintText: 'Select start date',
                    readOnly: true,
                    onTap: () => _pickDate(true),
                    prefixIcon: Icon(
                      LucideIcons.calendar,
                      size: 16.r,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                    suffixIcon: _dateFrom != null
                        ? IconButton(
                            icon: Icon(
                              LucideIcons.x,
                              size: 14.r,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() {
                              _dateFrom = null;
                              _dateFromCtrl.clear();
                              _dateRangeType = null;
                            }),
                          )
                        : Icon(
                            Icons.arrow_drop_down,
                            size: 22.r,
                            color: Colors.grey,
                          ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Date To ───────────────────────────────────────
                  _sectionLabel('Date To', labelColor),
                  SizedBox(height: 8.h),
                  AppTextField(
                    controller: _dateToCtrl,
                    hintText: 'Select end date',
                    readOnly: true,
                    onTap: () => _pickDate(false),
                    prefixIcon: Icon(
                      LucideIcons.calendar,
                      size: 16.r,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                    suffixIcon: _dateTo != null
                        ? IconButton(
                            icon: Icon(
                              LucideIcons.x,
                              size: 14.r,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() {
                              _dateTo = null;
                              _dateToCtrl.clear();
                              _dateRangeType = null;
                            }),
                          )
                        : Icon(
                            Icons.arrow_drop_down,
                            size: 22.r,
                            color: Colors.grey,
                          ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Staff ─────────────────────────────────────────
                  _sectionLabel('Staff', labelColor),
                  SizedBox(height: 8.h),
                  AppTextField(
                    controller: _staffCtrl,
                    hintText: widget.users.isEmpty
                        ? 'Loading staff...'
                        : 'Select staff member',
                    readOnly: true,
                    enabled: widget.users.isNotEmpty,
                    onTap: _pickStaff,
                    prefixIcon: Icon(
                      LucideIcons.user,
                      size: 16.r,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                    suffixIcon: _staffId != null
                        ? IconButton(
                            icon: Icon(
                              LucideIcons.x,
                              size: 14.r,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() {
                              _staffId = null;
                              _staffName = null;
                              _staffCtrl.clear();
                            }),
                          )
                        : Icon(
                            Icons.arrow_drop_down,
                            size: 22.r,
                            color: Colors.grey,
                          ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Status ────────────────────────────────────────
                  _sectionLabel('Status', labelColor),
                  SizedBox(height: 8.h),
                  AppTextField(
                    controller: _statusCtrl,
                    hintText: widget.statuses.isEmpty
                        ? 'Loading statuses...'
                        : 'Select status',
                    readOnly: true,
                    enabled: widget.statuses.isNotEmpty,
                    onTap: _pickStatus,
                    prefixIcon: Icon(
                      LucideIcons.tag,
                      size: 16.r,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                    suffixIcon: _statusId != null
                        ? IconButton(
                            icon: Icon(
                              LucideIcons.x,
                              size: 14.r,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() {
                              _statusId = null;
                              _statusName = null;
                              _statusCtrl.clear();
                            }),
                          )
                        : Icon(
                            Icons.arrow_drop_down,
                            size: 22.r,
                            color: Colors.grey,
                          ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // ── Footer buttons ────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      side: BorderSide(color: Colors.grey.shade400),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text('Reset', style: TextStyle(fontSize: 14.sp)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _apply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.8,
      ),
    );
  }
}
