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
import '../../data/repositories/support_repository_impl.dart';
import '../../domain/entities/support_department.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_modal.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/dashboard_stat_card.dart';
import '../../../../core/widgets/dashboard_stats_row.dart';
import '../../../../core/widgets/app_smart_dropdown.dart';
import '../../domain/entities/support_category.dart';
import '../../domain/entities/support_supervisor.dart';
import '../../domain/entities/assigned_user.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../customer/presentation/providers/customer_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/jobcard/presentation/widgets/searchable_dialog.dart';
import 'package:intl/intl.dart';

import '../widgets/ticket_detail_content.dart';
import 'support_view_page.dart';
import 'create_ticket_page.dart';

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
  String _selectedDateRange = 'All Time';
  DateTimeRange? _customDateRange;

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
      stRes.fold(
        (_) => null,
        (list) => setState(() => _filterStatuses = list),
      );
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
      final supRes = await ref.read(getSupportSupervisorsUseCaseProvider).call();
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
      uRes.fold(
        (_) => null,
        (list) => setState(() => _filterUsers = list),
      );
    } catch (_) {}
  }

  /// Shared card decoration
  BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  /// Shared selector decoration
  InputDecoration _selectorDecoration({
    required String label,
    required IconData icon,
    required Color primary,
    required bool isDark,
  }) =>
      InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.grey.shade600,
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(icon, size: 20.r, color: primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      );

  Widget _selectorArrow(bool isDark) => Icon(
        Icons.keyboard_arrow_down_rounded,
        color: isDark ? Colors.white54 : Colors.grey.shade600,
        size: 20.r,
      );

  /// Reusable dropdown selector
  Widget _buildDropdownCard<T>({
    required BuildContext context,
    required bool isDark,
    required Color primary,
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemDisplay,
    required void Function(T?) onChanged,
    bool Function(T, T)? itemEquals,
  }) {
    // Find the actual instance in `items` that matches `value`
    T? matchedValue;
    if (value != null) {
      try {
        matchedValue = items.firstWhere(
          (item) => itemEquals != null ? itemEquals(item, value) : item == value,
        );
      } catch (_) {
        matchedValue = null;
      }
    }

    return Container(
      decoration: _cardDecoration(isDark),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<T?>(
          value: matchedValue,
          isExpanded: true,
          decoration: _selectorDecoration(
            label: label,
            icon: icon,
            primary: primary,
            isDark: isDark,
          ),
          dropdownColor: isDark ? const Color(0xFF151A2E) : Colors.white,
          icon: _selectorArrow(isDark),
          items: [
            DropdownMenuItem<T?>(
              value: null,
              child: Text(
                'All',
                style: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey.shade600,
                  fontSize: 13.sp,
                ),
              ),
            ),
            ...items.map((item) {
              return DropdownMenuItem<T?>(
                value: item,
                child: Text(
                  itemDisplay(item),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                    fontSize: 13.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
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

    ref.listen<SupportState>(supportNotifierProvider, (prev, next) {
      final prevLoading =
          prev?.maybeWhen(loading: () => true, orElse: () => false) ?? false;
      final nextLoading = next.maybeWhen(
        loading: () => true,
        orElse: () => false,
      );

      if (prevLoading == nextLoading) return;

      if (nextLoading) {
        showAppLoadingDialog(context, message: 'Fetching tickets...');
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
              cards: [
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
                  borderColor: Colors.purple
                  ),

                  DashboardStatCard(
                    label: 'Awaiting PO',
                    count: _getAwaitingPOCount(state),
                    icon: Icons.shopping_cart_rounded,
                    borderColor: Colors.pink,
                  ),
              ],
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
                loading: () => const Center(),
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
                          icon: Icons.refresh_rounded,
                          onPressed: () => ref
                              .read(supportNotifierProvider.notifier)
                              .loadTickets(),
                          variant: AppButtonVariant.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                loaded: (tickets, _, __, ___) => _buildTicketList(context, tickets),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateTicketPage()),
            );

            // If a ticket was created, the result might be the ticket code or true
            if (result != null) {
              // Invalidate cache and reload tickets after creating
              final repo = ref.read(supportRepositoryProvider);
              if (repo is SupportRepositoryImpl) {
                repo.invalidateCache();
              }
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
                  _selectedDateRange = 'All Time';
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
          label: Text('New Ticket', style: TextStyle(fontSize: 14.sp)),
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
      final aDate = a.createdAt != null ? DateTime.tryParse(a.createdAt!) : null;
      final bDate = b.createdAt != null ? DateTime.tryParse(b.createdAt!) : null;
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
    if (_selectedDateRange != 'All Time') {
      final now = DateTime.now();
      DateTime startDate;
      DateTime endDate = now;

      if (_selectedDateRange == 'Today') {
        startDate = DateTime(now.year, now.month, now.day);
      } else if (_selectedDateRange == 'This Week') {
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
      } else if (_selectedDateRange == 'This Month') {
        startDate = DateTime(now.year, now.month, 1);
      } else if (_selectedDateRange == 'This Year') {
        startDate = DateTime(now.year, 1, 1);
      } else if (_selectedDateRange == 'Custom Range' && _customDateRange != null) {
        startDate = _customDateRange!.start;
        endDate = _customDateRange!.end;
      } else {
        startDate = DateTime(1970);
      }

      filteredTickets = filteredTickets.where((t) {
        if (t.createdAt == null) return false;
        try {
          final dt = DateTime.parse(t.createdAt!).toLocal();
          final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
          return dt.isAfter(startDate.subtract(const Duration(milliseconds: 1))) && 
                 dt.isBefore(endOfDay.add(const Duration(milliseconds: 1)));
        } catch (_) {
          return false;
        }
      }).toList();
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
      onRefresh: () async {
        // Invalidate the repository cache so we fetch fresh data
        final repo = ref.read(supportRepositoryProvider);
        if (repo is SupportRepositoryImpl) {
          repo.invalidateCache();
        }
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
                      color: _getStatusColor(ticket.status?.status ?? '').withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12.r),
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
                            color: _getStatusColor(ticket.status?.status ?? ''),
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
                      color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
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
                            color: isDark ? Colors.white54 : Colors.grey.shade700,
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

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
      child: Column(
        children: [
          // Header with Primary Color
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20.h,
              bottom: 20.h,
              left: 20.w,
              right: 16.w,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0A0E21) : AppColors.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Tickets',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      // status filter
                      _buildDropdownCard<SupportStatus>(
                        context: context,
                        isDark: isDark,
                        primary: AppColors.primary,
                        label: 'Status',
                        icon: Icons.flag_rounded,
                        value: _selectedFilterStatus,
                        items: _filterStatuses,
                        itemDisplay: (s) => s.status ?? 'Unknown',
                        itemEquals: (a, b) => a.id == b.id,
                        onChanged: (val) {
                          setState(() => _selectedFilterStatus = val);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // priority filter
                      _buildDropdownCard<Priority>(
                        context: context,
                        isDark: isDark,
                        primary: AppColors.primary,
                        label: 'Priority',
                        icon: Icons.low_priority_rounded,
                        value: _selectedFilterPriority,
                        items: _filterPriorities,
                        itemDisplay: (p) => p.priority ?? 'Unknown',
                        itemEquals: (a, b) => a.id == b.id,
                        onChanged: (val) {
                          setState(() => _selectedFilterPriority = val);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // service filter
                      _buildDropdownCard<SupportService>(
                        context: context,
                        isDark: isDark,
                        primary: AppColors.primary,
                        label: 'Service',
                        icon: Icons.room_service_rounded,
                        value: _selectedFilterService,
                        items: _filterServices,
                        itemDisplay: (s) => s.name ?? 'Unknown',
                        itemEquals: (a, b) => a.name == b.name,
                        onChanged: (val) {
                          setState(() => _selectedFilterService = val);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // location filter
                      _buildDropdownCard<SupportLocation>(
                        context: context,
                        isDark: isDark,
                        primary: AppColors.primary,
                        label: 'Location',
                        icon: Icons.location_on_rounded,
                        value: _selectedFilterLocation,
                        items: _filterLocations,
                        itemDisplay: (l) => l.name ?? 'Unknown',
                        itemEquals: (a, b) => a.name == b.name,
                        onChanged: (val) {
                          setState(() => _selectedFilterLocation = val);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // department filter
                      _buildDropdownCard<SupportDepartment>(
                        context: context,
                        isDark: isDark,
                        primary: AppColors.primary,
                        label: 'Department',
                        icon: Icons.business_rounded,
                        value: _selectedFilterDepartment,
                        items: _filterDepartments,
                        itemDisplay: (d) => d.name ?? 'Unknown',
                        itemEquals: (a, b) => a.name == b.name,
                        onChanged: (val) {
                          setState(() => _selectedFilterDepartment = val);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // category filter
                      _buildDropdownCard<SupportCategory>(
                        context: context,
                        isDark: isDark,
                        primary: AppColors.primary,
                        label: 'Category',
                        icon: Icons.category_rounded,
                        value: _selectedFilterCategory,
                        items: _filterCategories,
                        itemDisplay: (c) => c.name ?? 'Unknown',
                        itemEquals: (a, b) => a.name == b.name,
                        onChanged: (val) {
                          setState(() => _selectedFilterCategory = val);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // customer filter
                      _buildDropdownCard<Customer>(
                        context: context,
                        isDark: isDark,
                        primary: AppColors.primary,
                        label: 'Customer',
                        icon: Icons.person_rounded,
                        value: _selectedFilterCustomer,
                        items: _filterCustomers,
                        itemDisplay: (c) => c.name ?? 'Unknown',
                        itemEquals: (a, b) => a.id == b.id,
                        onChanged: (val) {
                          setState(() => _selectedFilterCustomer = val);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // supervisor filter
                      _buildDropdownCard<SupportSupervisor>(
                        context: context,
                        isDark: isDark,
                        primary: AppColors.primary,
                        label: 'Supervisor',
                        icon: Icons.supervisor_account_rounded,
                        value: _selectedFilterSupervisor,
                        items: _filterSupervisors,
                        itemDisplay: (s) => s.user?.name ?? 'Unknown',
                        itemEquals: (a, b) => a.user?.id == b.user?.id,
                        onChanged: (val) {
                          setState(() => _selectedFilterSupervisor = val);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // assignee filter
                      _buildDropdownCard<User>(
                        context: context,
                        isDark: isDark,
                        primary: AppColors.primary,
                        label: 'Assignee',
                        icon: Icons.people_rounded,
                        value: _selectedFilterUser,
                        items: _filterUsers,
                        itemDisplay: (u) => u.name ?? 'Unknown',
                        itemEquals: (a, b) => a.id == b.id,
                        onChanged: (val) {
                          setState(() => _selectedFilterUser = val);
                        },
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Date Range',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF1A2634)),
                      ),
                      SizedBox(height: 12.h),
                      _buildDateRangeOption('All Time'),
                      _buildDateRangeOption('Today'),
                      _buildDateRangeOption('This Week'),
                      _buildDateRangeOption('This Month'),
                      _buildDateRangeOption('This Year'),
                      _buildDateRangeOption('Custom Range'),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              // Bottom Action Buttons
              Container(
                padding: EdgeInsets.all(24.r),
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
                      child: TextButton(
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
                            _selectedDateRange = 'All Time';
                            _customDateRange = null;
                          });
                          Navigator.pop(context);
                        },
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
              ),
            ],
          ),
    );
  }

  Widget _buildDateRangeOption(String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RadioListTile<String>(
      title: Text(label, style: TextStyle(fontSize: 14.sp)),
      value: label,
      groupValue: _selectedDateRange,
      onChanged: (value) async {
        if (value == 'Custom Range') {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDateRange: _customDateRange,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: isDark 
                      ? const ColorScheme.dark(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                        )
                      : const ColorScheme.light(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                        ),
                ),
                child: child!,
              );
            },
          );
          if (range != null) {
            setState(() {
              _customDateRange = range;
              _selectedDateRange = value!;
            });
          }
        } else if (value != null) {
          setState(() {
            _selectedDateRange = value;
          });
        }
      },
      activeColor: const Color(0xFF4A6FA5),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      tileColor: isDark ? Colors.white10 : Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    );
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
