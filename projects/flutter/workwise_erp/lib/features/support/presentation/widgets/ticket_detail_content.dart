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
import '../../../../../core/widgets/app_dialog.dart';
import '../../../../../core/widgets/app_tab_bar.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_icons.dart';
import 'package:flutter/cupertino.dart';

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
    final authState = ref.read(authNotifierProvider);
    final currentUserId = authState.maybeWhen(
      authenticated: (u) => u.id,
      orElse: () => null,
    );
    history = _generateHistory(currentUserId);
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
        final authState = ref.read(authNotifierProvider);
        final currentUserId = authState.maybeWhen(
          authenticated: (u) => u.id,
          orElse: () => null,
        );
        history = _generateHistory(currentUserId);
        selectedStatus = widget.ticket.status?.status ?? 'Open';
        selectedPriority = widget.ticket.priority?.priority ?? 'Normal';
      });
    }
  }

  List<dynamic> _generateHistory([int? currentUserId]) {
    final history = <dynamic>[];

    // Add ticket creation (always store user as String to avoid type errors in UI)
    if (widget.ticket.createdAt != null) {
      history.add({
        'action': 'Ticket created',
        'user': widget.ticket.createdBy != null
            ? (widget.ticket.createdBy == currentUserId
                  ? 'You'
                  : 'Support Staff')
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
          'user': reply.createdBy != null
              ? (reply.createdBy == currentUserId ? 'You' : 'Support Staff')
              : 'Support Staff',
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
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Cannot update status on server (missing ID)'),
        ),
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Status updated to $newStatus'),
          ),
        );
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
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Cannot update priority on server (missing ID)'),
        ),
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
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Priority updated to $newPriority'),
          ),
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
      user: currentUser?.id ?? 0,
      createdBy: currentUser?.id ?? 0,
      isRead: 0,
      name: currentUser?.name,
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

  /// Shows a dialog picker and calls [onChanged] with the selected option.
  Future<void> _showPickerDialog({
    required String label,
    required String value,
    required List<String> options,
    required Color Function(String) colorOf,
    required Function(String) onChanged,
  }) async {
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: isDark ? const Color(0xFF1A2234) : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
                child: Text(
                  'Select $label',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
              ),
              const Divider(height: 1),
              ...options.map((opt) {
                final isSelected = opt.toLowerCase() == value.toLowerCase();
                final optColor = colorOf(opt);
                return ListTile(
                  leading: Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: BoxDecoration(
                      color: optColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isSelected
                          ? optColor
                          : (isDark ? Colors.white70 : Colors.grey.shade800),
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: optColor, size: 18.r)
                      : null,
                  onTap: () => Navigator.of(ctx).pop(opt),
                );
              }),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
    if (picked != null && picked != value) onChanged(picked);
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
    final isLoading =
        (label == 'Status' && _isChangingStatus) ||
        (label == 'Priority' && _isChangingPriority);
    final Color Function(String) colorOf = label == 'Status'
        ? _getStatusColor
        : _getPriorityColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label outside the box
        Row(
          children: [
            Icon(icon, size: 13.r, color: color),
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
        SizedBox(height: 6.h),
        // Tappable field
        GestureDetector(
          onTap: onChanged == null || isLoading
              ? null
              : () => _showPickerDialog(
                  label: label,
                  value: value,
                  options: uniqueOptions(options),
                  colorOf: colorOf,
                  onChanged: onChanged,
                ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: color.withOpacity(0.35), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 9.r,
                  height: 9.r,
                  decoration: BoxDecoration(
                    color: colorOf(value),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                isLoading
                    ? SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      )
                    : Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18.r,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                      ),
              ],
            ),
          ),
        ),
      ],
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
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),

          // ── Upload Zone ───────────────────────────────────────────────
          InkWell(
            onTap: _onUploadDocuments,
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: isDark
                    ? primaryColor.withOpacity(0.06)
                    : primaryColor.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: primaryColor.withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(18.r),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload_rounded,
                      size: 40.r,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Upload Documents',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'PDF, DOC, XLS, JPG, PNG  ·  Max 10 MB',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 16.r,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Browse Files',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // ── Attachments Header ────────────────────────────────────────
          Row(
            children: [
              Icon(Icons.attach_file_rounded, size: 18.r, color: primaryColor),
              SizedBox(width: 8.w),
              Text(
                'Attachments',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
              SizedBox(width: 8.w),
              if (localAttachments.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${localAttachments.length}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              const Spacer(),
              if (localAttachments.isNotEmpty)
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.upload_rounded, size: 14.r),
                  label: Text('Upload All', style: TextStyle(fontSize: 12.sp)),
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                ),
            ],
          ),

          SizedBox(height: 12.h),

          // ── File List ─────────────────────────────────────────────────
          if (localAttachments.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 28.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 52.r,
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No files selected',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...localAttachments.map((att) {
              final name = att['name'] as String? ?? 'File';
              final ext = name.contains('.')
                  ? name.split('.').last.toLowerCase()
                  : '';
              final fileColor = _getFileColor(ext);
              final fileIcon = _getFileIcon(ext);
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.04)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          color: fileColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(fileIcon, size: 22.r, color: fileColor),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A2634),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              att['size'] ?? '',
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
                          Icons.delete_outline_rounded,
                          size: 20.r,
                          color: Colors.red.shade400,
                        ),
                        onPressed: () =>
                            setState(() => localAttachments.remove(att)),
                      ),
                    ],
                  ),
                ),
              );
            }),
          SizedBox(height: 8.h),
        ],
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

  Widget _buildCommentTab(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    dynamic currentUser,
  ) {
    return Column(
      children: [
        // ── Comment List ──────────────────────────────────────────────────────
        Expanded(
          child: replies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        AppIcons.chatBUbble,
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
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  itemCount: replies.length,
                  reverse: true,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, i) {
                    final r = replies[i];
                    final isUnread = (r.isRead ?? 1) == 0;
                    final isCurrentUser =
                        (r.user ?? r.createdBy) == currentUser?.id;

                    // Display name: prefer name field, fallback to User #id
                    final displayName = (r.name != null && r.name!.isNotEmpty)
                        ? r.name!
                        : (isCurrentUser
                              ? 'You'
                              : 'User #${r.user ?? r.createdBy ?? '-'}');

                    final initial = displayName.isNotEmpty
                        ? displayName[0].toUpperCase()
                        : '?';
                    final time = _timeAgo(r.createdAt);

                    return _CommentCard(
                      displayName: displayName,
                      initial: initial,
                      time: time,
                      message: r.message ?? '',
                      isUnread: isUnread,
                      isCurrentUser: isCurrentUser,
                      isDark: isDark,
                      primaryColor: primaryColor,
                      userId: r.user ?? r.createdBy,
                    );
                  },
                ),
        ),

        // ── Comment Input ─────────────────────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.primary : Colors.white,
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
              // Text Field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.07)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment…',
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
                  color: primaryColor,
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
                          child: const CupertinoActivityIndicator(
                            radius: 10,
                            color: Colors.white,
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
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('${result.count} file(s) selected'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Failed to pick files'),
        ),
      );
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Facebook-style comment card (stateless, easy to reuse)
// ─────────────────────────────────────────────────────────────────────────────
class _CommentCard extends StatelessWidget {
  const _CommentCard({
    required this.displayName,
    required this.initial,
    required this.time,
    required this.message,
    required this.isUnread,
    required this.isCurrentUser,
    required this.isDark,
    required this.primaryColor,
    this.userId,
  });

  final String displayName;
  final String initial;
  final String time;
  final String message;
  final bool isUnread;
  final bool isCurrentUser;
  final bool isDark;
  final Color primaryColor;
  final int? userId;

  @override
  Widget build(BuildContext context) {
    // Avatar background: current-user gets primary tint, others get grey
    final avatarBg = isCurrentUser
        ? primaryColor
        : (isDark ? Colors.white24 : Colors.grey.shade400);

    // Card bg: slightly tinted for current user
    final cardBg = isCurrentUser
        ? primaryColor.withOpacity(isDark ? 0.12 : 0.07)
        : (isDark ? const Color(0xFF1E2640) : Colors.white);

    final borderColor = isCurrentUser
        ? primaryColor.withOpacity(0.25)
        : (isDark ? Colors.white10 : Colors.grey.shade200);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Avatar ───────────────────────────────────────────────
        Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(color: avatarBg, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
        ),
        SizedBox(width: 10.w),

        // ── Bubble ───────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + time row
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      displayName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                        color: isCurrentUser
                            ? primaryColor
                            : (isDark ? Colors.white : const Color(0xFF1A2634)),
                      ),
                    ),
                  ),
                  if (userId != null) ...[
                    SizedBox(width: 4.w),
                    Text(
                      '#$userId',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white38 : Colors.grey.shade400,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // Message bubble
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isCurrentUser ? 16.r : 4.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.isEmpty ? '—' : message,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.45,
                    // Bold for unread (is_read == 0), normal for read
                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                    color: isDark
                        ? Colors.white.withOpacity(0.87)
                        : const Color(0xFF1A2634),
                  ),
                ),
              ),

              // Unread badge
              if (isUnread)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Row(
                    children: [
                      Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Unread',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
