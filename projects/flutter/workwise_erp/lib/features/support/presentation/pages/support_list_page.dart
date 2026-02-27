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
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_modal.dart';
import '../../../../core/widgets/app_dialog.dart';
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

  // Back-end statuses (used to render dynamic tabs)
  List<SupportStatus> availableStatuses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(supportNotifierProvider.notifier).loadTickets();
      _loadStatuses();
    });
  }

  Future<void> _loadStatuses() async {
    try {
      final getStatuses = ref.read(getSupportStatusesUseCaseProvider);
      final res = await getStatuses.call();
      res.fold((_) => null, (list) {
        final newController = TabController(length: list.length, vsync: this);
        setState(() {
          availableStatuses = list;
          final old = _tabController;
          _tabController = newController;
          old.dispose();
        });
      });
    } catch (_) {}
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

    final expectedTabCount =
        availableStatuses.isNotEmpty ? availableStatuses.length : 1;
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
            IconButton(
              icon: const Icon(Icons.smart_toy_rounded, size: 22),
              color: AppColors.white,
              tooltip: 'AI Assistant',
              onPressed: () => Navigator.of(context).pushNamed('/support/ai'),
            ),
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
            Row(
              children: [
                SizedBox(width: 4.w),
                IconButton(
                  icon: Icon(LucideIcons.slidersHorizontal, size: 20.r),
                  onPressed: () => _showFilterSheet(context),
                  color: AppColors.white,
                ),
              ],
            ),
          ],
        ),
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
            if (_showStats)
              Padding(
                padding: EdgeInsets.all(16.r),
                child: SizedBox(
                  height: 96.h,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 150.w,
                          child: _buildStatCard(
                            'Total',
                            _getTotalCount(state),
                            Icons.support_agent_rounded,
                            AppColors.primary,
                            isDark,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          width: 150.w,
                          child: _buildStatCard(
                            'Open',
                            _getOpenCount(state),
                            Icons.lock_open_rounded,
                            Colors.blue,
                            isDark,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          width: 150.w,
                          child: _buildStatCard(
                            'In Progress',
                            _getInProgressCount(state),
                            Icons.hourglass_top_rounded,
                            Colors.orange,
                            isDark,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          width: 150.w,
                          child: _buildStatCard(
                            'Resolved',
                            _getResolvedCount(state),
                            Icons.check_circle_rounded,
                            Colors.green,
                            isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                loaded: (tickets) => _buildTicketList(context, tickets),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateTicketPage()),
            );
          },
          icon: Icon(Icons.add_rounded, size: 20.r),
          label: Text(
            'New Ticket',
            style: TextStyle(fontSize: 14.sp),
          ),
          backgroundColor: const Color(0xFF4A6FA5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
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

  int _getTotalCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets) => tickets.length,
      orElse: () => 0,
    );
  }

  int _getOpenCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets) => tickets.where((t) {
        final status = t.status?.status?.toLowerCase() ?? '';
        return status == 'open';
      }).length,
      orElse: () => 0,
    );
  }

  int _getInProgressCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets) => tickets.where((t) {
        final status = t.status?.status?.toLowerCase() ?? '';
        return status == 'in progress' || status == 'in_progress';
      }).length,
      orElse: () => 0,
    );
  }

  int _getResolvedCount(SupportState state) {
    return state.maybeWhen(
      loaded: (tickets) => tickets.where((t) {
        final status = t.status?.status?.toLowerCase() ?? '';
        return status == 'resolved' || status == 'closed';
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

    if (availableStatuses.isNotEmpty) {
      final idx = _tabController.index;
      if (idx >= 0 && idx < availableStatuses.length) {
        final selectedStatus =
            availableStatuses[idx].status?.toLowerCase() ?? '';
        filteredTickets = filteredTickets.where((t) {
          final ticketStatus = t.status?.status?.toLowerCase() ?? '';
          return ticketStatus == selectedStatus;
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
        ref.invalidate(supportNotifierProvider);
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
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
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
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Priority chip + ticket code + status badge
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          ticket.priority?.priority ?? 'Normal',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      ticket.ticketCode ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                            isDark ? Colors.white70 : Colors.grey.shade700,
                        fontSize: 13.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                                ticket.status?.status ?? ''),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          ticket.status?.status ?? 'Unknown',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Subject
              Text(
                ticket.subject ?? 'No subject',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 8.h),

              // Customer row
              Row(
                children: [
                  CircleAvatar(
                    radius: 14.r,
                    backgroundColor:
                        const Color(0xFF4A6FA5).withOpacity(0.1),
                    child: Text(
                      ticket.customer?.name
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          '?',
                      style: TextStyle(
                        color: const Color(0xFF4A6FA5),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      ticket.customer?.name ?? '-',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white70
                            : Colors.grey.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Footer
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14.r,
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark
                          ? Colors.white38
                          : Colors.grey.shade500,
                    ),
                  ),
                  const Spacer(),
                  if (ticket.replies != null &&
                      ticket.replies!.isNotEmpty) ...[
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 16.r,
                      color:
                          isDark ? Colors.white38 : Colors.grey.shade400,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      ticket.priority?.priority ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark
                            ? Colors.white38
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
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

  void _showFilterSheet(BuildContext context) {
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
                  'Filter Tickets',
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
              'Priority',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('High', false),
                _buildFilterChip('Medium', false),
                _buildFilterChip('Low', false),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'Date Range',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            _buildDateRangeOption('Today'),
            _buildDateRangeOption('This Week'),
            _buildDateRangeOption('This Month'),
            _buildDateRangeOption('Custom Range'),
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
                    child: Text(
                      'Reset',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6FA5),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(fontSize: 14.sp),
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

  Widget _buildFilterChip(String label, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(fontSize: 13.sp),
      ),
      selected: isSelected,
      onSelected: (selected) {},
      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
      selectedColor: const Color(0xFF4A6FA5).withOpacity(0.2),
      checkmarkColor: const Color(0xFF4A6FA5),
      labelStyle: TextStyle(
        color: isSelected
            ? const Color(0xFF4A6FA5)
            : (isDark ? Colors.white70 : Colors.grey.shade700),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13.sp,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isSelected
              ? const Color(0xFF4A6FA5)
              : (isDark ? Colors.white24 : Colors.grey.shade300),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildDateRangeOption(String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RadioListTile<String>(
      title: Text(
        label,
        style: TextStyle(fontSize: 14.sp),
      ),
      value: label,
      groupValue: 'Today',
      onChanged: (value) {},
      activeColor: const Color(0xFF4A6FA5),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      tileColor: isDark ? Colors.white10 : Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
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
