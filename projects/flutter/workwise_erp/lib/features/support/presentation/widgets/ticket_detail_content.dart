import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/support_reply.dart';
import '../../domain/entities/status.dart';
import '../../domain/entities/priority.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/support_providers.dart';
import 'dropdown_helpers.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/widgets/app_modal.dart';
import '../../../../../core/widgets/app_dialog.dart';
import '../../../../../core/widgets/app_tab_bar.dart';
import '../../../../../core/themes/app_colors.dart';

class TicketDetailContent extends ConsumerStatefulWidget {
  final SupportTicket ticket;
  const TicketDetailContent({super.key, required this.ticket});

  @override
  ConsumerState<TicketDetailContent> createState() =>
      _TicketDetailContentState();
}

class _TicketDetailContentState extends ConsumerState<TicketDetailContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<SupportReply> replies;
  late List<dynamic> history;
  late List<Map<String, dynamic>> localAttachments;
  String? selectedStatus;
  String? selectedPriority;
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSendingComment = false;
  bool _isChangingStatus = false;
  bool _isChangingPriority = false;

  // runtime-backed lists (fetched from server). Fall back to static options when unavailable.
  List<SupportStatus> availableStatuses = [];
  List<Priority> availablePriorities = [];

  List<String> get statusOptions => availableStatuses.isNotEmpty
      ? availableStatuses.map((s) => s.status ?? 'Unknown').toList()
      : ['Open', 'In Progress', 'Resolved', 'Closed'];

  List<String> get priorityOptions => availablePriorities.isNotEmpty
      ? availablePriorities.map((p) => p.priority ?? 'Normal').toList()
      : ['High', 'Medium', 'Low', 'Normal'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    replies = List.of(widget.ticket.replies ?? []);
    localAttachments = List.of(widget.ticket.attachments ?? []);
    history = _generateHistory();
    selectedStatus = widget.ticket.status?.status ?? 'Open';
    selectedPriority = widget.ticket.priority?.priority ?? 'Normal';

    // Load server-backed status/priority lists
    _loadSupportMeta();
  }

  Future<void> _loadSupportMeta() async {
    try {
      final getStatuses = ref.read(getSupportStatusesUseCaseProvider);
      final getPriorities = ref.read(getSupportPrioritiesUseCaseProvider);

      final sRes = await getStatuses.call();
      sRes.fold((_) => null, (list) {
        setState(() => availableStatuses = list);
      });

      final pRes = await getPriorities.call();
      pRes.fold((_) => null, (list) {
        setState(() => availablePriorities = list);
      });
    } catch (_) {
      // ignore silently — fall back to defaults already provided in getters
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TicketDetailContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent provides a new ticket instance, refresh local state (replies/history/selected values)
    if (oldWidget.ticket.id != widget.ticket.id) {
      setState(() {
        replies = List.of(widget.ticket.replies ?? []);
        localAttachments = List.of(widget.ticket.attachments ?? []);
        history = _generateHistory();
        selectedStatus = widget.ticket.status?.status ?? 'Open';
        selectedPriority = widget.ticket.priority?.priority ?? 'Normal';
      });
    }
  }

  List<dynamic> _generateHistory() {
    final history = <dynamic>[];

    // Add ticket creation (always store user as String to avoid type errors in UI)
    if (widget.ticket.createdAt != null) {
      history.add({
        'action': 'Ticket created',
        'user': widget.ticket.createdBy != null
            ? 'User ${widget.ticket.createdBy}'
            : 'System',
        'timestamp': widget.ticket.createdAt,
        'type': 'create',
      });
    }

    // Add replies as comment history entries (normalize user to string)
    if (widget.ticket.replies != null) {
      for (var reply in widget.ticket.replies!) {
        history.add({
          'action': 'Added a comment',
          'user': reply.createdBy != null ? 'User ${reply.createdBy}' : 'User',
          'timestamp': reply.createdAt,
          'type': 'comment',
        });
      }
    }

    // Sort by timestamp (newest first)
    history.sort((a, b) {
      final aTime = a['timestamp'] is DateTime
          ? a['timestamp']
          : DateTime.parse(a['timestamp'].toString());
      final bTime = b['timestamp'] is DateTime
          ? b['timestamp']
          : DateTime.parse(b['timestamp'].toString());
      return bTime.compareTo(aTime);
    });

    return history;
  }

  String _timeAgo(dynamic dateTime) {
    try {
      final when = dateTime is DateTime
          ? dateTime
          : DateTime.parse(dateTime.toString());
      final now = DateTime.now();
      final difference = now.difference(when);

      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()}y ago';
      }
      if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()}mo ago';
      }
      if (difference.inDays > 0) return '${difference.inDays}d ago';
      if (difference.inHours > 0) return '${difference.inHours}h ago';
      if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
      return 'just now';
    } catch (e) {
      return 'unknown';
    }
  }

  String _formatDate(dynamic dateTime) {
    try {
      final date = dateTime is DateTime
          ? dateTime
          : DateTime.parse(dateTime.toString()).toLocal();
      final monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final month = monthNames[date.month - 1];
      final day = date.day;
      final year = date.year;
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final ampm = date.hour >= 12 ? 'PM' : 'AM';
      return '$month $day, $year • $hour:$minute $ampm';
    } catch (e) {
      return 'unknown date';
    }
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.purple;
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    final previous = selectedStatus;
    setState(() => selectedStatus = newStatus);

    // find status id from server-provided list
    final statusObj = availableStatuses.firstWhere(
      (s) => (s.status ?? '').toLowerCase() == newStatus.toLowerCase(),
      orElse: () => SupportStatus(id: null, status: newStatus, color: null),
    );

    if (statusObj.id == null || widget.ticket.id == null) {
      // No id — show info and revert to old selected value locally if id is vital
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text('Cannot update status on server (missing ID)')),
      );
      setState(() => selectedStatus = previous);
      return;
    }

    final change = ref.read(changeTicketStatusUseCaseProvider);
    setState(() => _isChangingStatus = true);

    // show global loading dialog while updating ticket status
    showAppLoadingDialog(context, message: 'Updating Ticket...');

    final res = await change.call(
      ticketId: widget.ticket.id!,
      statusId: statusObj.id!,
    );

    // hide loading dialog when operation completes
    hideAppLoadingDialog(context);

    res.fold(
      (failure) {
        // revert on failure
        setState(() {
          selectedStatus = previous;
          _isChangingStatus = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Failed to update status: ${failure.message}'),
          ),
        );
      },
      (_) {
        setState(() {
          history.insert(0, {
            'action': 'Status changed to $newStatus',
            'user': 'You',
            'timestamp': DateTime.now(),
            'type': 'status',
          });
          _isChangingStatus = false;
        });

        // refresh ticket list so callers see the change immediately
        try {
          ref.read(supportNotifierProvider.notifier).loadTickets();
        } catch (_) {}

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text('Status updated to $newStatus')));
      },
    );
  }

  Future<void> _updatePriority(String newPriority) async {
    final previous = selectedPriority;
    setState(() => selectedPriority = newPriority);

    // find priority id
    final pObj = availablePriorities.firstWhere(
      (p) => (p.priority ?? '').toLowerCase() == newPriority.toLowerCase(),
      orElse: () => Priority(id: null, priority: newPriority, color: null),
    );

    if (pObj.id == null || widget.ticket.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text('Cannot update priority on server (missing ID)')),
      );
      setState(() => selectedPriority = previous);
      return;
    }

    final change = ref.read(changeTicketPriorityUseCaseProvider);
    setState(() => _isChangingPriority = true);
    final res = await change.call(
      ticketId: widget.ticket.id!,
      priorityId: pObj.id!,
    );

    res.fold(
      (failure) {
        setState(() {
          selectedPriority = previous;
          _isChangingPriority = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Failed to update priority: ${failure.message}'),
          ),
        );
      },
      (_) {
        setState(() {
          history.insert(0, {
            'action': 'Priority changed to $newPriority',
            'user': 'You',
            'timestamp': DateTime.now(),
            'type': 'status',
          });
          _isChangingPriority = false;
        });

        // refresh ticket list so callers see the change immediately
        try {
          ref.read(supportNotifierProvider.notifier).loadTickets();
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(behavior: SnackBarBehavior.floating, content: Text('Priority updated to $newPriority')),
        );
      },
    );
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSendingComment = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final authState = ref.read(authNotifierProvider);
    final currentUser = authState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );

    final newReply = SupportReply(
      id: DateTime.now().millisecondsSinceEpoch,
      message: text,
      createdBy: currentUser?.id ?? 0,
      createdAt: DateTime.now(),
    );

    setState(() {
      replies.insert(0, newReply);
      history.insert(0, {
        'action': 'Added a comment',
        'user': currentUser?.name ?? 'You',
        'timestamp': DateTime.now(),
        'type': 'comment',
      });
      _commentController.clear();
      _isSendingComment = false;
    });

    // Scroll to top to show new comment
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final authState = ref.watch(authNotifierProvider);
    final currentUser = authState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );

    return Column(
      children: [
        // Tab Bar
        AppTabBar(
          controller: _tabController,
          tabs: const ['Overview', 'Document', 'Comment', 'History'],
          isScrollable: false,
        ),
        SizedBox(height: 12.h),

        // Tab Bar Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              // Overview Tab
              _buildOverviewTab(context, isDark, primaryColor),

              // Document Tab
              _buildDocumentTab(context, isDark, primaryColor),

              // Comment Tab
              _buildCommentTab(context, isDark, primaryColor, currentUser),

              // History Tab
              _buildHistoryTab(context, isDark, primaryColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    final statusColor = _getStatusColor(selectedStatus);
    final priorityColor = _getPriorityColor(selectedPriority);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          // Subject
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16.r),
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
                    Icon(
                      Icons.subject_rounded,
                      size: 16.r,
                      color: primaryColor,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Subject',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    if ((widget.ticket.ticketCode ?? '').isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          widget.ticket.ticketCode ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.ticket.subject ?? 'No subject',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Status and Priority Row
          Row(
            children: [
              Expanded(
                child: _buildDropdownCard(
                  context,
                  label: 'Status',
                  value: selectedStatus!,
                  options: statusOptions,
                  icon: Icons.flag_rounded,
                  color: statusColor,
                  onChanged: _isChangingStatus ? null : _updateStatus,
                  isDark: isDark,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildDropdownCard(
                  context,
                  label: 'Priority',
                  value: selectedPriority!,
                  options: priorityOptions,
                  icon: Icons.priority_high_rounded,
                  color: priorityColor,
                  onChanged: _isChangingPriority ? null : _updatePriority,
                  isDark: isDark,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Customer Information Card
          _buildInfoCard(
            context,
            title: 'Customer Information',
            icon: Icons.person_rounded,
            children: [
              _infoRow('Name', widget.ticket.customer?.name ?? '-'),
              _infoRow('Email', widget.ticket.customer?.email ?? '-'),
              _infoRow('Phone', widget.ticket.customer?.phone ?? '-'),
              _infoRow(
                'Contact',
                widget.ticket.customer?.email ??
                    widget.ticket.customer?.phone ??
                    '-',
              ),
              // Assigned user (API: assign_user) — show only name and type when available
              if (widget.ticket.assignUser != null) ...[
                const SizedBox(height: 6),
                _infoRow('Assigned', widget.ticket.assignUser!.name ?? '-'),
                _infoRow(
                  'Assignee type',
                  widget.ticket.assignUser!.type ?? '-',
                ),
              ],
            ],
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // Details Card
          _buildInfoCard(
            context,
            title: 'Details',
            icon: Icons.info_rounded,
            children: [
              _infoRow('Category', widget.ticket.category ?? '-'),
              _infoRow('Services', widget.ticket.services?.join(', ') ?? '-'),
              _infoRow('Location', widget.ticket.location ?? '-'),
              _infoRow('Department', widget.ticket.department ?? '-'),
              _infoRow(
                'Supervisors',
                widget.ticket.supervisors?.join(', ') ?? '-',
              ),
            ],
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // Description Card
          _buildInfoCard(
            context,
            title: 'Description',
            icon: Icons.description_rounded,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  widget.ticket.description?.isNotEmpty == true
                      ? widget.ticket.description!
                      : 'No description provided',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: widget.ticket.description?.isNotEmpty == true
                        ? (isDark ? Colors.white70 : Colors.grey.shade800)
                        : (isDark ? Colors.white38 : Colors.grey.shade500),
                  ),
                ),
              ),
            ],
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // Attachments Section
          if (localAttachments.isNotEmpty)
            _buildAttachmentsSection(context, isDark),
        ],
      ),
    );
  }

  Widget _buildDropdownCard(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> options,
    required IconData icon,
    required Color color,
    required Function(String)? onChanged,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14.r, color: color),
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              // Deduplicate options and ensure the current value exists exactly once.
              initialValue: (() {
                final unique = uniqueOptions(options);
                final localValue = unique.contains(value)
                    ? value
                    : (unique.isNotEmpty ? unique.first : null);
                return localValue;
              })(),
              items: uniqueOptions(options)
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: label == 'Status'
                                  ? _getStatusColor(s)
                                  : _getPriorityColor(s),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(s, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged != null
                  ? (v) => v != null ? onChanged(v) : null
                  : null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              icon: (label == 'Status' && _isChangingStatus) ||
                      (label == 'Priority' && _isChangingPriority)
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    )
                  : Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                      size: 20.r,
                    ),
              dropdownColor: isDark ? const Color(0xFF151A2E) : Colors.white,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1A2634),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
              Icon(icon, size: 18.r, color: AppColors.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
              Icon(
                Icons.attach_file_rounded,
                size: 18.r,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Attachments (${localAttachments.length})',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...localAttachments.map(
            (attachment) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.insert_drive_file_rounded,
                        size: 16.r,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attachment['name'] ?? 'File',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2634),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            attachment['size'] ?? 'Unknown size',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.download_rounded,
                        size: 20.r,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTab(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Enhanced Upload Area with better visual feedback
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withOpacity(0.08),
                  primaryColor.withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _onUploadDocuments,
                borderRadius: BorderRadius.circular(28),
                splashColor: primaryColor.withOpacity(0.1),
                highlightColor: primaryColor.withOpacity(0.05),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  // make inner content scroll when it doesn't fit while keeping it centered
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Animated upload icon
                              TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 1500),
                                tween: Tween<double>(begin: 0.8, end: 1.0),
                                curve: Curves.easeInOut,
                                builder: (context, double scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          colors: [
                                            primaryColor.withOpacity(0.2),
                                            primaryColor.withOpacity(0.05),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryColor.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.cloud_upload_rounded,
                                        size: 56,
                                        color: primaryColor,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 16),

                              // Title with gradient effect
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    primaryColor,
                                    primaryColor.withBlue(
                                      primaryColor.blue + 50,
                                    ),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Text(
                                  'Upload Documents',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Subtitle with better styling (allow wrapping)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 14,
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'Supported: PDF, DOC, XLS, JPG, PNG (Max 10MB)',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Select Files Button with hover effect
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        primaryColor,
                                        primaryColor.withBlue(
                                          primaryColor.blue + 40,
                                        ),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _onUploadDocuments,
                                      borderRadius: BorderRadius.circular(30),
                                      splashColor: Colors.white.withOpacity(
                                        0.2,
                                      ),
                                      highlightColor: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.add_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Browse Files',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Selected / Uploaded Documents (localAttachments)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.attach_file_rounded,
                        size: 18,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Selected Documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${localAttachments.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (localAttachments.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.upload_rounded, size: 16),
                    label: const Text('Upload All'),
                    style: TextButton.styleFrom(foregroundColor: primaryColor),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Show selected files (no hardcoded demo items)
          if (localAttachments.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(
                    Icons.folder_open_rounded,
                    size: 56,
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No files selected',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap "Browse Files" to add attachments',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: localAttachments.map((att) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.03)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                att['name'] ?? 'File',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1A2634),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                att['size'] ?? 'Unknown size',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red.shade400,
                          ),
                          onPressed: () {
                            setState(() => localAttachments.remove(att));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 12),

          // Storage / selection summary (keeps existing visual card but shows selected count)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(0.05), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.storage_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected files',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${localAttachments.length} file(s) selected',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTile(
    BuildContext context,
    int index,
    bool isDark,
    Color primaryColor,
  ) {
    final fileNames = [
      'Annual_Report_2024.pdf',
      'Contract_Agreement.docx',
      'Product_Catalog.xlsx',
      'Meeting_Minutes.pdf',
    ];

    final fileSizes = ['2.4 MB', '1.8 MB', '856 KB', '3.2 MB'];
    final fileDates = [
      'Today, 10:30 AM',
      'Yesterday',
      'Mar 15, 2024',
      'Mar 12, 2024',
    ];
    final fileTypes = ['pdf', 'docx', 'xlsx', 'pdf'];

    final Color fileColor = _getFileColor(fileTypes[index % fileTypes.length]);
    final IconData fileIcon = _getFileIcon(fileTypes[index % fileTypes.length]);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Preview document
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: fileColor.withOpacity(0.1),
          highlightColor: fileColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // File Icon with animated background
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        fileColor.withOpacity(0.15),
                        fileColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: fileColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(fileIcon, color: fileColor, size: 24),
                ),

                const SizedBox(width: 12),

                // File Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileNames[index % fileNames.length],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A2634),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // File size
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              fileSizes[index % fileSizes.length],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Date
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                fileDates[index % fileDates.length],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                Row(
                  children: [
                    // Download button
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.download_rounded,
                          size: 18,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                        onPressed: () {
                          // Download file
                          _showDownloadConfirmation(
                            context,
                            fileNames[index % fileNames.length],
                          );
                        },
                        splashRadius: 28,
                      ),
                    ),

                    // More options button
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          size: 18,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: isDark ? const Color(0xFF151A2E) : Colors.white,
                        onSelected: (value) {
                          if (value == 'delete') {
                            _showDeleteFileConfirmation(context);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'preview',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.visibility_rounded,
                                  size: 18,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 8),
                                const Text('Preview'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'share',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share_rounded,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                const Text('Share'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'rename',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                const Text('Rename'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_rounded,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                const Text('Delete'),
                              ],
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
      ),
    );
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'docx':
      case 'doc':
        return Colors.blue;
      case 'xlsx':
      case 'xls':
        return Colors.green;
      case 'jpg':
      case 'png':
      case 'jpeg':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'docx':
      case 'doc':
        return Icons.description_rounded;
      case 'xlsx':
      case 'xls':
        return Icons.table_chart_rounded;
      case 'jpg':
      case 'png':
      case 'jpeg':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  void _showDownloadConfirmation(BuildContext context, String fileName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download_done_rounded,
                color: Colors.green,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Download Started',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                  Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showDeleteFileConfirmation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete File',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this file? This action cannot be undone.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('File deleted successfully'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Color _getFileColor(int index) {
  //   final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
  //   return colors[index % colors.length];
  // }

  // IconData _getFileIcon(int index) {
  //   final icons = [
  //     Icons.picture_as_pdf_rounded,
  //     Icons.insert_drive_file_rounded,
  //     Icons.image_rounded,
  //     Icons.description_rounded,
  //   ];
  //   return icons[index % icons.length];
  // }

  String _getFileName(int index) {
    final names = [
      'invoice_2024.pdf',
      'contract_agreement.docx',
      'product_image.jpg',
      'specifications.pdf',
    ];
    return names[index % names.length];
  }

  String _getFileDetails(int index) {
    final sizes = ['2.4 MB', '1.8 MB', '3.2 MB', '856 KB'];
    final dates = ['Today', 'Yesterday', 'Mar 15, 2024', 'Mar 12, 2024'];
    return '${sizes[index % sizes.length]} • ${dates[index % dates.length]}';
  }

  Widget _buildCommentTab(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    dynamic currentUser,
  ) {
    return Column(
      children: [
        // Comments List
        Expanded(
          child: replies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 64.r,
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No comments yet',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Be the first to add a comment',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16.r),
                  itemCount: replies.length,
                  reverse: true,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, i) {
                    final r = replies[i];
                    final isCurrentUser = r.createdBy == currentUser?.id;
                    final author = isCurrentUser
                        ? 'You'
                        : 'User ${r.createdBy ?? '-'}';
                    final time = _timeAgo(r.createdAt);
                    final avatarText = author.isNotEmpty
                        ? author[0].toUpperCase()
                        : '?';

                    return Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? primaryColor.withOpacity(0.1)
                            : (isDark
                                  ? Colors.white.withOpacity(0.03)
                                  : Colors.white),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isCurrentUser
                              ? primaryColor.withOpacity(0.3)
                              : (isDark
                                    ? Colors.white10
                                    : Colors.grey.shade200),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isCurrentUser
                                    ? [
                                        primaryColor,
                                        primaryColor.withBlue(
                                          primaryColor.blue + 50,
                                        ),
                                      ]
                                    : [
                                        Colors.grey.shade400,
                                        Colors.grey.shade600,
                                      ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                avatarText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        author,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                          color: isCurrentUser
                                              ? primaryColor
                                              : (isDark
                                                    ? Colors.white
                                                    : const Color(0xFF1A2634)),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    if (isCurrentUser)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        child: Text(
                                          'You',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    const Spacer(),
                                    Text(
                                      time,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: isDark
                                            ? Colors.white38
                                            : Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  r.message ?? '-',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 1.4,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        // Comment Input
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Attachment Button
              Container(
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                    size: 20.r,
                  ),
                  onPressed: () {},
                ),
              ),

              // Text Field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                        fontSize: 14.sp,
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
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendComment(),
                  ),
                ),
              ),

              // Send Button
              SizedBox(width: 8.w),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      primaryColor.withBlue(primaryColor.blue + 50),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: _isSendingComment
                      ? SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20.r,
                        ),
                  onPressed: _isSendingComment ? null : _sendComment,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 64.r,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'No history available',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: history.length,
      itemBuilder: (context, i) {
        final entry = history[i];
        final type = entry['type'] ?? 'default';

        IconData icon;
        Color iconColor;

        switch (type) {
          case 'create':
            icon = Icons.add_circle_rounded;
            iconColor = Colors.green;
            break;
          case 'status':
            icon = Icons.compare_arrows_rounded;
            iconColor = Colors.orange;
            break;
          case 'comment':
            icon = Icons.chat_rounded;
            iconColor = Colors.blue;
            break;
          default:
            icon = Icons.history_rounded;
            iconColor = Colors.grey;
        }

        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot
              Column(
                children: [
                  Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 16.r, color: iconColor),
                  ),
                  if (i < history.length - 1)
                    Container(
                      width: 2.w,
                      height: 40.h,
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                    ),
                ],
              ),
              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.03)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry['action'] ?? 'Unknown action',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A2634),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 12.r,
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade500,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              entry['user'] ?? 'System',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.access_time_rounded,
                            size: 12.r,
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade500,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              _formatDate(entry['timestamp']),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMoreOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                icon: Icons.edit_rounded,
                label: 'Edit Ticket',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildOptionTile(
                icon: Icons.person_add_rounded,
                label: 'Assign To',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildOptionTile(
                icon: Icons.print_rounded,
                label: 'Print Ticket',
                color: Colors.purple,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildOptionTile(
                icon: Icons.share_rounded,
                label: 'Share',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildOptionTile(
                icon: Icons.delete_rounded,
                label: 'Delete Ticket',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- New / placeholder actions ------------------------------------------------
  void _onCreatePfi() {
    // TODO: integrate with PFI create flow / route
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Create PFI — not implemented')),
    );
  }

  void _onCreateJobCard() {
    // TODO: navigate to jobcard create screen or open modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Create JobCard — not implemented')),
    );
  }

  void _onUploadDocuments() async {
    // Open native file picker and add selected files to the local attachments list.
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) return; // user cancelled

      setState(() {
        for (final f in result.files) {
          localAttachments.add({
            'name': f.name,
            'size': _humanFileSize(f.size),
            'path': f.path,
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text('${result.count} file(s) selected')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Failed to pick files')));
    }
  }

  String _humanFileSize(int? bytes) {
    if (bytes == null) return 'Unknown size';
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  // ------------------------------------------------------------------------------

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF1A2634),
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    context.showConfirmationModal(
      title: 'Delete Ticket',
      message:
          'Are you sure you want to delete this ticket? This action cannot be undone.',
      confirmText: 'Delete',
      onConfirm: () async {
        final ticketId = widget.ticket.id;
        if (ticketId == null) return;

        final deleteUc = ref.read(deleteSupportTicketUseCaseProvider);

        try {
          final res = await deleteUc.call(ticketId: ticketId);
          res.fold(
            (failure) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Failed to delete ticket: ${failure.message}'),
                ),
              );
            },
            (_) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Ticket deleted'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );

              // close confirmation modal
              if (Navigator.canPop(context)) Navigator.pop(context);

              // close the detail route (if present) and refresh ticket list
              Future.microtask(() {
                if (Navigator.canPop(context)) Navigator.pop(context);
                try {
                  ref.read(supportNotifierProvider.notifier).loadTickets();
                } catch (_) {}
              });
            },
          );
        } catch (e) {
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Failed to delete ticket')),
            );
        }
      },
      icon: Icons.delete_rounded,
      confirmColor: Colors.red,
    );
  }
}
