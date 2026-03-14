import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import '../providers/support_providers.dart';
import '../state/support_state.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/status.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/support_service.dart';
import '../../domain/entities/support_location.dart';
import '../../domain/entities/support_department.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_modal.dart';
import '../../../../core/widgets/dashboard_stat_card.dart';
import '../../../../core/widgets/dashboard_stats_row.dart';
import '../../../../core/widgets/app_textfield.dart';

import '../../domain/entities/support_category.dart';
import '../../domain/entities/support_supervisor.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../customer/presentation/providers/customer_providers.dart';
import 'package:intl/intl.dart';

import '../widgets/ticket_detail_content.dart';
import 'support_view_page.dart';
import 'create_ticket_page.dart';
import '../../../../core/themes/app_icons.dart';
import '../../../../core/utils/scroll_aware_fab.dart';

class SupportListPage extends ConsumerStatefulWidget {
  const SupportListPage({super.key});

  @override
  ConsumerState<SupportListPage> createState() => _SupportListPageState();
}

class _SupportListPageState extends ConsumerState<SupportListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;
  bool _showStats = true;

  // drawer filter date range (chip-style, mirrors DrawerFilter)
  String?
  _filterDateRangeType; // 'daily' | 'weekly' | 'monthly' | 'annually' | 'custom'
  DateTime? _filterDateFrom;
  DateTime? _filterDateTo;
  final _filterDateFromCtrl = TextEditingController();
  final _filterDateToCtrl = TextEditingController();

  // Back-end statuses (used to render dynamic tabs)
  List<SupportStatus> availableStatuses = [];

  // additional filter lists
  List<SupportStatus> _filterStatuses = [];
  List<Priority> _filterPriorities = [];
  List<SupportService> _filterServices = [];
  List<SupportLocation> _filterLocations = [];
  List<SupportDepartment> _filterDepartments = [];
  List<SupportCategory> _filterCategories = [];
  List<SupportSupervisor> _filterSupervisors = [];
  List<Customer> _filterCustomers = [];
  List<User> _filterUsers = [];

  // currently selected filter values (null = all)
  SupportStatus? _selectedFilterStatus;
  Priority? _selectedFilterPriority;
  SupportService? _selectedFilterService;
  SupportLocation? _selectedFilterLocation;
  SupportDepartment? _selectedFilterDepartment;
  SupportCategory? _selectedFilterCategory;
  SupportSupervisor? _selectedFilterSupervisor;
  Customer? _selectedFilterCustomer;
  User? _selectedFilterUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(supportNotifierProvider.notifier).loadTickets();
      _loadStatuses();
      _loadFilterData();
    });

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (mounted) setState(() {});
    }
  }

  Future<void> _loadStatuses() async {
    try {
      final getStatuses = ref.read(getSupportStatusesUseCaseProvider);
      final res = await getStatuses.call();
      res.fold((_) => null, (list) {
        final newController = TabController(length: list.length, vsync: this);
        newController.addListener(_handleTabSelection);
        setState(() {
          availableStatuses = list;
          final old = _tabController;
          _tabController = newController;
          old.dispose();
        });
      });
    } catch (_) {}
  }

  /// load lists needed for dropdown filters
  Future<void> _loadFilterData() async {
    try {
      final stRes = await ref.read(getSupportStatusesUseCaseProvider).call();
      stRes.fold((_) => null, (list) => setState(() => _filterStatuses = list));
    } catch (_) {}
    try {
      final pRes = await ref.read(getSupportPrioritiesUseCaseProvider).call();
      pRes.fold(
        (_) => null,
        (list) => setState(() => _filterPriorities = list),
      );
    } catch (_) {}
    try {
      final sRes = await ref.read(getSupportServicesUseCaseProvider).call();
      sRes.fold((_) => null, (list) => setState(() => _filterServices = list));
    } catch (_) {}
    try {
      final lRes = await ref.read(getSupportLocationsUseCaseProvider).call();
      lRes.fold((_) => null, (list) => setState(() => _filterLocations = list));
    } catch (_) {}
    try {
      final dRes = await ref.read(getSupportDepartmentsUseCaseProvider).call();
      dRes.fold(
        (_) => null,
        (list) => setState(() => _filterDepartments = list),
      );
    } catch (_) {}
    try {
      final cRes = await ref.read(getSupportCategoriesUseCaseProvider).call();
      cRes.fold(
        (_) => null,
        (list) => setState(() => _filterCategories = list),
      );
    } catch (_) {}
    try {
      final supRes = await ref
          .read(getSupportSupervisorsUseCaseProvider)
          .call();
      supRes.fold(
        (_) => null,
        (list) => setState(() => _filterSupervisors = list),
      );
    } catch (_) {}
    try {
      final custRes = await ref.read(getCustomersUseCaseProvider).call();
      custRes.fold(
        (_) => null,
        (list) => setState(() => _filterCustomers = list),
      );
    } catch (_) {}
    try {
      final uRes = await ref.read(getUsersUseCaseProvider).call();
      uRes.fold((_) => null, (list) => setState(() => _filterUsers = list));
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _filterDateFromCtrl.dispose();
    _filterDateToCtrl.dispose();
    super.dispose();
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat.yMMMd().format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supportNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final expectedTabCount = availableStatuses.isNotEmpty
        ? availableStatuses.length
        : 1;
    if (_tabController.length != expectedTabCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        var newIndex = _tabController.index;
        if (newIndex < 0) newIndex = 0;
        if (newIndex >= expectedTabCount) newIndex = expectedTabCount - 1;

        final newController = TabController(
          length: expectedTabCount,
          vsync: this,
          initialIndex: newIndex,
        );
        setState(() {
          final old = _tabController;
          _tabController = newController;
          old.dispose();
        });
      });
    }

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
          title: 'Support Tickets',
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.smart_toy_rounded, size: 22),
            //   color: AppColors.white,
            //   tooltip: 'AI Assistant',
            //   onPressed: () => Navigator.of(context).pushNamed('/support/ai'),
            // ),
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
            Builder(
              builder: (context) => IconButton(
                icon: Icon(LucideIcons.filter, size: 20.r),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                color: AppColors.white,
              ),
            ),
          ],
        ),
        endDrawer: _buildFilterDrawer(context),
        body: Column(
          children: [
            // Search Bar (when active)
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
                        hintText: 'Search tickets...',
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

            // Stats Header
            DashboardStatsRow(
              visible: _showStats,
              cards: state.maybeWhen(
                loading: () =>
                    List.generate(5, (_) => const DashboardStatCardSkeleton()),
                orElse: () => [
                  DashboardStatCard(
                    label: 'Total',
                    count: _getTotalCount(state),
                    icon: Icons.support_agent_rounded,
                    borderColor: AppColors.primary,
                  ),
                  DashboardStatCard(
                    label: 'Open',
                    count: _getOpenCount(state),
                    icon: Icons.lock_open_rounded,
                    borderColor: Colors.blue,
                  ),
                  DashboardStatCard(
                    label: 'In Progress',
                    count: _getInProgressCount(state),
                    icon: Icons.hourglass_top_rounded,
                    borderColor: Colors.orange,
                  ),
                  DashboardStatCard(
                    label: 'Resolved',
                    count: _getResolvedCount(state),
                    icon: Icons.check_circle_rounded,
                    borderColor: Colors.green,
                  ),
                  DashboardStatCard(
                    label: 'Awaiting Spares',
                    count: _getAwaitingSparesCount(state),
                    icon: Icons.build_circle_rounded,
                    borderColor: Colors.purple,
                  ),
                  DashboardStatCard(
                    label: 'Awaiting PO',
                    count: _getAwaitingPOCount(state),
                    icon: Icons.shopping_cart_rounded,
                    borderColor: Colors.pink,
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: availableStatuses.isNotEmpty
                  ? TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: availableStatuses
                          .map((s) => Tab(text: s.status ?? 'Unknown'))
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

            // Main Content
            Expanded(
              child: state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => _buildTicketSkeletons(),
                error: (msg) => Center(
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
                          'Failed to load tickets',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1A2634),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          msg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        AppButton(
                          text: 'Retry',
                          icon: Icon(AppIcons.refreshCcwRounded),
                          onPressed: () => ref
                              .read(supportNotifierProvider.notifier)
                              .loadTickets(),
                        ),
                      ],
                    ),
                  ),
                ),
                loaded: (tickets, _, __, ___) =>
                    _buildTicketList(context, tickets),
              ),
            ),
          ],
        ),
        floatingActionButton: ScrollAwareFab(
          controller: _scrollController,
          onPressed: () async {
            final result = await Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CreateTicketPage()));

            // If a ticket was created, the result might be the ticket code or true
            if (result != null) {
              // Invalidate cache and reload tickets after creating
              ref.read(supportRepositoryProvider).invalidateCache();
              await ref.read(supportNotifierProvider.notifier).loadTickets();

              // Clear search and drawer filters to make sure the ticket is visible
              if (mounted) {
                setState(() {
                  _searchController.clear();
                  _isSearching = false;
                  _selectedFilterStatus = null;
                  _selectedFilterPriority = null;
                  _selectedFilterService = null;
                  _selectedFilterLocation = null;
                  _selectedFilterDepartment = null;
                  _selectedFilterCategory = null;
                  _selectedFilterSupervisor = null;
                  _selectedFilterCustomer = null;
                  _selectedFilterUser = null;
                  _filterDateRangeType = null;
                  _filterDateFrom = null;
                  _filterDateTo = null;
                  _filterDateFromCtrl.clear();
                  _filterDateToCtrl.clear();
                });
              }

              // Switch to 'Open' tab because new tickets are usually 'Open'
              if (availableStatuses.isNotEmpty) {
                final openIdx = availableStatuses.indexWhere(
                  (s) => s.status?.toLowerCase() == 'open',
                );
                if (openIdx != -1) {
                  if (_tabController.index != openIdx) {
                    _tabController.animateTo(openIdx);
                  } else {
                    // Already on Open tab, but need to force rebuild to show new tickets
                    if (mounted) setState(() {});
                  }
                }
              }
            }
          },
          icon: isDark
              ? const Icon(LucideIcons.plus, size: 20)
              : const Icon(LucideIcons.plus, size: 20, color: Colors.white),
          label: 'New Ticket',
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }

  int _getTotalCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets, _, __, ___) => tickets.length,
      orElse: () => 0,
    );
  }

  int _getOpenCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets, _, __, ___) => tickets.where((t) {
        final status = t.status?.status?.toLowerCase() ?? '';
        return status == 'open';
      }).length,
      orElse: () => 0,
    );
  }

  int _getInProgressCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets, _, __, ___) => tickets.where((t) {
        final status = t.status?.status?.toLowerCase() ?? '';
        return status == 'in progress' || status == 'in_progress';
      }).length,
      orElse: () => 0,
    );
  }

  int _getResolvedCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets, _, __, ___) => tickets.where((t) {
        final status = t.status?.status?.toLowerCase() ?? '';
        return status == 'resolved' || status == 'closed';
      }).length,
      orElse: () => 0,
    );
  }

  int _getAwaitingSparesCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets, _, __, ___) => tickets.where((t) {
        final status = t.status?.status?.toLowerCase() ?? '';
        return status == 'awaiting spares' || status == 'awaiting_spares';
      }).length,
      orElse: () => 0,
    );
  }

  int _getAwaitingPOCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets, _, __, ___) => tickets.where((t) {
        final status = t.status?.status?.toLowerCase() ?? '';
        return status == 'awaiting po' || status == 'awaiting_po';
      }).length,
      orElse: () => 0,
    );
  }

  Widget _buildTicketList(BuildContext context, List<SupportTicket> tickets) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    var filteredTickets = tickets.where((t) {
      final searchTerm = _searchController.text.toLowerCase();
      if (searchTerm.isEmpty) return true;
      return (t.subject?.toLowerCase().contains(searchTerm) ?? false) ||
          (t.ticketCode?.toLowerCase().contains(searchTerm) ?? false) ||
          (t.customer?.name?.toLowerCase().contains(searchTerm) ?? false);
    }).toList();

    // Sort by createdAt descending (newest first)
    filteredTickets.sort((a, b) {
      final aDate = a.createdAt != null
          ? DateTime.tryParse(a.createdAt!)
          : null;
      final bDate = b.createdAt != null
          ? DateTime.tryParse(b.createdAt!)
          : null;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });

    // --- 1. Tab Status Filter (Always Apply) ---
    if (availableStatuses.isNotEmpty) {
      final idx = _tabController.index;
      if (idx >= 0 && idx < availableStatuses.length) {
        final selectedStatusTab =
            availableStatuses[idx].status?.toLowerCase() ?? '';
        filteredTickets = filteredTickets.where((t) {
          final ticketStatus = t.status?.status?.toLowerCase() ?? '';
          return ticketStatus == selectedStatusTab;
        }).toList();
      }
    }

    // --- 2. Drawer Filters (AND Logic: Each narrows the results) ---
    if (_selectedFilterStatus != null) {
      filteredTickets = filteredTickets.where((t) {
        return t.status?.id == _selectedFilterStatus!.id;
      }).toList();
    }
    if (_selectedFilterPriority != null) {
      filteredTickets = filteredTickets.where((t) {
        return t.priority?.id == _selectedFilterPriority!.id;
      }).toList();
    }
    if (_selectedFilterService != null) {
      filteredTickets = filteredTickets.where((t) {
        return t.services != null &&
            t.services!.contains(_selectedFilterService!.name);
      }).toList();
    }
    if (_selectedFilterLocation != null) {
      filteredTickets = filteredTickets.where((t) {
        return t.location == _selectedFilterLocation!.name;
      }).toList();
    }
    if (_selectedFilterDepartment != null) {
      filteredTickets = filteredTickets.where((t) {
        return t.department == _selectedFilterDepartment!.name;
      }).toList();
    }
    if (_selectedFilterCategory != null) {
      filteredTickets = filteredTickets.where((t) {
        return t.category == _selectedFilterCategory!.name;
      }).toList();
    }
    if (_selectedFilterSupervisor != null) {
      filteredTickets = filteredTickets.where((t) {
        return t.supervisors != null &&
            t.supervisors!.contains(_selectedFilterSupervisor!.user?.name);
      }).toList();
    }
    if (_selectedFilterCustomer != null) {
      filteredTickets = filteredTickets.where((t) {
        return t.customer?.id == _selectedFilterCustomer!.id;
      }).toList();
    }
    if (_selectedFilterUser != null) {
      filteredTickets = filteredTickets.where((t) {
        return t.assignUser?.id == _selectedFilterUser!.id;
      }).toList();
    }

    // --- 3. Date Range Filter (AND Logic) ---
    if (_filterDateRangeType != null ||
        (_filterDateFrom != null || _filterDateTo != null)) {
      final now = DateTime.now();
      DateTime? startDate;
      DateTime? endDate;

      if (_filterDateRangeType == 'daily') {
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      } else if (_filterDateRangeType == 'weekly') {
        final offset = now.weekday - 1;
        startDate = DateTime(now.year, now.month, now.day - offset);
        endDate = DateTime(
          startDate.year,
          startDate.month,
          startDate.day + 6,
          23,
          59,
          59,
        );
      } else if (_filterDateRangeType == 'monthly') {
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      } else if (_filterDateRangeType == 'annually') {
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31, 23, 59, 59);
      } else if (_filterDateRangeType == 'custom') {
        startDate = _filterDateFrom != null
            ? DateTime(
                _filterDateFrom!.year,
                _filterDateFrom!.month,
                _filterDateFrom!.day,
              )
            : null;
        endDate = _filterDateTo != null
            ? DateTime(
                _filterDateTo!.year,
                _filterDateTo!.month,
                _filterDateTo!.day,
                23,
                59,
                59,
              )
            : null;
      }

      if (startDate != null || endDate != null) {
        filteredTickets = filteredTickets.where((t) {
          if (t.createdAt == null) return false;
          try {
            final dt = DateTime.parse(t.createdAt!).toLocal();
            if (startDate != null && dt.isBefore(startDate)) return false;
            if (endDate != null && dt.isAfter(endDate)) return false;
            return true;
          } catch (_) {
            return false;
          }
        }).toList();
      }
    }

    if (filteredTickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent_rounded,
              size: 80.r,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'No tickets found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try adjusting your search'
                  : 'Create your first support ticket',
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
        // Invalidate the repository cache so we fetch fresh data
        ref.read(supportRepositoryProvider).invalidateCache();
        await ref.read(supportNotifierProvider.notifier).loadTickets();
      },
      color: const Color(0xFF4A6FA5),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16.r),
        itemCount: filteredTickets.length,
        itemBuilder: (context, idx) {
          final t = filteredTickets[idx];
          return _buildTicketCard(context, t);
        },
      ),
    );
  }

  Widget _buildTicketSkeletons() {
    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, __) => _TicketSkeletonCard(),
    );
  }

  Widget _buildTicketCard(BuildContext context, SupportTicket ticket) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priorityColor = ticket.priority?.color != null
        ? HexColor.fromHex(ticket.priority!.color!)
        : Colors.grey;

    String formattedDate = _formatDate(ticket.createdAt);

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
          width: 1,
        ),
      ),
      color: isDark ? const Color(0xFF151A2E) : Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SupportViewPage(ticket: ticket)),
          );
        },
        onLongPress: () {
          context.showAppModal(
            title: ticket.ticketCode ?? 'Ticket',
            subtitle: ticket.subject,
            icon: Icons.support_agent_rounded,
            expandContent: true,
            content: DefaultTabController(
              length: 4,
              child: TicketDetailContent(ticket: ticket),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
            height: MediaQuery.of(context).size.height * 0.85,
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: ticket code + status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.ticketCode ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : Colors.grey.shade800,
                        fontSize: 12.sp,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            color: _getStatusColor(ticket.status?.status ?? ''),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          ticket.status?.status ?? 'Unknown',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Subject
              Text(
                ticket.subject ?? 'No subject',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 6.h),

              // Customer row
              Row(
                children: [
                  CircleAvatar(
                    radius: 11.r,
                    backgroundColor: const Color(0xFF4A6FA5).withOpacity(0.1),
                    child: Text(
                      ticket.customer?.name?.substring(0, 1).toUpperCase() ??
                          '?',
                      style: TextStyle(
                        color: const Color(0xFF4A6FA5),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      ticket.customer?.name ?? '-',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              // Footer
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12.r,
                    color: isDark ? Colors.white24 : Colors.grey.shade400,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isDark ? Colors.white24 : Colors.grey.shade400,
                    ),
                  ),
                  const Spacer(),
                  // Priority indicator moved here
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.03)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          ticket.priority?.priority ?? 'Normal',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _TicketSkeletonCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
          width: 1,
        ),
      ),
      color: isDark ? const Color(0xFF151A2E) : Colors.white,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 14.h,
                width: 120.w,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 12.h,
                width: 180.w,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Container(
                    height: 10.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white12 : Colors.grey.shade300,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFF4A6FA5);
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Widget _buildFilterDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : Colors.grey.shade700;

    Widget sectionLabel(String label) => Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: labelColor,
          letterSpacing: 0.3,
        ),
      ),
    );

    Widget pickerField({
      required String hint,
      required String? value,
      required VoidCallback onTap,
      required VoidCallback onClear,
      required IconData icon,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: value != null
                  ? AppColors.primary.withOpacity(0.5)
                  : (isDark ? Colors.white12 : Colors.grey.shade200),
              width: value != null ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16.r,
                color: value != null
                    ? AppColors.primary
                    : (isDark ? Colors.white38 : Colors.grey.shade500),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  value ?? hint,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: value != null
                        ? (isDark ? Colors.white : const Color(0xFF1A2634))
                        : (isDark ? Colors.white38 : Colors.grey.shade500),
                    fontWeight: value != null
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (value != null)
                GestureDetector(
                  onTap: onClear,
                  child: Icon(
                    Icons.close_rounded,
                    size: 16.r,
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                  ),
                )
              else
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18.r,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
            ],
          ),
        ),
      );
    }

    Widget dateChip(String label, String key) {
      final active = _filterDateRangeType == key;
      return GestureDetector(
        onTap: () => key == 'custom'
            ? setState(() {
                _filterDateRangeType = 'custom';
                _filterDateFrom = null;
                _filterDateTo = null;
                _filterDateFromCtrl.clear();
                _filterDateToCtrl.clear();
              })
            : _selectFilterPreset(key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                  : (isDark ? Colors.white24 : Colors.grey.shade300),
              width: active ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              color: active
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : Colors.grey.shade700),
            ),
          ),
        ),
      );
    }

    return Drawer(
      width: 0.85.sw,
      backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
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
                    'Filter Tickets',
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

          // ── Scrollable Body ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─ Date Range Chips ─────────────────────────────────
                  sectionLabel('Date Range'),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      dateChip('Daily', 'daily'),
                      dateChip('Weekly', 'weekly'),
                      dateChip('Monthly', 'monthly'),
                      dateChip('Annually', 'annually'),
                      dateChip('Custom Range', 'custom'),
                    ],
                  ),

                  // ─ Custom date inputs ────────────────────────────────
                  if (_filterDateRangeType == 'custom') ...[
                    SizedBox(height: 14.h),
                    sectionLabel('Date From'),
                    AppTextField(
                      controller: _filterDateFromCtrl,
                      hintText: 'Select start date',
                      readOnly: true,
                      onTap: () => _pickFilterDate(true),
                      prefixIcon: Icon(
                        LucideIcons.calendar,
                        size: 16.r,
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                      suffixIcon: _filterDateFrom != null
                          ? IconButton(
                              icon: Icon(
                                LucideIcons.x,
                                size: 14.r,
                                color: Colors.grey,
                              ),
                              onPressed: () => setState(() {
                                _filterDateFrom = null;
                                _filterDateFromCtrl.clear();
                              }),
                            )
                          : Icon(
                              LucideIcons.chevronDown,
                              size: 16.r,
                              color: Colors.grey,
                            ),
                    ),
                    SizedBox(height: 14.h),
                    sectionLabel('Date To'),
                    AppTextField(
                      controller: _filterDateToCtrl,
                      hintText: 'Select end date',
                      readOnly: true,
                      onTap: () => _pickFilterDate(false),
                      prefixIcon: Icon(
                        LucideIcons.calendar,
                        size: 16.r,
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                      suffixIcon: _filterDateTo != null
                          ? IconButton(
                              icon: Icon(
                                LucideIcons.x,
                                size: 14.r,
                                color: Colors.grey,
                              ),
                              onPressed: () => setState(() {
                                _filterDateTo = null;
                                _filterDateToCtrl.clear();
                              }),
                            )
                          : Icon(
                              LucideIcons.chevronDown,
                              size: 16.r,
                              color: Colors.grey,
                            ),
                    ),
                  ],

                  SizedBox(height: 20.h),

                  // ─ Status ────────────────────────────────────────────
                  sectionLabel('Status'),
                  pickerField(
                    hint: 'All statuses',
                    value: _selectedFilterStatus?.status,
                    icon: Icons.flag_rounded,
                    onClear: () => setState(() => _selectedFilterStatus = null),
                    onTap: () async {
                      final r = await _pickFromList<SupportStatus>(
                        title: 'Select Status',
                        items: _filterStatuses,
                        display: (s) => s.status ?? 'Unknown',
                        current: _selectedFilterStatus,
                        equals: (a, b) => a.id == b.id,
                      );
                      setState(() => _selectedFilterStatus = r);
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ─ Priority ──────────────────────────────────────────
                  sectionLabel('Priority'),
                  pickerField(
                    hint: 'All priorities',
                    value: _selectedFilterPriority?.priority,
                    icon: Icons.low_priority_rounded,
                    onClear: () =>
                        setState(() => _selectedFilterPriority = null),
                    onTap: () async {
                      final r = await _pickFromList<Priority>(
                        title: 'Select Priority',
                        items: _filterPriorities,
                        display: (p) => p.priority ?? 'Unknown',
                        current: _selectedFilterPriority,
                        equals: (a, b) => a.id == b.id,
                      );
                      setState(() => _selectedFilterPriority = r);
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ─ Service ───────────────────────────────────────────
                  sectionLabel('Service'),
                  pickerField(
                    hint: 'All services',
                    value: _selectedFilterService?.name,
                    icon: Icons.room_service_rounded,
                    onClear: () =>
                        setState(() => _selectedFilterService = null),
                    onTap: () async {
                      final r = await _pickFromList<SupportService>(
                        title: 'Select Service',
                        items: _filterServices,
                        display: (s) => s.name ?? 'Unknown',
                        current: _selectedFilterService,
                        equals: (a, b) => a.name == b.name,
                      );
                      setState(() => _selectedFilterService = r);
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ─ Location ──────────────────────────────────────────
                  sectionLabel('Location'),
                  pickerField(
                    hint: 'All locations',
                    value: _selectedFilterLocation?.name,
                    icon: Icons.location_on_rounded,
                    onClear: () =>
                        setState(() => _selectedFilterLocation = null),
                    onTap: () async {
                      final r = await _pickFromList<SupportLocation>(
                        title: 'Select Location',
                        items: _filterLocations,
                        display: (l) => l.name ?? 'Unknown',
                        current: _selectedFilterLocation,
                        equals: (a, b) => a.name == b.name,
                      );
                      setState(() => _selectedFilterLocation = r);
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ─ Department ────────────────────────────────────────
                  sectionLabel('Department'),
                  pickerField(
                    hint: 'All departments',
                    value: _selectedFilterDepartment?.name,
                    icon: Icons.business_rounded,
                    onClear: () =>
                        setState(() => _selectedFilterDepartment = null),
                    onTap: () async {
                      final r = await _pickFromList<SupportDepartment>(
                        title: 'Select Department',
                        items: _filterDepartments,
                        display: (d) => d.name ?? 'Unknown',
                        current: _selectedFilterDepartment,
                        equals: (a, b) => a.name == b.name,
                      );
                      setState(() => _selectedFilterDepartment = r);
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ─ Category ──────────────────────────────────────────
                  sectionLabel('Category'),
                  pickerField(
                    hint: 'All categories',
                    value: _selectedFilterCategory?.name,
                    icon: Icons.category_rounded,
                    onClear: () =>
                        setState(() => _selectedFilterCategory = null),
                    onTap: () async {
                      final r = await _pickFromList<SupportCategory>(
                        title: 'Select Category',
                        items: _filterCategories,
                        display: (c) => c.name ?? 'Unknown',
                        current: _selectedFilterCategory,
                        equals: (a, b) => a.name == b.name,
                      );
                      setState(() => _selectedFilterCategory = r);
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ─ Customer ──────────────────────────────────────────
                  sectionLabel('Customer'),
                  pickerField(
                    hint: 'All customers',
                    value: _selectedFilterCustomer?.name,
                    icon: Icons.person_rounded,
                    onClear: () =>
                        setState(() => _selectedFilterCustomer = null),
                    onTap: () async {
                      final r = await _pickFromList<Customer>(
                        title: 'Select Customer',
                        items: _filterCustomers,
                        display: (c) => c.name ?? 'Unknown',
                        current: _selectedFilterCustomer,
                        equals: (a, b) => a.id == b.id,
                      );
                      setState(() => _selectedFilterCustomer = r);
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ─ Supervisor ────────────────────────────────────────
                  sectionLabel('Supervisor'),
                  pickerField(
                    hint: 'All supervisors',
                    value: _selectedFilterSupervisor?.user?.name,
                    icon: Icons.supervisor_account_rounded,
                    onClear: () =>
                        setState(() => _selectedFilterSupervisor = null),
                    onTap: () async {
                      final r = await _pickFromList<SupportSupervisor>(
                        title: 'Select Supervisor',
                        items: _filterSupervisors,
                        display: (s) => s.user?.name ?? 'Unknown',
                        current: _selectedFilterSupervisor,
                        equals: (a, b) => a.user?.id == b.user?.id,
                      );
                      setState(() => _selectedFilterSupervisor = r);
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ─ Assignee ──────────────────────────────────────────
                  sectionLabel('Assignee'),
                  pickerField(
                    hint: 'All assignees',
                    value: _selectedFilterUser?.name,
                    icon: Icons.people_rounded,
                    onClear: () => setState(() => _selectedFilterUser = null),
                    onTap: () async {
                      final r = await _pickFromList<User>(
                        title: 'Select Assignee',
                        items: _filterUsers,
                        display: (u) => u.name ?? 'Unknown',
                        current: _selectedFilterUser,
                        equals: (a, b) => a.id == b.id,
                      );
                      setState(() => _selectedFilterUser = r);
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // ── Bottom Buttons ────────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilterStatus = null;
                        _selectedFilterPriority = null;
                        _selectedFilterService = null;
                        _selectedFilterLocation = null;
                        _selectedFilterDepartment = null;
                        _selectedFilterCategory = null;
                        _selectedFilterSupervisor = null;
                        _selectedFilterCustomer = null;
                        _selectedFilterUser = null;
                        _filterDateRangeType = null;
                        _filterDateFrom = null;
                        _filterDateTo = null;
                        _filterDateFromCtrl.clear();
                        _filterDateToCtrl.clear();
                      });
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? Colors.white70
                          : Colors.grey.shade700,
                      side: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
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
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
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

  String _fmtFilterDate(DateTime? d) {
    if (d == null) return '';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  void _selectFilterPreset(String type) {
    final now = DateTime.now();
    late DateTime from, to;
    switch (type) {
      case 'daily':
        from = DateTime(now.year, now.month, now.day);
        to = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'weekly':
        final offset = now.weekday - 1;
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
      _filterDateRangeType = type;
      _filterDateFrom = from;
      _filterDateTo = to;
      _filterDateFromCtrl.text = _fmtFilterDate(from);
      _filterDateToCtrl.text = _fmtFilterDate(to);
    });
  }

  Future<void> _pickFilterDate(bool isFrom) async {
    final initial = isFrom
        ? (_filterDateFrom ?? DateTime.now())
        : (_filterDateTo ?? DateTime.now());
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
    if (picked == null || !mounted) return;
    setState(() {
      if (isFrom) {
        _filterDateFrom = picked;
        _filterDateFromCtrl.text = _fmtFilterDate(picked);
      } else {
        _filterDateTo = picked;
        _filterDateToCtrl.text = _fmtFilterDate(picked);
      }
      _filterDateRangeType = 'custom';
    });
  }

  Future<T?> _pickFromList<T>({
    required String title,
    required List<T> items,
    required String Function(T) display,
    required T? current,
    bool Function(T, T)? equals,
  }) async {
    T? result = current;
    await showModalBottomSheet<void>(
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
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: isDark
                        ? Colors.white12
                        : Colors.grey.shade200,
                    child: const Icon(
                      Icons.clear_rounded,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                  title: Text(
                    'All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                  trailing: current == null
                      ? Icon(
                          LucideIcons.checkCircle,
                          color: AppColors.primary,
                          size: 18.r,
                        )
                      : null,
                  onTap: () {
                    result = null;
                    Navigator.pop(ctx);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final name = display(item);
                      final isSelected =
                          current != null &&
                          (equals != null
                              ? equals(item, current)
                              : item == current);
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
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                      ? Colors.white
                                      : const Color(0xFF1A2634)),
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                LucideIcons.checkCircle,
                                color: AppColors.primary,
                                size: 18.r,
                              )
                            : null,
                        onTap: () {
                          result = item;
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
    return result;
  }
}

// small hex color helper
class HexColor extends Color {
  HexColor(super.hex);
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
