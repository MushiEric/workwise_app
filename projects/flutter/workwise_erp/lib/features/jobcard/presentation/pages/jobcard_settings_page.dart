import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/themes/app_icons.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../providers/jobcard_providers.dart';
import '../../../../core/widgets/app_bar.dart';

class JobcardSettingsPage extends ConsumerStatefulWidget {
  const JobcardSettingsPage({super.key});

  @override
  ConsumerState<JobcardSettingsPage> createState() =>
      _JobcardSettingsPageState();
}

class _JobcardSettingsPageState extends ConsumerState<JobcardSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final configAsync = ref.watch(jobcardConfigProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: 'Jobcard Settings',
          actions: [
            IconButton(
              icon: const Icon(AppIcons.refreshRounded),
              color: AppColors.white,
              tooltip: 'Refresh',
              onPressed: () => ref.invalidate(jobcardConfigProvider),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(isDark),
        body: configAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _buildError(isDark, err.toString()),
          data: (config) =>
              config.isEmpty ? _buildEmpty(isDark) : _buildSettings(isDark, config),
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, -3)),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: 1,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDark ? Colors.white60 : Colors.grey.shade600,
          showUnselectedLabels: false,
          selectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(icon: Icon(AppIcons.file), label: 'List'),
            BottomNavigationBarItem(
                icon: Icon(AppIcons.settings), label: 'Settings'),
          ],
          onTap: (idx) {
            if (idx == 0) Navigator.pushReplacementNamed(context, '/jobcards');
          },
        ),
      ),
    );
  }

  Widget _buildError(bool isDark, String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(AppIcons.errorOutlineRounded,
                  size: 48, color: Colors.red.shade300),
            ),
            const SizedBox(height: 24),
            Text('Failed to load settings',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634))),
            const SizedBox(height: 8),
            Text(msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade600)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(AppIcons.refreshRounded),
              label: const Text('Retry'),
              onPressed: () => ref.invalidate(jobcardConfigProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.settingsOutlined,
              size: 64,
              color: isDark ? Colors.white24 : Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No settings found',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildSettings(bool isDark, Map<String, dynamic> cfg) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(jobcardConfigProvider),
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            isDark: isDark,
            title: 'General',
            children: [
              _textRow(isDark, 'JobCard Prefix',
                  cfg['jobcard_prefix']?.toString() ?? '—'),
              _divider(isDark),
              _boolRow(isDark, 'Enable Reminder', cfg['enable_reminder']),
              _divider(isDark),
              _textRow(isDark, 'Reminder After (days)',
                  cfg['reminder_after']?.toString() ?? '—'),
              _divider(isDark),
              _chipRow(isDark, 'Remind On Status', cfg['remind_on_status']),
              _divider(isDark),
              _chipRow(isDark, 'Notification On Status',
                  cfg['notification_on_status']),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            isDark: isDark,
            title: 'Features',
            children: [
              _boolRow(isDark, 'Enable Machine', cfg['enable_machine']),
              _divider(isDark),
              _boolRow(isDark, 'Separate Product & Services',
                  cfg['separate_product_services']),
              _divider(isDark),
              _boolRow(isDark, 'Enable Location', cfg['enable_location']),
              _divider(isDark),
              _boolRow(isDark, 'Enable Quantity', cfg['enable_quantity']),
              _divider(isDark),
              _boolRow(isDark, 'Enable Department', cfg['enable_department']),
              _divider(isDark),
              _boolRow(isDark, 'Enable PFI', cfg['enable_pfi']),
              _divider(isDark),
              _boolRow(isDark, 'Show General Attachment',
                  cfg['show_general_attachment']),
              _divider(isDark),
              _boolRow(isDark, 'Show Assigned', cfg['show_assigned']),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            isDark: isDark,
            title: 'Approval & Status',
            children: [
              _boolRow(isDark, 'Show Approval/Reject or Completion',
                  cfg['show_approval_reject_or_completion']),
              _divider(isDark),
              _boolRow(isDark, 'Disable Edit/Delete After Approval',
                  cfg['disable_edit_delete_after_approval']),
              _divider(isDark),
              _textRow(isDark, 'After Reject Status',
                  cfg['after_reject_status']?.toString() ?? '—'),
              _divider(isDark),
              _textRow(isDark, 'Next Status After Approval',
                  cfg['next_status_after_approval']?.toString() ?? '—'),
              _divider(isDark),
              _textRow(
                  isDark,
                  'Next Status After Completion',
                  cfg['next_status_after_jobcard_completion']?.toString() ??
                      '—'),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            isDark: isDark,
            title: 'Jobcard Number Format',
            children: [
              _numberFormatRow(isDark, cfg['jobcard_number_format']),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ── Card wrapper ──────────────────────────────────────────────────────────

  Widget _sectionCard({
    required bool isDark,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: children)),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) => Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: isDark ? Colors.white10 : Colors.grey.shade100,
      );

  // ── Plain text row ────────────────────────────────────────────────────────

  Widget _textRow(bool isDark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    color:
                        isDark ? Colors.white70 : const Color(0xFF1A2634))),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      isDark ? Colors.white : const Color(0xFF1A2634))),
        ],
      ),
    );
  }

  // ── Boolean row (YES / NO read-only radio) ────────────────────────────────

  Widget _boolRow(bool isDark, String label, dynamic rawValue) {
    final isYes = _parseBool(rawValue);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    color:
                        isDark ? Colors.white70 : const Color(0xFF1A2634))),
          ),
          _RadioChip(
              label: 'Yes',
              selected: isYes,
              selectedColor: Colors.green,
              isDark: isDark),
          const SizedBox(width: 8),
          _RadioChip(
              label: 'No',
              selected: !isYes,
              selectedColor: Colors.red.shade400,
              isDark: isDark),
        ],
      ),
    );
  }

  // ── Chip row for array values ─────────────────────────────────────────────

  Widget _chipRow(bool isDark, String label, dynamic rawValue) {
    final items = _parseList(rawValue);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : const Color(0xFF1A2634))),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('—',
                  style: TextStyle(
                      fontSize: 13,
                      color:
                          isDark ? Colors.white38 : Colors.grey.shade400)),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: items
                    .map((s) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Text(s,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  // ── Jobcard number format radio rows ─────────────────────────────────────

  static const _numberFormats = [
    'Number Based (123456)',
    'Year Based (YYYY/123456)',
    '123456-YY',
    '123456/MM/YYYY',
    'MM/YYYY/001',
  ];

  Widget _numberFormatRow(bool isDark, dynamic rawValue) {
    final current = rawValue?.toString() ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _numberFormats.map((fmt) {
          final isSelected = current == fmt ||
              (current.isNotEmpty &&
                  fmt.toLowerCase().contains(current.toLowerCase()));
          return _RadioChipRow(
              label: fmt, selected: isSelected, isDark: isDark);
        }).toList(),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v != 0;
    final s = v.toString().trim().toLowerCase();
    return s == '1' || s == 'true' || s == 'yes';
  }

  List<String> _parseList(dynamic v) {
    if (v == null) return [];
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String) {
      final t = v.trim();
      if (t.isEmpty || t == '[]') return [];
      if (t.startsWith('[')) {
        try {
          return t
              .substring(1, t.length - 1)
              .split(',')
              .map((e) => e.trim().replaceAll('"', '').replaceAll("'", ''))
              .where((e) => e.isNotEmpty)
              .toList();
        } catch (_) {}
      }
      return t.split(',').map((e) => e.trim()).toList();
    }
    return [];
  }
}

// ── Read-only radio chip ─────────────────────────────────────────────────────

class _RadioChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final bool isDark;

  const _RadioChip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:
            selected ? selectedColor.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? selectedColor
              : (isDark ? Colors.white24 : Colors.grey.shade300),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? selectedColor
                    : (isDark ? Colors.white38 : Colors.grey.shade400),
                width: 1.5,
              ),
              color: selected ? selectedColor : Colors.transparent,
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected
                  ? selectedColor
                  : (isDark ? Colors.white54 : Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Read-only radio row for number format ────────────────────────────────────

class _RadioChipRow extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;

  const _RadioChipRow({
    required this.label,
    required this.selected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : (isDark ? Colors.white38 : Colors.grey.shade400),
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.primary),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : const Color(0xFF1A2634)),
            ),
          ),
        ],
      ),
    );
  }
}
