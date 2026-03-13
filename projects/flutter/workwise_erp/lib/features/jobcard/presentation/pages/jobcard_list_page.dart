import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_icons.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/widgets/drawer_filter.dart';
import '../notifier/jobcard_notifier.dart';
import '../providers/jobcard_providers.dart';
import '../widgets/jobcard_tile.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/dashboard_stat_card.dart';
import '../../../../core/widgets/dashboard_stats_row.dart';
import '../../domain/entities/jobcard.dart';

class JobcardListPage extends ConsumerStatefulWidget {
  const JobcardListPage({super.key});

  @override
  ConsumerState<JobcardListPage> createState() => _JobcardListPageState();
}

class _JobcardListPageState extends ConsumerState<JobcardListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearching = false;
  bool _showStats = true;
  DrawerFilterValue? _activeFilter;

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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark
            ? const Color(0xFF0A0E21)
            : const Color(0xFFF8F9FC),
        endDrawer: DrawerFilter(
          users: ref.watch(jobcardUsersProvider).valueOrNull ?? [],
          statuses: (ref.watch(jobcardStatusesProvider).valueOrNull ?? [])
              .map(
                (s) => {
                  'id': s.id?.toString() ?? '',
                  'name': s.name ?? '',
                  'color': s.color ?? '',
                },
              )
              .toList(),
          initialValue: _activeFilter,
          onApply: (value) => setState(() => _activeFilter = value),
          onReset: () => setState(() => _activeFilter = null),
        ),
        appBar: CustomAppBar(
          title: 'Jobcards',
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
              tooltip: _showStats ? 'Hide stats' : 'Show stats',
            ),
            Row(
              children: [
                SizedBox(width: 4.w),
                IconButton(
                  icon: Icon(AppIcons.filter, size: 20.r),
                  color: _activeFilter != null && !_activeFilter!.isEmpty
                      ? Colors.yellow
                      : AppColors.white,
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
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
                          AppIcons.search,
                          color: isDark ? Colors.white54 : AppColors.primary,
                          size: 18.r,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            AppIcons.x,
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
            DashboardStatsRow(
              visible: _showStats,
              cards: _buildStatusCards(state, isDark),
            ),
            SizedBox(height: 16.h),

            // ── Main Content ──
            Expanded(child: _buildBody(state, isDark)),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pushNamed('/jobcards/create'),
          icon: Icon(AppIcons.addRounded, size: 20.r),
          label: Text('New Jobcard', style: TextStyle(fontSize: 14.sp)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: isDark ? Colors.white60 : Colors.grey.shade600,
            showUnselectedLabels: false,
            selectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(icon: Icon(AppIcons.file), label: 'List'),
              BottomNavigationBarItem(
                icon: Icon(AppIcons.settings),
                label: 'Settings',
              ),
            ],
            onTap: (idx) {
              if (idx == 1) {
                Navigator.pushReplacementNamed(context, '/jobcards/settings');
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStatusCards(JobcardState state, bool isDark) {
    if (state.loading) {
      return List.generate(3, (_) => const DashboardStatCardSkeleton());
    }

    final dashAsync = ref.watch(jobcardDashboardProvider);

    return dashAsync.when(
      loading: () => [
        DashboardStatCard(
          label: 'Total',
          count: 0,
          icon: AppIcons.assignmentRounded,
          borderColor: AppColors.primary,
        ),
      ],
      error: (_, __) => [
        DashboardStatCard(
          label: 'Total',
          count: _getJobcardCount(state),
          icon: AppIcons.assignmentRounded,
          borderColor: AppColors.primary,
        ),
      ],
      data: (items) {
        // Total = sum of all status totals from the API
        final totalCount = items.fold<int>(0, (sum, e) {
          final t = e['total'];
          return sum +
              (t is num ? t.toInt() : int.tryParse(t?.toString() ?? '') ?? 0);
        });

        return [
          DashboardStatCard(
            label: 'Total',
            count: totalCount,
            icon: AppIcons.assignmentRounded,
            borderColor: AppColors.primary,
          ),
          for (final item in items)
            DashboardStatCard(
              label: item['name']?.toString() ?? 'Unknown',
              count: item['total'] is num
                  ? (item['total'] as num).toInt()
                  : int.tryParse(item['total']?.toString() ?? '') ?? 0,
              icon: AppIcons.circle,
              borderColor: _parseColor(item['color']?.toString()),
            ),
        ];
      },
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.primary;
    try {
      final clean = hex.replaceFirst('#', '');
      final value = int.parse(
        clean.length == 6 ? 'FF$clean' : clean,
        radix: 16,
      );
      return Color(value);
    } catch (_) {
      return AppColors.primary;
    }
  }

  int _getJobcardCount(JobcardState state) {
    if (state.loading || state.error != null) return 0;
    return state.items.length;
  }

  Widget _buildBody(JobcardState state, bool isDark) {
    if (state.loading) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (_, __) => _buildJobcardSkeleton(),
      );
    }

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
                  AppIcons.errorOutlineRounded,
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
                icon: Icon(AppIcons.refreshCcwRounded),
                onPressed: () => ref
                    .read(jobcardNotifierProvider.notifier)
                    .loadJobcards(force: true),
              ),
            ],
          ),
        ),
      );
    }

    final jobcards = state.items.cast<Jobcard>();
    // Apply search filter
    var filteredJobcards = _searchController.text.isEmpty
        ? jobcards
        : jobcards.where((j) {
            final q = _searchController.text.toLowerCase();
            return (j.jobcardNumber?.toLowerCase().contains(q) ?? false) ||
                (j.service?.toLowerCase().contains(q) ?? false);
          }).toList();

    // Apply drawer filter
    if (_activeFilter != null && !_activeFilter!.isEmpty) {
      filteredJobcards = filteredJobcards.where((j) {
        // ── Status filter ──
        if (_activeFilter!.statusId != null &&
            _activeFilter!.statusId!.isNotEmpty) {
          if (j.status?.toString() != _activeFilter!.statusId) return false;
        }
        // ── Staff filter ──
        if (_activeFilter!.staffId != null) {
          final raw = j.technicianId ?? '';
          final ids = raw
              .replaceAll(RegExp(r'[\[\]"\\]'), '')
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          if (!ids.any((id) => int.tryParse(id) == _activeFilter!.staffId)) {
            return false;
          }
        }
        // ── Date filter ──
        if (_activeFilter!.dateFrom != null || _activeFilter!.dateTo != null) {
          final raw = j.createdAt ?? j.reportedDate;
          if (raw == null) return false;
          DateTime? jDate;
          try {
            jDate = DateTime.tryParse(raw.replaceAll(' ', 'T'));
          } catch (_) {}
          if (jDate == null) return false;
          if (_activeFilter!.dateFrom != null &&
              jDate.isBefore(_activeFilter!.dateFrom!)) {
            return false;
          }
          if (_activeFilter!.dateTo != null &&
              jDate.isAfter(_activeFilter!.dateTo!)) {
            return false;
          }
        }
        return true;
      }).toList();
    }

    if (filteredJobcards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isEmpty
                  ? AppIcons.assignmentOutlined
                  : AppIcons.searchOffRounded,
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
                icon: Icon(AppIcons.x),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _isSearching = false;
                  });
                },
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(jobcardNotifierProvider.notifier).loadJobcards(force: true),
      color: AppColors.primary,
      child: _buildJobcardList(filteredJobcards),
    );
  }

  Widget _buildJobcardList(List<Jobcard> filteredJobcards) {
    final config = ref.watch(jobcardConfigProvider).valueOrNull ?? {};
    final showApproveReject = _parseBoolConfig(
      config['show_approval_reject_or_completion'],
    );
    final showReminder = _parseBoolConfig(config['enable_reminder']);

    final users = ref.watch(jobcardUsersProvider).valueOrNull ?? [];
    final customers = ref.watch(jobcardCustomersProvider).valueOrNull ?? [];
    final vehicles = ref.watch(jobcardVehiclesProvider).valueOrNull ?? [];

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      itemCount: filteredJobcards.length,
      itemBuilder: (context, idx) {
        final jobcard = filteredJobcards[idx];
        return JobcardTile(
          jobcard: jobcard,
          resolvedReceiverName: _resolveReceiverName(
            jobcard,
            users: users,
            customers: customers,
            vehicles: vehicles,
          ),
          showApproveReject: showApproveReject || _isApprovableStatus(jobcard),
          showReminder: showReminder,
          onTap: () => Navigator.of(
            context,
          ).pushNamed('/jobcards/detail', arguments: jobcard.id),
          onDelete: () => _confirmDelete(jobcard),
          onApprove: (id) => _approveJobcard(id),
          onReject: (id, reason) => _rejectJobcard(id, reason),
        );
      },
    );
  }

  bool _isApprovableStatus(Jobcard jobcard) {
    final status = (jobcard.statusRow?['name'] ?? jobcard.status ?? '').toString().toLowerCase();
    return status.contains('approve') || status.contains('pending');
  }

  /// Resolves the display name for a jobcard's receiver using the pre-loaded
  /// customers / users / vehicles lists.
  /// Returns null when the name is already in [jobcard.receiverName] (the tile
  /// will use it directly) or when no match is found.
  String? _resolveReceiverName(
    Jobcard jobcard, {
    required List<Map<String, dynamic>> users,
    required List<Map<String, dynamic>> customers,
    required List<Map<String, dynamic>> vehicles,
  }) {
    // If the backend already returned a name, the tile will use it; no override needed.
    if (jobcard.receiverName != null &&
        jobcard.receiverName!.isNotEmpty &&
        jobcard.receiverName != 'null') {
      return null;
    }

    final receiverId = jobcard.receiver;
    if (receiverId == null ||
        receiverId.isEmpty ||
        receiverId == 'null' ||
        receiverId == '0') {
      return null;
    }

    final relatedTo = (jobcard.relatedTo ?? '').toLowerCase();
    List<Map<String, dynamic>> pool;
    if (relatedTo.contains('customer')) {
      pool = customers;
    } else if (relatedTo.contains('user')) {
      pool = users;
    } else if (relatedTo.contains('vehicle')) {
      pool = vehicles;
    } else {
      return null;
    }

    final match = pool.firstWhere(
      (r) => r['id']?.toString() == receiverId,
      orElse: () => {},
    );
    if (match.isEmpty) return null;
    return (match['name'] ??
            match['vehicle_name'] ??
            match['title'] ??
            match['username'])
        ?.toString();
  }

  bool _parseBoolConfig(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v != 0;
    final s = v.toString().trim();
    return s == '1' || s == 'true';
  }

  Widget _buildJobcardSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF151A2E)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16.h,
            width: 120.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 12.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _approveJobcard(int id) async {
    final checkUc = ref.read(checkApprovalEligibilityUseCaseProvider);
    final approveUc = ref.read(approveJobcardUseCaseProvider);

    showAppLoadingDialog(context, message: 'Checking eligibility...');
    final checkResult = await checkUc.call(id);
    hideAppLoadingDialog(context);

    bool eligible = checkResult.fold((_) => false, (data) {
      final status = data['status'];
      return status == true ||
          status == 1 ||
          status == 200 ||
          status?.toString() == '1' ||
          status?.toString() == '200';
    });

    if (!eligible) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          content: const Text('Not eligible to approve this jobcard'),
        ),
      );
      return;
    }

    showAppLoadingDialog(context, message: 'Approving...');
    final res = await approveUc.call(id);
    hideAppLoadingDialog(context);

    if (!mounted) return;
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          content: Text('Approval failed: $l'),
        ),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text('Jobcard approved successfully'),
          ),
        );
        ref.read(jobcardNotifierProvider.notifier).loadJobcards(force: true);
      },
    );
  }

  Future<void> _rejectJobcard(int id, String? reason) async {
    final rejectUc = ref.read(rejectJobcardUseCaseProvider);

    showAppLoadingDialog(context, message: 'Rejecting...');
    final res = await rejectUc.call(id, reason: reason);
    hideAppLoadingDialog(context);

    if (!mounted) return;
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          content: Text('Rejection failed: $l'),
        ),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Jobcard rejected'),
          ),
        );
        ref.read(jobcardNotifierProvider.notifier).loadJobcards(force: true);
      },
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
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Failed to delete jobcard: ${l is Exception ? l.toString() : '$l'}',
          ),
        ),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Jobcard deleted'),
          ),
        );
        ref.read(jobcardNotifierProvider.notifier).loadJobcards(force: true);
      },
    );
  }
}
