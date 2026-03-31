import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_icons.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/dashboard_stats_row.dart';
import '../../../../core/widgets/dashboard_stat_card.dart';
import '../../../../core/utils/scroll_aware_fab.dart';
import '../providers/invoice_providers.dart';
import '../state/invoice_state.dart';
import '../widgets/invoice_tile.dart';
import '../../domain/entities/invoice.dart';

class InvoicePage extends ConsumerStatefulWidget {
  const InvoicePage({super.key});

  @override
  ConsumerState<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends ConsumerState<InvoicePage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;
  bool _showStats = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceNotifierProvider.notifier).loadInvoices();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: 'Invoices',
          actions: [
            IconButton(
              icon: Icon(
                _isSearching ? AppIcons.x : AppIcons.search,
                size: 20.r,
              ),
              color: AppColors.white,
              onPressed: () {
                setState(() {
                  if (_isSearching) _searchController.clear();
                  _isSearching = !_isSearching;
                });
              },
            ),
            IconButton(
              icon: Icon(
                _showStats ? AppIcons.eye : AppIcons.eyeOff,
                size: 20.r,
              ),
              color: AppColors.white,
              onPressed: () => setState(() => _showStats = !_showStats),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _isSearching
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search invoices...',
                            prefixIcon: Icon(AppIcons.search, size: 18.r),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Stats
            DashboardStatsRow(
              visible: _showStats,
              cards: _buildStatusCards(state),
            ),
            SizedBox(height: 12.h),

            // List
            Expanded(
              child: _buildBody(state, isDark),
            ),
          ],
        ),
        floatingActionButton: ScrollAwareFab(
          controller: _scrollController,
          onPressed: () => Navigator.pushNamed(context, '/sales/invoices/create'),
          icon: Icon(AppIcons.addRounded, size: 20.r),
          label: 'New Invoice',
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _buildStatusCards(InvoiceState state) {
    if (state.isLoading) {
      return List.generate(3, (_) => const DashboardStatCardSkeleton());
    }

    final totalCount = state.invoices.length;
    // For now, we manually count based on hardcoded status logic in tile
    final unpaid = state.invoices.where((i) => i.status == 2).length;
    final paid = state.invoices.where((i) => i.status == 4).length;

    return [
      DashboardStatCard(
        label: 'Total',
        count: totalCount,
        icon: AppIcons.assignmentRounded,
        borderColor: AppColors.primary,
      ),
      DashboardStatCard(
        label: 'Unpaid',
        count: unpaid,
        icon: AppIcons.errorOutlineRounded,
        borderColor: Colors.red,
      ),
      DashboardStatCard(
        label: 'Paid',
        count: paid,
        icon: AppIcons.checkCircleRounded,
        borderColor: Colors.green,
      ),
    ];
  }

  Widget _buildBody(InvoiceState state, bool isDark) {
    if (state.isLoading) {
      return ListView.separated(
        padding: EdgeInsets.all(16.r),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => _buildInvoiceSkeleton(isDark),
      );
    }

    if (state.error != null) {
      return _buildErrorState(state.error!, isDark);
    }

    final invoices = _searchController.text.isEmpty
        ? state.invoices
        : state.invoices.where((i) {
            final q = _searchController.text.toLowerCase();
            return (i.invoiceNumber?.toLowerCase().contains(q) ?? false) ||
                (i.customerName?.toLowerCase().contains(q) ?? false);
          }).toList();

    if (invoices.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(invoiceNotifierProvider.notifier).loadInvoices(),
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(16.r),
        itemCount: invoices.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (ctx, i) => InvoiceTile(
          invoice: invoices[i],
          onTap: () => Navigator.pushNamed(
            context,
            '/sales/invoices/view',
            arguments: invoices[i],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceSkeleton(bool isDark) {
    final base = isDark ? Colors.white10 : Colors.grey.shade200;
    return Container(
      height: 120.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: base),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20.h,
            width: 150.w,
            decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4)),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 14.h,
            width: 200.w,
            decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4)),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 14.h,
            width: 100.w,
            decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.errorOutlineRounded, size: 48.r, color: Colors.red.shade300),
          SizedBox(height: 16.h),
          Text('Failed to load invoices', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Text(error, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 24.h),
          AppButton(
            text: 'Retry',
            icon: Icon(AppIcons.refreshCcwRounded),
            onPressed: () => ref.read(invoiceNotifierProvider.notifier).loadInvoices(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.assignmentOutlined, size: 80.r, color: isDark ? Colors.white12 : Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text('No invoices found', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
