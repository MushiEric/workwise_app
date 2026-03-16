import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../../core/themes/app_icons.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/widgets/drawer_filter.dart';
import 'package:workwise_erp/core/utils/scroll_aware_fab.dart';
import 'package:workwise_erp/core/widgets/shimmer.dart';
import 'package:workwise_erp/core/services/tutorial_service.dart';
import '../notifier/jobcard_notifier.dart';
import '../providers/jobcard_providers.dart';
import '../widgets/jobcard_tile.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/dashboard_stat_card.dart';
import '../../../../core/widgets/dashboard_stats_row.dart';
import '../../../../core/widgets/google_nav_bar.dart';
import '../../domain/entities/jobcard.dart';
import '../../domain/entities/jobcard_status.dart';

class _ApprovalEligibility {
  final bool eligible;
  final int? approvalId;
  final int? roleUserId;
  final int? approvalStatus;

  const _ApprovalEligibility({
    required this.eligible,
    this.approvalId,
    this.roleUserId,
    this.approvalStatus,
  });
}

class JobcardListPage extends ConsumerStatefulWidget {
  const JobcardListPage({super.key});

  @override
  ConsumerState<JobcardListPage> createState() => _JobcardListPageState();
}

class _JobcardListPageState extends ConsumerState<JobcardListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<JobcardStatus> _availableStatuses = [];

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Tracks approval eligibility state per jobcard id.
  // - `eligible` controls whether the swipe approve/reject is enabled.
  // - `approvalId` and `roleUserId` are required by the `/logistic/jobcardApproval` payload.
  final Map<int, _ApprovalEligibility> _approvalEligibility = {};
  final Set<int> _approvalEligibilityRequested = {};

  bool _isSearching = false;
  bool _showStats = true;
  int _bottomNavIndex = 0;
  DrawerFilterValue? _activeFilter;

  // Coach mark targets
  final _jobcardTileKey = GlobalKey();
  final _filterButtonKey = GlobalKey();

  // Tutorial retry state (keys may not be available immediately on first build)
  bool _jobcardTutorialShown = false;
  int _jobcardTutorialRetryCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(_handleTabSelection);

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobcardNotifierProvider.notifier).loadJobcards();
      _loadStatuses();
      _maybeShowJobcardTutorial();
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (mounted) setState(() {});
    }
  }

  Future<void> _maybeShowJobcardTutorial() async {
    final seen = await TutorialService.hasSeenJobcardTutorial();
    if (seen) return;

    // Wait a tick so the UI is fully laid out.
    await Future<void>.delayed(const Duration(milliseconds: 150));

    _attemptShowJobcardTutorial();
  }

  void _attemptShowJobcardTutorial() {
    if (!mounted || _jobcardTutorialShown) return;

    final targets = <TargetFocus>[];

    if (_jobcardTileKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: 'jobcard-tile',
          keyTarget: _jobcardTileKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jobcard Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Swipe left to reject or swipe right to approve a jobcard.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_filterButtonKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: 'jobcard-filter',
          keyTarget: _filterButtonKey,
          contents: [
            TargetContent(
              align: ContentAlign.left,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jobcard Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use the filter button to change which jobcards you see (status, assignee, etc.).',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (targets.isEmpty) {
      if (_jobcardTutorialRetryCount < 10) {
        _jobcardTutorialRetryCount += 1;
        Future<void>.delayed(
          const Duration(milliseconds: 250),
          _attemptShowJobcardTutorial,
        );
      } else {
        TutorialService.markJobcardTutorialSeen();
      }
      return;
    }

    _jobcardTutorialShown = true;
    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.75),
      textSkip: 'Skip',
      onFinish: () => TutorialService.markJobcardTutorialSeen(),
      onSkip: () {
        TutorialService.markJobcardTutorialSeen();
        return true;
      },
      onClickTarget: (target) {},
    ).show(context: context);
  }

  Future<void> _loadStatuses() async {
    try {
      final uc = ref.read(getJobcardSettingsUseCaseProvider);
      final res = await uc.call();
      res.fold(
        (_) {
          // Ensure we always show at least the "All" tab.
          final newController = TabController(length: 1, vsync: this);
          newController.addListener(_handleTabSelection);
          setState(() {
            _availableStatuses = const [
              JobcardStatus(id: -1, name: 'All', color: null),
            ];
            final old = _tabController;
            _tabController = newController;
            old.dispose();
          });
        },
        (list) {
          final all = <JobcardStatus>[
            const JobcardStatus(id: -1, name: 'All', color: null),
            ...list,
          ];
          final newController = TabController(length: all.length, vsync: this);
          newController.addListener(_handleTabSelection);
          setState(() {
            _availableStatuses = all;
            final old = _tabController;
            _tabController = newController;
            old.dispose();
          });
        },
      );
    } catch (_) {
      final newController = TabController(length: 1, vsync: this);
      newController.addListener(_handleTabSelection);
      setState(() {
        _availableStatuses = const [
          JobcardStatus(id: -1, name: 'All', color: null),
        ];
        final old = _tabController;
        _tabController = newController;
        old.dispose();
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(jobcardNotifierProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
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
      child: Theme(
        data: Theme.of(context).copyWith(
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.fixed,
          ),
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
                    key: _filterButtonKey,
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: _isSearching
                    ? Padding(
                        key: const ValueKey('search-visible'),
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
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade500,
                                fontSize: 14.sp,
                              ),
                              prefixIcon: Icon(
                                AppIcons.search,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.primary,
                                size: 18.r,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  AppIcons.x,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.primary,
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
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2634),
                              fontSize: 14.sp,
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('search-hidden')),
              ),

              // ── Stats Header ──
              DashboardStatsRow(
                visible: _showStats,
                cards: _buildStatusCards(state, isDark),
              ),
              SizedBox(height: 16.h),

              // ── Status Tabs ──
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: _availableStatuses.isNotEmpty
                    ? TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabs: _availableStatuses
                            .map((s) => Tab(text: s.name ?? 'Unknown'))
                            .toList(),
                        labelColor: AppColors.primary,
                        labelStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: TextStyle(fontSize: 13.sp),
                        unselectedLabelColor: isDark
                            ? Colors.white54
                            : Colors.grey.shade600,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: AppColors.primary.withOpacity(0.15),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: 12.h),

              // ── Main Content ──
              Expanded(child: _buildBody(state, isDark)),
            ],
          ),
          floatingActionButton: ScrollAwareFab(
            controller: _scrollController,
            onPressed: () =>
                Navigator.of(context).pushNamed('/jobcards/create'),
            icon: Icon(AppIcons.addRounded, size: 20.r),
            label: 'New Jobcard',
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          bottomNavigationBar: AppGoogleNavBar(
            selectedIndex: _bottomNavIndex,
            onTabChange: (idx) {
              setState(() => _bottomNavIndex = idx);
              if (idx == 1) {
                Navigator.pushReplacementNamed(context, '/jobcards/settings');
              }
            },
            items: const [
              AppGoogleNavBarItem(label: 'Jorbcards', icon: AppIcons.file),
              AppGoogleNavBarItem(label: 'Settings', icon: AppIcons.settings),
            ],
            backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
            activeTabBackgroundColor: isDark
                ? Colors.white12
                : AppColors.primary.withOpacity(0.15),
            activeColor: AppColors.primary,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
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
          count: state.items.length,
          icon: AppIcons.assignmentRounded,
          borderColor: AppColors.primary,
        ),
      ],
      data: (items) {
        // Total = prefer state.totalItems if available, else sum of all status totals from the API
        int totalCount = state.totalItems > 0 ? state.totalItems : 0;
        if (totalCount == 0) {
          for (final item in items) {
            final t = item['total'];
            totalCount += (t is num
                ? t.toInt()
                : int.tryParse(t?.toString() ?? '') ?? 0);
          }
        }

        // If totalCount is 0, fallback to the list length
        if (totalCount == 0 && state.items.isNotEmpty) {
          totalCount = state.items.length;
        }

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

    // ── Status tab filter (always applied) ──
    if (_availableStatuses.isNotEmpty) {
      final idx = _tabController.index;
      if (idx >= 0 && idx < _availableStatuses.length) {
        final selected = (_availableStatuses[idx].name ?? '').toLowerCase();
        if (selected != 'all') {
          filteredJobcards = filteredJobcards.where((j) {
            final statusName =
                (j.statusRow?['name']?.toString() ?? j.status?.toString() ?? '')
                    .toLowerCase();
            return statusName == selected;
          }).toList();
        }
      }
    }

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
      onRefresh: () async {
        await Future.wait([
          ref.read(jobcardNotifierProvider.notifier).loadJobcards(force: true),
          ref.refresh(jobcardUsersProvider.future),
          ref.refresh(jobcardCustomersProvider.future),
          ref.refresh(jobcardVehiclesProvider.future),
          ref.refresh(jobcardDashboardProvider.future),
        ]);
      },
      color: AppColors.primary,
      child: Column(
        children: [
          Expanded(child: _buildJobcardList(state, filteredJobcards)),
          if (state.loadingMore)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJobcardList(JobcardState state, List<Jobcard> filteredJobcards) {
    final config = ref.watch(jobcardConfigProvider).valueOrNull ?? {};

    // Some backend responses contain typos in the keys (e.g. "show_aproval_reject_or_complition").
    // For backwards compatibility, check both the correct and misspelled keys.
    final rawShowApproval =
        config['show_approval_reject_or_completion'] ??
        config['show_aproval_reject_or_complition'];
    final showApproveReject = _parseBoolConfig(rawShowApproval);
    final showReminder = _parseBoolConfig(config['enable_reminder']);

    // Debug: log config state to help diagnose why approval/reject isn't showing.
    // Remove or disable in production.
    if (kDebugMode) {
      debugPrint('Jobcard config keys: ${config.keys.toList()}');
      debugPrint(
        'Jobcard config show_approval_reject_or_completion=$rawShowApproval -> showApproveReject=$showApproveReject',
      );
    }

    // When the list is rendered, pre-fetch approval eligibility so that swipe
    // actions can be enabled/disabled per jobcard.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureApprovalEligibility(filteredJobcards);
    });

    final users = ref.watch(jobcardUsersProvider).valueOrNull ?? [];
    final customers = ref.watch(jobcardCustomersProvider).valueOrNull ?? [];
    final vehicles = ref.watch(jobcardVehiclesProvider).valueOrNull ?? [];

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      itemCount: filteredJobcards.length,
      itemBuilder: (context, idx) {
        final jobcard = filteredJobcards[idx];
        final eligibility = jobcard.id != null
            ? _approvalEligibility[jobcard.id!]
            : null;
        final isEligible = eligibility?.eligible ?? true;
        final isLocked = jobcard.isApprovalLocked;
        final canSwipe =
            (showApproveReject || _isApprovableStatus(jobcard)) &&
            !isLocked &&
            isEligible;

        return JobcardTile(
          key: idx == 0 ? _jobcardTileKey : null,
          jobcard: jobcard,
          resolvedReceiverName: _resolveReceiverName(
            jobcard,
            users: users,
            customers: customers,
            vehicles: vehicles,
          ),
          showApproveReject: canSwipe,
          showReminder: showReminder,
          onTap: () => Navigator.of(
            context,
          ).pushNamed('/jobcards/detail', arguments: jobcard.id),
          onDelete: () => _confirmDelete(jobcard),
          onApprove: (id, comment) => _approveJobcard(jobcard, comment),
          onReject: (id, reason) => _rejectJobcard(jobcard, reason),
        );
      },
    );
  }

  bool _isApprovableStatus(Jobcard jobcard) {
    final status = (jobcard.statusRow?['name'] ?? jobcard.status ?? '')
        .toString()
        .toLowerCase();
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

    // Determine which pool to search in based on relatedTo
    List<Map<String, dynamic>> primaryPool = [];
    if (relatedTo.contains('customer')) {
      primaryPool = customers;
    } else if (relatedTo.contains('user') || relatedTo.contains('employee')) {
      primaryPool = users;
    } else if (relatedTo.contains('vehicle')) {
      primaryPool = vehicles;
    }

    // Try to find in the primary pool
    final matchInPrimary = primaryPool.firstWhere(
      (r) => r['id']?.toString() == receiverId,
      orElse: () => {},
    );

    if (matchInPrimary.isNotEmpty) {
      return (matchInPrimary['name'] ??
              matchInPrimary['vehicle_name'] ??
              matchInPrimary['title'] ??
              matchInPrimary['username'])
          ?.toString();
    }

    // Fallback: search in ALL pools if not found in primary or if relatedTo was unknown
    final allPools = [...users, ...customers, ...vehicles];
    final matchInAny = allPools.firstWhere(
      (r) => r['id']?.toString() == receiverId,
      orElse: () => {},
    );

    if (matchInAny.isNotEmpty) {
      return (matchInAny['name'] ??
              matchInAny['vehicle_name'] ??
              matchInAny['title'] ??
              matchInAny['username'])
          ?.toString();
    }

    return null;
  }

  bool _parseBoolConfig(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v != 0;

    final s = v.toString().trim().toLowerCase();
    if (s.isEmpty) return false;

    const truthy = {'1', 'true', 'yes', 'y', 'on', 'enabled'};
    const falsy = {'0', 'false', 'no', 'n', 'off', 'disabled'};

    if (truthy.contains(s)) return true;
    if (falsy.contains(s)) return false;

    // Fallback: numeric check (e.g. '123' considered true)
    final numValue = int.tryParse(s);
    if (numValue != null) return numValue != 0;

    return false;
  }

  Widget _buildJobcardSkeleton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A2E) : Colors.white,
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
      ),
    );
  }

  Future<_ApprovalEligibility> _fetchApprovalEligibility(int id) async {
    final checkUc = ref.read(checkApprovalEligibilityUseCaseProvider);
    final result = await checkUc.call(id);

    return result.fold((_) => const _ApprovalEligibility(eligible: false), (
      data,
    ) {
      final eligibleRaw = data['eligible'];
      final eligible = (eligibleRaw is bool)
          ? eligibleRaw
          : (eligibleRaw?.toString().trim().toLowerCase() == 'true' ||
                eligibleRaw?.toString().trim() == '1');

      int? parseInt(dynamic v) {
        if (v == null) return null;
        if (v is int) return v;
        return int.tryParse(v.toString());
      }

      return _ApprovalEligibility(
        eligible: eligible,
        approvalId: parseInt(data['approval_id']),
        roleUserId: parseInt(data['role_user_id']),
        approvalStatus: parseInt(data['approval_status']),
      );
    });
  }

  void _ensureApprovalEligibility(List<Jobcard> jobcards) {
    for (final jc in jobcards) {
      final id = jc.id;
      if (id == null) continue;
      if (_approvalEligibilityRequested.contains(id)) continue;

      _approvalEligibilityRequested.add(id);

      // If approval status indicates approved/rejected, we already know it's locked.
      if (jc.isApprovalLocked) {
        _approvalEligibility[id] = _ApprovalEligibility(
          eligible: false,
          approvalId: jc.approvalId,
          roleUserId: jc.roleUserId,
          approvalStatus: jc.approvalStatus,
        );
        continue;
      }

      _fetchApprovalEligibility(id).then((info) {
        if (!mounted) return;
        setState(() {
          _approvalEligibility[id] = info;
        });
      });
    }
  }

  Future<void> _approveJobcard(Jobcard jobcard, String? comment) async {
    final jobcardId = jobcard.id;
    if (jobcardId == null) return;

    // Ensure we have eligibility info (and the required approval context)
    if (!_approvalEligibility.containsKey(jobcardId)) {
      _approvalEligibility[jobcardId] = await _fetchApprovalEligibility(
        jobcardId,
      );
    }

    final eligibility = _approvalEligibility[jobcardId]!;

    if (!eligibility.eligible) {
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

    final approvalId = eligibility.approvalId ?? jobcard.approvalId;
    final roleUserId = eligibility.roleUserId ?? jobcard.roleUserId;

    if (approvalId == null || roleUserId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          content: const Text('Unable to determine approval context'),
        ),
      );
      return;
    }

    final approveUc = ref.read(approveJobcardUseCaseProvider);

    showAppLoadingDialog(context, message: 'Approving...');
    final res = await approveUc.call(
      jobcardId: jobcardId,
      status: 3,
      approvalId: approvalId,
      roleUserId: roleUserId,
      comment: comment,
    );
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
        setState(() {
          _approvalEligibility.clear();
          _approvalEligibilityRequested.clear();
        });
        ref.read(jobcardNotifierProvider.notifier).loadJobcards(force: true);
      },
    );
  }

  Future<void> _rejectJobcard(Jobcard jobcard, String? comment) async {
    final jobcardId = jobcard.id;
    if (jobcardId == null) return;

    // Ensure we have eligibility info (and the required approval context)
    if (!_approvalEligibility.containsKey(jobcardId)) {
      _approvalEligibility[jobcardId] = await _fetchApprovalEligibility(
        jobcardId,
      );
    }

    final eligibility = _approvalEligibility[jobcardId]!;

    final approvalId = eligibility.approvalId ?? jobcard.approvalId;
    final roleUserId = eligibility.roleUserId ?? jobcard.roleUserId;

    if (approvalId == null || roleUserId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          content: const Text('Unable to determine approval context'),
        ),
      );
      return;
    }

    final rejectUc = ref.read(rejectJobcardUseCaseProvider);

    showAppLoadingDialog(context, message: 'Rejecting...');
    final res = await rejectUc.call(
      jobcardId: jobcardId,
      status: 2,
      approvalId: approvalId,
      roleUserId: roleUserId,
      comment: comment,
    );
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
        setState(() {
          _approvalEligibility.clear();
          _approvalEligibilityRequested.clear();
        });
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
