import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_icons.dart';
import '../../../../core/themes/app_typography.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/google_nav_bar.dart';
import '../../domain/entities/sales_settings.dart';
import '../providers/sales_providers.dart';

class SalesSettingsPage extends ConsumerStatefulWidget {
  const SalesSettingsPage({super.key});

  @override
  ConsumerState<SalesSettingsPage> createState() => _SalesSettingsPageState();
}

class _SalesSettingsPageState extends ConsumerState<SalesSettingsPage> {
  final _ipController = TextEditingController();
  bool _manualOverride = false;

  @override
  void initState() {
    super.initState();
    _loadWeighbridgeSettings();
  }

  Future<void> _loadWeighbridgeSettings() async {
    final service = ref.read(weightbridgeServiceProvider);
    final ip = await service.getIp();
    final manual = await service.getManualOverride();
    if (mounted) {
      setState(() {
        _ipController.text = ip;
        _manualOverride = manual;
      });
    }
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsAsync = ref.watch(salesSettingsProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0A0E21)
            : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(title: 'Sales Settings'),
        bottomNavigationBar: AppGoogleNavBar(
          selectedIndex: 1,
          onTabChange: (idx) {
            if (idx == 0) {
              Navigator.pushReplacementNamed(context, '/sales');
            }
          },
          items: const [
            AppGoogleNavBarItem(label: 'Sales', icon: AppIcons.shoppingCart),
            AppGoogleNavBarItem(label: 'Settings', icon: AppIcons.settings),
          ],
          backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
          activeTabBackgroundColor: isDark
              ? Colors.white12
              : AppColors.primary.withOpacity(0.15),
          activeColor: AppColors.primary,
          color: isDark ? Colors.white60 : Colors.grey.shade600,
        ),
        body: settingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _buildError(context, isDark, err.toString()),
          data: (s) => _buildSettings(isDark, s),
        ),
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────

  Widget _buildError(BuildContext context, bool isDark, String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.errorOutlineRounded,
                size: 48,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load settings',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(AppIcons.refreshRounded),
              label: const Text('Retry'),
              onPressed: () => ref.invalidate(salesSettingsProvider),
            ),
          ],
        ),
      ),
    );
  }

  // ── Settings body ──────────────────────────────────────────────────────────

  Widget _buildSettings(bool isDark, SalesSettings s) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Order Form Fields ────────────────────────────────────────────
          _sectionCard(
            isDark: isDark,
            title: 'Order Form Fields',
            children: [
              _boolRow(isDark, 'Show Title', s.orderShowTitle),
              _divider(isDark),
              _boolRow(isDark, 'Show Customer', s.orderShowCustomer),
              _divider(isDark),
              _boolRow(isDark, 'Show Currency', s.orderShowCurrency),
              _divider(isDark),
              _boolRow(
                isDark,
                'Show Vehicle Allocation',
                s.orderShowVehicleAllocation,
              ),
              _divider(isDark),
              _boolRow(isDark, 'Show Cargo Value', s.orderShowCargo),
              _divider(isDark),
              _boolRow(isDark, 'Show End Date', s.orderShowEndDate),
              _divider(isDark),
              _boolRow(isDark, 'Show Priority', s.orderShowPriority),
              _divider(isDark),
              _boolRow(
                isDark,
                'Show Sender & Receiver',
                s.orderShowSenderReceiver,
              ),
              _divider(isDark),
              _boolRow(isDark, 'Show Amount', s.orderShowAmount),
              _divider(isDark),
              _boolRow(isDark, 'Amount Required', s.orderAmountRequired),
              _divider(isDark),
              _boolRow(isDark, 'Show Package Type', s.orderShowPackage),
            ],
          ),
          const SizedBox(height: 16),

          // ── Documents & References ───────────────────────────────────────
          _sectionCard(
            isDark: isDark,
            title: 'Documents & References',
            children: [
              _boolRow(isDark, 'Show Contract', s.orderShowContract),
              _divider(isDark),
              _boolRow(isDark, 'Contract Required', s.orderContractRequired),
              _divider(isDark),
              _boolRow(isDark, 'Show Request', s.orderShowRequest),
              _divider(isDark),
              _boolRow(isDark, 'Show PFI / Quotation', s.orderShowPfi),
              _divider(isDark),
              _boolRow(isDark, 'Show LPO', s.orderShowLpo),
              _divider(isDark),
              _boolRow(isDark, 'Show Payment Type', s.orderShowPaymentType),
              _divider(isDark),
              _boolRow(isDark, 'Show Proof of Payment', s.orderShowProf),
            ],
          ),
          const SizedBox(height: 16),

          // ── Items & Trucks ───────────────────────────────────────────────
          _sectionCard(
            isDark: isDark,
            title: 'Items & Trucks',
            children: [
              _boolRow(
                isDark,
                'Show Product / Service Items',
                s.orderShowProductService,
              ),
              _divider(isDark),
              _boolRow(isDark, 'Tax Per Item', s.taxPerItem > 0),
              _divider(isDark),
              _boolRow(isDark, 'Discount Per Item', s.discountPerItem > 0),
              _divider(isDark),
              _boolRow(
                isDark,
                'Auto Qty & Unit Capture',
                s.enableAutoQtyUnitCapture,
              ),
              _divider(isDark),
              _boolRow(isDark, 'Show Truck List', s.orderShowTruckList),
              _divider(isDark),
              _boolRow(
                isDark,
                'Enable Vehicle Check-in/Check-out',
                s.orderEnableVehicleCheckinCheckout,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Visibility & Assignments ─────────────────────────────────────
          _sectionCard(
            isDark: isDark,
            title: 'Visibility & Assignments',
            children: [
              _boolRow(isDark, 'Show Location', s.orderShowLocation),
              _divider(isDark),
              _boolRow(isDark, 'Show Status', s.orderShowStatus),
              _divider(isDark),
              _boolRow(
                isDark,
                'Show User Assignment',
                s.orderShowUserAssignment,
              ),
              _divider(isDark),
              _boolRow(
                isDark,
                'Allow Multiple Sender/Receiver',
                s.orderAllowMultipleSenderReceiver,
              ),
              _divider(isDark),
              _boolRow(
                isDark,
                'Show Customer Balance',
                s.orderShowCustomerBalance,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Order Configuration ──────────────────────────────────────────
          _sectionCard(
            isDark: isDark,
            title: 'Order Configuration',
            children: [
              _textRow(isDark, 'Order Prefix', s.orderPrefix),
              _divider(isDark),
              _textRow(isDark, 'After Save Action', s.orderAfterSave),
              _divider(isDark),
              _numberFormatRow(isDark, s.orderNumberFormat),
            ],
          ),
          const SizedBox(height: 16),

          // ── Weighbridge ──────────────────────────────────────────────────
          _weighbridgeSection(isDark),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ── Weighbridge section ────────────────────────────────────────────────────

  Widget _weighbridgeSection(bool isDark) {
    return _sectionCard(
      isDark: isDark,
      title: 'Weighbridge',
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service IP Address',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : const Color(0xFF1A2634),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ipController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                      decoration: InputDecoration(
                        hintText: '192.168.1.100',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey.shade400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () async {
                      await ref
                          .read(weightbridgeServiceProvider)
                          .saveIp(_ipController.text.trim());
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Weighbridge IP saved'),
                          ),
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
        _divider(isDark),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Allow Manual Check-in',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF1A2634),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'When on, weight can be typed manually instead of '
                      'fetching from the weighbridge device.',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _manualOverride,
                activeColor: AppColors.primary,
                onChanged: (v) async {
                  setState(() => _manualOverride = v);
                  await ref
                      .read(weightbridgeServiceProvider)
                      .saveManualOverride(v);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Widgets ────────────────────────────────────────────────────────────────

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
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title,
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(children: children),
          ),
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

  Widget _textRow(bool isDark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF1A2634),
              ),
            ),
          ),
          Text(
            value.isEmpty ? '—' : value,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF1A2634),
            ),
          ),
        ],
      ),
    );
  }

  Widget _boolRow(bool isDark, String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF1A2634),
              ),
            ),
          ),
          _RadioChip(label: 'Yes', selected: value, isDark: isDark),
          const SizedBox(width: 8),
          _RadioChip(label: 'No', selected: !value, isDark: isDark),
        ],
      ),
    );
  }

  static const _numberFormats = ['number', 'year_number'];

  static const _numberFormatLabels = {
    'number': 'Number Based (123456)',
    'year_number': 'Year Based (YYYY/123456)',
  };

  Widget _numberFormatRow(bool isDark, String rawValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Number Format',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : const Color(0xFF1A2634),
            ),
          ),
          const SizedBox(height: 8),
          ..._numberFormats.map((fmt) {
            final isSelected = rawValue == fmt;
            return _RadioChipRow(
              label: _numberFormatLabels[fmt] ?? fmt,
              selected: isSelected,
              isDark: isDark,
            );
          }),
        ],
      ),
    );
  }
}

// ── Read-only radio chip (Yes/No) ────────────────────────────────────────────

class _RadioChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;

  const _RadioChip({
    required this.label,
    required this.selected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          selected
              ? CupertinoIcons.smallcircle_fill_circle
              : CupertinoIcons.circle,
          size: 20,
          color: selected
              ? AppColors.primary
              : (isDark ? Colors.white38 : Colors.grey.shade400),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.white70 : const Color(0xFF1A2634),
          ),
        ),
      ],
    );
  }
}

// ── Read-only radio row ───────────────────────────────────────────────────────

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
          Icon(
            selected
                ? CupertinoIcons.smallcircle_fill_circle
                : CupertinoIcons.circle,
            size: 20,
            color: selected
                ? AppColors.primary
                : (isDark ? Colors.white38 : Colors.grey.shade400),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
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
