import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../providers/jobcard_detail_providers.dart';
import '../../../../core/widgets/app_bar.dart';

class JobcardDetailPage extends ConsumerStatefulWidget {
  const JobcardDetailPage({super.key});

  @override
  ConsumerState<JobcardDetailPage> createState() => _JobcardDetailPageState();
}

class _JobcardDetailPageState extends ConsumerState<JobcardDetailPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? _id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is int) {
      _id = arg;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(jobcardDetailNotifierProvider.notifier).load(_id!);
      });
    }
    _tabController ??= TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobcardDetailNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: state.item != null
              ? 'Jobcard #${_getJobcardNumber(state.item)}'
              : 'Jobcard Detail',
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.share_rounded, color: isDark ? Colors.white70 : Colors.grey.shade600),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share jobcard — not implemented')),
                );
              },
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, color: isDark ? Colors.white70 : Colors.grey.shade600),
              onSelected: (v) {
                switch (v) {
                  case 'print':
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Print jobcard — not implemented')),
                    );
                    break;
                  case 'more':
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('More options')),
                    );
                }
              },
              itemBuilder: (ctx) => const [
                PopupMenuItem(value: 'print', child: Text('Print')),
                PopupMenuItem(value: 'more', child: Text('More...')),
              ],
            ),
          ],
        ),
        body: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.item == null
                ? _buildErrorState(context, state.error, isDark)
                : _buildDetailContent(context, state.item, isDark),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? error, bool isDark) {
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
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load jobcard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error ?? 'No data',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Retry',
              icon: Icons.refresh_rounded,
              onPressed: () {
                if (_id != null) {
                  ref.read(jobcardDetailNotifierProvider.notifier).load(_id!);
                }
              },
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, dynamic jobcard, bool isDark) {
    final primaryColor = AppColors.primary;

    return Column(
      children: [
        // Enhanced Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Approval Logs'),
              Tab(text: 'Repairs & Replacement'),
              Tab(text: 'Logs'),
              Tab(text: 'Inspection'),
              Tab(text: 'Picking Slip'),
            ],
            labelColor: primaryColor,
            unselectedLabelColor: isDark ? Colors.white54 : Colors.grey.shade600,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: primaryColor.withOpacity(0.15),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        const SizedBox(height: 12),

        // Tab Bar Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildOverviewTab(context, jobcard, isDark),
              _buildApprovalLogsTab(context, jobcard, isDark),
              _buildRepairsTab(context, jobcard, isDark),
              _buildLogsTab(context, jobcard, isDark),
              _buildInspectionTab(context, jobcard, isDark),
              _buildPickingSlipTab(context, jobcard, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(BuildContext context, dynamic jobcard, bool isDark) {
    final primaryColor = AppColors.primary;
    final statusName = jobcard.statusRow?['name']?.toString() ?? jobcard.status?.toString() ?? 'Unknown';
    final statusColor = _getStatusColor(statusName);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(0.15),
                        primaryColor.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.assignment_rounded,
                    color: primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobcard.service ?? 'No service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: isDark ? Colors.white : const Color(0xFF1A2634),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jobcard.receiverName ?? jobcard.receiver ?? '—',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    statusName,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Information Card
          _buildInfoCard(
            context,
            title: 'Jobcard Information',
            icon: Icons.info_rounded,
            children: [
              _infoRow('Related to', jobcard.relatedTo?.toString() ?? (jobcard is Map ? jobcard['related_to']?.toString() : null) ?? '-'),
              _infoRow('Receiver', jobcard.receiverName?.toString() ?? jobcard.receiver?.toString() ?? (jobcard is Map ? jobcard['receiver_name']?.toString() : null) ?? '-'),
              _infoRow('Assigned Staff', jobcard.technicianId?.toString() ?? (jobcard is Map ? jobcard['technician_id']?.toString() : null) ?? '-'),
              _infoRow('Started On', jobcard.reportedDate?.toString() ?? '-'),
              _infoRow('Completed On', jobcard.dispatchedDate?.toString() ?? '-'),
            ],
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.summarize_rounded, size: 18, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Summary of Tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        'Items',
                        '${(jobcard.items ?? []).length}',
                        Icons.inventory_2_rounded,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryItem(
                        'Grand Total',
                        jobcard.grandTotal ?? '-',
                        Icons.attach_money_rounded,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (jobcard.notes != null && jobcard.notes.toString().isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Recommendation',
              icon: Icons.note_rounded,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    jobcard.notes.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A2634),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepairsTab(BuildContext context, dynamic jobcard, bool isDark) {
    final items = jobcard.items ?? <dynamic>[];

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build_outlined,
              size: 64,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No repairs or replacements recorded',
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Header Row
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Item',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark ? Colors.white : const Color(0xFF1A2634),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Qty',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark ? Colors.white : const Color(0xFF1A2634),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark ? Colors.white : const Color(0xFF1A2634),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Items List
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                          width: index < items.length - 1 ? 1 : 0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item['item_name']?.toString() ?? '-',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white70 : Colors.grey.shade800,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${item['qty'] ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF1A2634),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item['item_description']?.toString() ?? item['item_description2']?.toString() ?? '-',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsTab(BuildContext context, dynamic jobcard, bool isDark) {
    final logs = jobcard.logs ?? <dynamic>[];

    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 64,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No history',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No status history available',
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final sr = log['status_row'];
        final statusName = sr?['name']?.toString() ?? log['status']?.toString() ?? '';
        final statusColor = _getStatusColor(statusName);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    sr?['id']?.toString() ?? '?',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      log['created_at']?.toString() ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildApprovalLogsTab(BuildContext context, dynamic jobcard, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.approval_rounded,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No approval records',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Approval logs will appear here',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionTab(BuildContext context, dynamic jobcard, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No inspection records',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inspection details will appear here',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickingSlipTab(BuildContext context, dynamic jobcard, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No picking slip',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Picking slip information will appear here',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _getJobcardNumber(dynamic jobcard) {
    if (jobcard == null) return 'N/A';
    if (jobcard is Map) {
      return jobcard['jobcard_number']?.toString() ??
             jobcard['jobcard_no']?.toString() ??
             jobcard['jobcard']?.toString() ??
             jobcard['id']?.toString() ??
             'N/A';
    }

    // model-like object
    return jobcard.jobcardNumber?.toString() ??
           jobcard.id?.toString() ??
           'N/A';
  }

  Color _getStatusColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('completed') || lower.contains('done') || lower.contains('closed')) {
      return Colors.green;
    } else if (lower.contains('pending') || lower.contains('waiting')) {
      return Colors.orange;
    } else if (lower.contains('in progress') || lower.contains('processing')) {
      return Colors.blue;
    } else if (lower.contains('cancelled') || lower.contains('rejected')) {
      return Colors.red;
    }
    return AppColors.primary;
  }
}
