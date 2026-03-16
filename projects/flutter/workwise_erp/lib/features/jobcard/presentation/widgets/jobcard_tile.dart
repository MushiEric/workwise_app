import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/jobcard.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/themes/app_icons.dart';
import '../../../../core/widgets/app_textfield.dart';

class JobcardTile extends StatelessWidget {
  final Jobcard jobcard;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  /// When true, swipe-to-approve (right) and swipe-to-reject (left) are enabled.
  final bool showApproveReject;

  /// When true, a long-press triggers the "Set Reminder" bottom sheet.
  final bool showReminder;

  /// Callbacks fired after confirmation dialogs
  final Future<void> Function(int jobcardId, String? comment)? onApprove;
  final Future<void> Function(int jobcardId, String? reason)? onReject;
  final VoidCallback? onSetReminder;

  /// Pre-resolved receiver display name (passed from the list page after
  /// looking up the receiver ID in the pre-loaded customers / users / vehicles list).
  /// When provided, this takes priority over jobcard.receiverName.
  final String? resolvedReceiverName;

  const JobcardTile({
    super.key,
    required this.jobcard,
    this.onTap,
    this.onDelete,
    this.showApproveReject = false,
    this.showReminder = false,
    this.onApprove,
    this.onReject,
    this.onSetReminder,
    this.resolvedReceiverName,
  });

  Color _getStatusColor(String? statusName) {
    if (statusName == null || statusName.isEmpty) return AppColors.primary;
    final lower = statusName.toLowerCase();
    if (lower.contains('open')) return const Color(0xFF4A6FA5);
    if (lower.contains('completed') ||
        lower.contains('done') ||
        lower.contains('closed'))
      return Colors.green;
    if (lower.contains('pending') || lower.contains('waiting'))
      return Colors.orange;
    if (lower.contains('in progress') || lower.contains('processing'))
      return Colors.blue;
    if (lower.contains('cancelled') || lower.contains('rejected'))
      return Colors.red;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusName = jobcard.statusRow?['name']?.toString() ?? '';
    Color statusColor = _getStatusColor(
      statusName.isNotEmpty ? statusName : jobcard.status,
    );

    final rowColorStr = jobcard.statusRow?['color']?.toString();
    if (rowColorStr != null && rowColorStr.isNotEmpty) {
      statusColor = hexToColor(rowColorStr, fallback: statusColor);
    }

    final displayStatus = statusName.isNotEmpty
        ? statusName
        : (jobcard.status ?? 'Unknown');

    Widget card = _buildCard(context, isDark, statusColor, displayStatus);

    // Wrap with Dismissible for approve/reject swipe gestures
    if (showApproveReject && jobcard.id != null) {
      card = _wrapWithDismissible(context, card, isDark);
    }

    // Wrap with GestureDetector for long-press reminder
    if (showReminder) {
      card = GestureDetector(
        onLongPress: () => _handleLongPress(context),
        child: card,
      );
    }

    return card;
  }

  Widget _wrapWithDismissible(BuildContext context, Widget child, bool isDark) {
    return Dismissible(
      key: ValueKey('jc-${jobcard.id}'),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right → Approve
          return await _showApproveDialog(context, isDark);
        } else {
          // Swipe left → Reject
          return await _showRejectDialog(context, isDark);
        }
      },
      // We never actually remove from list until refresh; return false from
      // confirmDismiss so the item stays visible
      onDismissed: (_) {},
      background: _swipeBackground(
        alignment: Alignment.centerLeft,
        color: Colors.green.shade600,
        icon: AppIcons.checkCircleRounded,
        label: 'Approve',
      ),
      secondaryBackground: _swipeBackground(
        alignment: Alignment.centerRight,
        color: Colors.red.shade600,
        icon: AppIcons.cancelRounded,
        label: 'Reject',
      ),
      child: child,
    );
  }

  Widget _swipeBackground({
    required AlignmentGeometry alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    final isLeft = alignment == Alignment.centerLeft;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isLeft
            ? [
                Icon(icon, color: Colors.white, size: 24.r),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ]
            : [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(icon, color: Colors.white, size: 24.r),
              ],
      ),
    );
  }

  Future<bool> _showApproveDialog(BuildContext context, bool isDark) async {
    final commentCtl = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Icon(
                      AppIcons.checkCircleRounded,
                      color: Colors.green.shade600,
                      size: 24.r,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'JOB CARD APPROVAL',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AppTextField(
                  controller: commentCtl,
                  labelText: 'Comment',
                  hintText: 'Enter Comment here',
                  maxLines: 5,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Approve'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true && onApprove != null) {
      await onApprove!(
        jobcard.id!,
        commentCtl.text.trim().isEmpty ? null : commentCtl.text.trim(),
      );
    }
    commentCtl.dispose();
    return false; // Don't dismiss the tile
  }

  Future<bool> _showRejectDialog(BuildContext context, bool isDark) async {
    final reasonCtl = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Icon(
                      AppIcons.cancelRounded,
                      color: Colors.red.shade600,
                      size: 24.r,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'JOB CARD REJECTION',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
              //   child: Text(
              //     'Reject jobcard ${jobcard.jobcardNumber ?? '#${jobcard.id}'}?',
              //     style: TextStyle(
              //       color: isDark ? Colors.white70 : Colors.grey.shade700,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AppTextField(
                  controller: reasonCtl,
                  labelText: 'Comment',
                  hintText: 'Enter Comment here',
                  maxLines: 5,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true && onReject != null) {
      await onReject!(
        jobcard.id!,
        reasonCtl.text.trim().isEmpty ? null : reasonCtl.text.trim(),
      );
    }
    reasonCtl.dispose();
    return false; // Don't dismiss the tile
  }

  void _handleLongPress(BuildContext context) {
    if (onSetReminder != null) {
      onSetReminder!();
      return;
    }
    // Default: show a simple bottom sheet
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      AppIcons.notificationsRounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Set Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Jobcard: ${jobcard.jobcardNumber ?? '#${jobcard.id}'}',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(AppIcons.accessTimeRounded),
                  title: const Text('Remind me in 1 hour'),
                  onTap: () => Navigator.of(ctx).pop(),
                ),
                ListTile(
                  leading: const Icon(AppIcons.calendarTodayRounded),
                  title: const Text('Remind me tomorrow'),
                  onTap: () => Navigator.of(ctx).pop(),
                ),
                ListTile(
                  leading: const Icon(AppIcons.editCalendarRounded),
                  title: const Text('Custom reminder'),
                  onTap: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    bool isDark,
    Color statusColor,
    String displayStatus,
  ) {
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
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row: JC number · status badge ──
              Row(
                children: [
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      jobcard.jobcardNumber ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                        fontSize: 13.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Status badge
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
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          displayStatus,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              // ── Subject (full text, no truncation) ──
              Text(
                jobcard.service != null && jobcard.service!.isNotEmpty
                    ? jobcard.service!
                    : 'No subject',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),

              SizedBox(height: 10.h),

              // ── Meta chips row ──
              Wrap(
                spacing: 6.w,
                runSpacing: 4.h,
                children: [
                  // Related To
                  if (jobcard.relatedTo != null &&
                      jobcard.relatedTo!.isNotEmpty)
                    _metaChip(
                      isDark: isDark,
                      icon: AppIcons.categoryRounded,
                      label: jobcard.relatedTo!,
                    ),
                  // Receiver name
                  if (_receiverLabel.isNotEmpty)
                    _metaChip(
                      isDark: isDark,
                      icon: _receiverIcon,
                      label: _receiverLabel,
                    ),
                  // Location
                  if (jobcard.location != null &&
                      jobcard.location!.isNotEmpty &&
                      jobcard.location != 'null')
                    _metaChip(
                      isDark: isDark,
                      icon: AppIcons.locationOnRounded,
                      label: jobcard.location!,
                    ),
                  // Departments
                  if (_departmentLabel.isNotEmpty)
                    _metaChip(
                      isDark: isDark,
                      icon: AppIcons.businessRounded,
                      label: _departmentLabel,
                    ),
                ],
              ),

              SizedBox(height: 10.h),

              // ── Date row ──
              Row(
                children: [
                  Icon(
                    AppIcons.accessTimeRounded,
                    size: 14.r,
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    jobcard.reportedDate ?? 'Unknown date',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
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

  IconData get _receiverIcon {
    final relatedTo = jobcard.relatedTo?.toLowerCase() ?? '';
    if (relatedTo.contains('vehicle')) {
      return AppIcons.truck;
    }
    return AppIcons.personRounded;
  }

  String get _receiverLabel {
    // Prefer the pre-resolved name (looked up from cached customers/users/vehicles)
    if (resolvedReceiverName != null && resolvedReceiverName!.isNotEmpty) {
      return resolvedReceiverName!;
    }
    if (jobcard.receiverName != null &&
        jobcard.receiverName!.isNotEmpty &&
        jobcard.receiverName != 'null') {
      return jobcard.receiverName!;
    }
    if (jobcard.receiver != null &&
        jobcard.receiver!.isNotEmpty &&
        jobcard.receiver != 'null' &&
        jobcard.receiver != '0') {
      return jobcard.receiver!;
    }
    return '';
  }

  String get _departmentLabel {
    if (jobcard.departments == null) return '';
    final d = jobcard.departments!.trim();
    if (d.isEmpty || d == '[]' || d == 'null') return '';
    if (d.startsWith('[')) {
      final inner = d
          .substring(1, d.length - 1)
          .split(',')
          .map((e) => e.trim().replaceAll('"', ''))
          .where((e) => e.isNotEmpty)
          .toList();
      return inner.isEmpty ? '' : inner.join(', ');
    }
    return d;
  }

  Widget _metaChip({
    required bool isDark,
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11.r,
            color: isDark ? Colors.white38 : Colors.grey.shade500,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
