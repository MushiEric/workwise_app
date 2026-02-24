import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../notifier/jobcard_notifier.dart';
import '../providers/jobcard_providers.dart';
import '../widgets/jobcard_tile.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../domain/entities/jobcard.dart';

class JobcardListPage extends ConsumerStatefulWidget {
  const JobcardListPage({super.key});

  @override
  ConsumerState<JobcardListPage> createState() => _JobcardListPageState();
}

class _JobcardListPageState extends ConsumerState<JobcardListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;
  bool _showStats = true;

  Color _statusColorFromName(String statusName) {
    final lower = statusName.toLowerCase();
    if (lower.contains('open')) return const Color(0xFF4A6FA5);
    if (lower.contains('progress')) return Colors.orange;
    if (lower.contains('awaiting') || lower.contains('pending')) return Colors.blue;
    if (lower.contains('closed') || lower.contains('completed')) return Colors.grey;
    return AppColors.primary;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobcardNotifierProvider.notifier).loadJobcards();
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
    final state = ref.watch(jobcardNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<JobcardState>(jobcardNotifierProvider, (prev, next) {
      final prevLoading = prev?.loading ?? false;
      final nextLoading = next.loading;
      if (prevLoading == nextLoading) return;
      if (nextLoading) {
        showAppLoadingDialog(context, message: 'Fetching jobcards...');
      } else {
        hideAppLoadingDialog(context);
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0A0E21)
            : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: 'Jobcards',
          actions: [
            IconButton(
              icon: Icon(
                _isSearching ? LucideIcons.x : LucideIcons.search,
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
                _showStats ? LucideIcons.eye : LucideIcons.eyeOff,
                size: 20.r,
              ),
              color: AppColors.white,
              onPressed: () => setState(() => _showStats = !_showStats),
              tooltip: _showStats ? 'Hide stats' : 'Show stats',
            ),
            IconButton(
              icon: Icon(LucideIcons.settings, size: 20.r),
              color: AppColors.white,
              onPressed: () => Navigator.pushNamed(context, '/jobcards/settings'),
            ),
            Row(
              children: [
                SizedBox(width: 4.w),
                IconButton(
                  icon: Icon(LucideIcons.slidersHorizontal, size: 20.r),
                  color: AppColors.white,
                  onPressed: _showFilterOptions,
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            // ── Search Bar ──
            if (_isSearching)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 70.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search jobcards...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: isDark ? Colors.white54 : AppColors.primary,
                          size: 18.r,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            LucideIcons.x,
                            color: isDark ? Colors.white54 : AppColors.primary,
                            size: 18.r,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _isSearching = false;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                        fontSize: 14.sp,
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ),
              ),

            // ── Stats Header ──
            if (_showStats)
              Padding(
                padding: EdgeInsets.all(16.r),
                child: SizedBox(
                  height: 96.h,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _buildStatusCards(state, isDark),
                    ),
                  ),
                ),
              ),

            // ── Main Content ──
            Expanded(child: _buildBody(state, isDark)),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pushNamed('/jobcards/create'),
          icon: Icon(Icons.add_rounded, size: 20.r),
          label: Text('New Jobcard', style: TextStyle(fontSize: 14.sp)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }

  // ── Stat cards matching support list style ──
  List<Widget> _buildStatusCards(JobcardState state, bool isDark) {
    final counts = <String, int>{};
    for (final item in state.items.cast<Jobcard>()) {
      final name = item.statusRow?['name']?.toString() ??
          item.status?.toString() ??
          '';
      counts[name] = (counts[name] ?? 0) + 1;
    }

    final widgets = <Widget>[
      SizedBox(
        width: 150.w,
        child: _buildStatCard(
          'Total',
          _getJobcardCount(state),
          Icons.assignment_rounded,
          AppColors.primary,
          isDark,
        ),
      ),
    ];

    counts.forEach((status, cnt) {
      widgets.add(SizedBox(width: 12.w));
      widgets.add(
        SizedBox(
          width: 150.w,
          child: _buildStatCard(
            status.isEmpty ? 'Unknown' : status,
            cnt,
            Icons.circle,
            _statusColorFromName(status),
            isDark,
          ),
        ),
      );
    });

    return widgets;
  }

  Widget _buildStatCard(
    String label,
    int count,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      height: 96.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0E21) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 3.w)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Opacity(
            opacity: 0.12,
            child: Icon(icon, size: 40.r, color: color),
          ),
        ],
      ),
    );
  }

  int _getJobcardCount(JobcardState state) {
    if (state.loading || state.error != null) return 0;
    return state.items.length;
  }

  Widget _buildBody(JobcardState state, bool isDark) {
    if (state.loading) return const Center();

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48.r,
                  color: Colors.red.shade300,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Failed to load jobcards',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 24.h),
              AppButton(
                text: 'Retry',
                icon: Icons.refresh_rounded,
                onPressed: () =>
                    ref.read(jobcardNotifierProvider.notifier).loadJobcards(),
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
        ),
      );
    }

    final jobcards = state.items.cast<Jobcard>();
    final filteredJobcards = _searchController.text.isEmpty
        ? jobcards
        : jobcards.where((j) {
            final q = _searchController.text.toLowerCase();
            return (j.jobcardNumber?.toLowerCase().contains(q) ?? false) ||
                (j.service?.toLowerCase().contains(q) ?? false);
          }).toList();

    if (filteredJobcards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isEmpty
                  ? Icons.assignment_outlined
                  : Icons.search_off_rounded,
              size: 80.r,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              _searchController.text.isEmpty
                  ? 'No jobcards found'
                  : 'No matching jobcards',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchController.text.isEmpty
                  ? 'Create your first jobcard'
                  : 'Try adjusting your search',
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
            if (_searchController.text.isNotEmpty) ...[
              SizedBox(height: 16.h),
              AppButton(
                text: 'Clear Search',
                icon: Icons.clear_rounded,
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _isSearching = false;
                  });
                },
                variant: AppButtonVariant.outline,
                size: AppButtonSize.small,
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(jobcardNotifierProvider.notifier).loadJobcards(),
      color: AppColors.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        itemCount: filteredJobcards.length,
        itemBuilder: (context, idx) {
          final jobcard = filteredJobcards[idx];
          return JobcardTile(
            jobcard: jobcard,
            onTap: () => Navigator.of(context)
                .pushNamed('/jobcards/detail', arguments: jobcard.id),
            onDelete: () => _confirmDelete(jobcard),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(Jobcard jobcard) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: 'Delete Jobcard',
      message:
          'Are you sure you want to delete this jobcard? This action cannot be undone.',
      messageColor: AppColors.black,
      confirmText: 'Delete',
      confirmColor: AppColors.error,
    );
    if (confirmed != true || jobcard.id == null) return;

    final deleteUc = ref.read(deleteJobcardUseCaseProvider);
    showAppLoadingDialog(context, message: 'Deleting jobcard...');
    final res = await deleteUc.call(id: jobcard.id!);
    hideAppLoadingDialog(context);
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete jobcard: ${l is Exception ? l.toString() : '$l'}',
          ),
        ),
      ),
      (_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Jobcard deleted')));
        ref.read(jobcardNotifierProvider.notifier).loadJobcards();
      },
    );
  }

  void _showFilterOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Jobcards',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'Status',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildFilterChip('All', true, isDark),
                _buildFilterChip('Open', false, isDark),
                _buildFilterChip('In Progress', false, isDark),
                _buildFilterChip('Completed', false, isDark),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'Date Range',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.h),
            _buildDateOption('Today', isDark),
            _buildDateOption('This Week', isDark),
            _buildDateOption('This Month', isDark),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text('Reset', style: TextStyle(fontSize: 14.sp)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text('Apply', style: TextStyle(fontSize: 14.sp)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, bool isDark) {
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 13.sp)),
      selected: isSelected,
      onSelected: (_) {},
      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? AppColors.primary
            : (isDark ? Colors.white70 : Colors.grey.shade700),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13.sp,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isSelected
              ? AppColors.primary
              : (isDark ? Colors.white24 : Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildDateOption(String label, bool isDark) {
    return RadioListTile<String>(
      title: Text(label, style: TextStyle(fontSize: 14.sp)),
      value: label,
      groupValue: 'Today',
      onChanged: (_) {},
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      tileColor: isDark ? Colors.white10 : Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}
