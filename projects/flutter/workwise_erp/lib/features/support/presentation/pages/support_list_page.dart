import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // start with minimal controller (legacy tabs removed).
    // We'll recreate the controller when statuses load.
    _tabController = TabController(length: 1, vsync: this);

    // load tickets and statuses once after first frame
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
        // create new controller before disposing the old one to avoid TabController
        // length mismatches during rebuilds (prevents painter/listener issues).
        final newController = TabController(length: list.length, vsync: this);
        setState(() {
          availableStatuses = list;
          final old = _tabController;
          _tabController = newController;
          old.dispose();
        });
      });
    } catch (_) {
      // ignore and leave legacy tabs
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supportNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Defensive repair: ensure TabController length always matches TabBar tabs.
    // This prevents the runtime assertion that can occur if async status
    // loading changes the number of tabs while the old controller is still
    // attached to the widget tree.
    final expectedTabCount = availableStatuses.isNotEmpty
        ? availableStatuses.length
        : 1;
    if (_tabController.length != expectedTabCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // clamp current index into the new range to avoid index errors
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

    // show/hide global loading dialog for ticket fetches
    // Show/hide loading dialog only on state *transitions* to avoid stacked dialogs
    ref.listen<SupportState>(supportNotifierProvider, (prev, next) {
      final prevLoading =
          prev?.maybeWhen(loading: () => true, orElse: () => false) ?? false;
      final nextLoading = next.maybeWhen(
        loading: () => true,
        orElse: () => false,
      );

      if (prevLoading == nextLoading) return; // no transition — do nothing

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
            // Search toggle
            IconButton(
              icon: Icon(
                _isSearching ? LucideIcons.x : LucideIcons.search,
                size: 20,
              ),
              color: AppColors.white,
              onPressed: () {
                setState(() {
                  if (_isSearching) _searchController.clear();
                  _isSearching = !_isSearching;
                });
              },
            ),

            // Toggle stats visibility
            IconButton(
              icon: Icon(
                _showStats ? LucideIcons.eye : LucideIcons.eyeOff,
                size: 20,
              ),
              color: AppColors.white,
              onPressed: () => setState(() => _showStats = !_showStats),
              tooltip: _showStats ? 'Hide stats' : 'Show stats',
            ),

            // Action group (th / filter)
            Row(
              children: [
                // IconButton(
                //   onPressed: null,
                //   icon: const Icon(LucideIcons.moreVertical),
                //   color: AppColors.white,
                // ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(LucideIcons.slidersHorizontal),
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
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: isDark ? Colors.white54 : AppColors.primary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            LucideIcons.x,
                            color: isDark ? Colors.white54 : AppColors.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _isSearching = false;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ),
              ),

            // Stats Header
            if (_showStats)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 96,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: _buildStatCard(
                            'Total',
                            _getTotalCount(state),
                            Icons.support_agent_rounded,
                            AppColors.primary,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 160,
                          child: _buildStatCard(
                            'Open',
                            _getOpenCount(state),
                            Icons.lock_open_rounded,
                            Colors.blue,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 160,
                          child: _buildStatCard(
                            'In Progress',
                            _getInProgressCount(state),
                            Icons.hourglass_top_rounded,
                            Colors.orange,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 160,
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

            // Enhanced Tab Bar (backend-driven only; legacy tabs removed)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: availableStatuses.isNotEmpty
                  ? TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: availableStatuses
                          .map((s) => Tab(text: s.status ?? 'Unknown'))
                          .toList(),
                      labelColor: AppColors.primary,
                      unselectedLabelColor: isDark
                          ? Colors.white54
                          : Colors.grey.shade600,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primary.withOpacity(0.15),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),

            // Main Content
            Expanded(
              child: state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const Center(
                  // child: CircularProgressIndicator(),
                ),
                error: (msg) => Center(
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
                            Icons.error_outline_rounded,
                            size: 48,
                            color: Colors.red.shade300,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Failed to load tickets',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1A2634),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          msg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
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
            await Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CreateTicketPage()));
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Ticket'),
          backgroundColor: const Color(0xFF4A6FA5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0E21) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 3)),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),

                // number placed visually at the bottom of the text column
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // faint icon on the right
          Opacity(opacity: 0.12, child: Icon(icon, size: 40, color: color)),
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

    // Filter tickets based on search
    var filteredTickets = tickets.where((t) {
      final searchTerm = _searchController.text.toLowerCase();
      if (searchTerm.isEmpty) return true;

      return (t.subject?.toLowerCase().contains(searchTerm) ?? false) ||
          (t.ticketCode?.toLowerCase().contains(searchTerm) ?? false) ||
          (t.customer?.name?.toLowerCase().contains(searchTerm) ?? false);
    }).toList();

    // Filter by selected tab based on statuses (legacy tabs removed)
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
    // otherwise show all tickets (no tab-based filtering)

    if (filteredTickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent_rounded,
              size: 80,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No tickets found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try adjusting your search'
                  : 'Create your first support ticket',
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
            if (_searchController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(16),
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

    // Derive a created/updated time from available data (prefer first reply)
    String dateStr = '';
    DateTime? when;

    if (ticket.replies != null && ticket.replies!.isNotEmpty) {
      when = ticket.replies!.first.createdAt;
    } else if (ticket.endDate != null) {
      when = DateTime.tryParse(ticket.endDate!);
    }

    if (when != null) {
      final now = DateTime.now();
      final difference = now.difference(when);

      if (difference.inDays > 0) {
        dateStr = '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        dateStr = '${difference.inHours}h ago';
      } else {
        dateStr = '${difference.inMinutes}m ago';
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      color: isDark ? const Color(0xFF151A2E) : Colors.white,
      child: InkWell(
        onTap: () {
          // open full-screen view
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SupportViewPage(ticket: ticket)),
          );
        },
        onLongPress: () {
          // show modal on long-press (keeps previous behavior)
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
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Ticket Code and Priority
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ticket.priority?.priority ?? 'Normal',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ticket.ticketCode ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(ticket.status?.status ?? ''),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ticket.status?.status ?? 'Unknown',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Subject
              Text(
                ticket.subject ?? 'No subject',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Customer Info and Description
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF4A6FA5).withOpacity(0.1),
                    child: Text(
                      ticket.customer?.name?.substring(0, 1).toUpperCase() ??
                          '?',
                      style: const TextStyle(
                        color: Color(0xFF4A6FA5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ticket.customer?.name ?? 'Unknown Customer',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              if (ticket.description != null &&
                  ticket.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  ticket.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Footer with Date and Attachment Indicator
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                  const Spacer(),
                  // show replies count (messages)
                  if (ticket.replies != null && ticket.replies!.isNotEmpty) ...[
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 16,
                      color: isDark ? Colors.white38 : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${ticket.replies!.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Tickets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Priority',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('High', false),
                _buildFilterChip('Medium', false),
                _buildFilterChip('Low', false),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Date Range',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildDateRangeOption('Today'),
            _buildDateRangeOption('This Week'),
            _buildDateRangeOption('This Month'),
            _buildDateRangeOption('Custom Range'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6FA5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Apply'),
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
      label: Text(label),
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
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
      title: Text(label),
      value: label,
      groupValue: 'Today',
      onChanged: (value) {},
      activeColor: const Color(0xFF4A6FA5),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      tileColor: isDark ? Colors.white10 : Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
