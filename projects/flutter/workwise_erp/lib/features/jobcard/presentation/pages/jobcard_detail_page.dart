import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/widgets/app_dialog.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../providers/jobcard_detail_providers.dart';
import 'package:workwise_erp/features/support/domain/entities/support_department.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_tab_bar.dart';
import '../../../../core/themes/app_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/jobcard_providers.dart';
import '../widgets/jobcard_tile.dart';
import '../../../../core/widgets/app_modal.dart';
import 'jobcard_create_page.dart';

class JobcardDetailPage extends ConsumerStatefulWidget {
  const JobcardDetailPage({super.key});

  @override
  ConsumerState<JobcardDetailPage> createState() => _JobcardDetailPageState();
}

class _JobcardDetailPageState extends ConsumerState<JobcardDetailPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;

  int? _id;
  bool _isApproving = false;
  bool _isRejecting = false;

  bool? _isApprovalEligible;
  int? _approvalId;
  int? _roleUserId;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is int) {
      _id = arg;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        ref.read(jobcardDetailNotifierProvider.notifier).load(_id!);
        await _refreshApprovalEligibility();
      });
    }
    _tabController ??= TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Future<bool> _checkApprovalEligibility(int id) async {
    final checkUc = ref.read(checkApprovalEligibilityUseCaseProvider);
    final result = await checkUc.call(id);

    return result.fold(
      (_) {
        _approvalId = null;
        _roleUserId = null;
        return false;
      },
      (data) {
        // Backend returns { status: 200, eligible: true, ... }
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

        _approvalId = parseInt(data['approval_id']);
        _roleUserId = parseInt(data['role_user_id']);

        // Fallback: if the API didn't return approval_id / role_user_id,
        // extract them from the already-loaded jobcard's pending approval record.
        if (eligible && (_approvalId == null || _roleUserId == null)) {
          final jobcard = ref.read(jobcardDetailNotifierProvider).item;
          if (jobcard != null) {
            final approvals = (jobcard.approvals ?? <dynamic>[]) as List;
            for (final a in approvals) {
              if (a is! Map) continue;
              final statusVal = a['status'];
              final isPending =
                  statusVal == null ||
                  statusVal == 1 ||
                  statusVal.toString() == '1';
              if (isPending) {
                _approvalId ??= parseInt(a['id']);
                _roleUserId ??= parseInt(
                  a['role_user_id'] ?? a['roleUserId'] ?? a['role_userid'],
                );
                break;
              }
            }
            // Last resort: take values from the first approval record.
            if ((_approvalId == null || _roleUserId == null) &&
                approvals.isNotEmpty &&
                approvals.first is Map) {
              final first = approvals.first as Map;
              _approvalId ??= parseInt(first['id']);
              _roleUserId ??= parseInt(
                first['role_user_id'] ??
                    first['roleUserId'] ??
                    first['role_userid'],
              );
            }
          }
        }

        return eligible;
      },
    );
  }

  Future<void> _refreshApprovalEligibility() async {
    if (_id == null) return;
    final eligible = await _checkApprovalEligibility(_id!);
    if (!mounted) return;
    setState(() => _isApprovalEligible = eligible);
  }

  Future<void> _approveJobcard(int id) async {
    if (_isApproving) return;
    setState(() => _isApproving = true);

    final eligible = await _checkApprovalEligibility(id);
    if (!eligible) {
      if (!mounted) return;
      setState(() => _isApproving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          content: const Text('Not eligible to approve this jobcard'),
        ),
      );
      return;
    }

    final comment = await _askApprovalComment();
    if (!mounted) return;
    if (comment == null) {
      setState(() => _isApproving = false);
      return;
    }

    showAppLoadingDialog(context, message: 'Approving...');
    if (_approvalId == null || _roleUserId == null) {
      if (!mounted) return;
      hideAppLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Unable to determine approval context'),
        ),
      );
      setState(() => _isApproving = false);
      return;
    }

    final approveUc = ref.read(approveJobcardUseCaseProvider);
    final res = await approveUc.call(
      jobcardId: id,
      status: 3,
      approvalId: _approvalId!,
      roleUserId: _roleUserId!,
      comment: comment,
    );
    if (!mounted) return;
    hideAppLoadingDialog(context);

    setState(() => _isApproving = false);

    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          content: Text('Approval failed: $l'),
        ),
      ),
      (_) async {
        // Immediately hide the buttons before the async reload completes.
        if (mounted) setState(() => _isApprovalEligible = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text('Jobcard approved successfully'),
          ),
        );
        if (_id != null) {
          await ref.read(jobcardDetailNotifierProvider.notifier).load(_id!);
          await _refreshApprovalEligibility();
        }
      },
    );
  }

  Future<String?> _askRejectionReason() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return JobcardTile.showRejectCommentDialog(context, isDark: isDark);
  }

  Future<String?> _askApprovalComment() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return JobcardTile.showApproveCommentDialog(context, isDark: isDark);
  }

  Future<void> _rejectJobcard(int id) async {
    if (_isRejecting) return;

    // Re-check eligibility so that _approvalId and _roleUserId are populated.
    final eligible = await _checkApprovalEligibility(id);
    if (!mounted) return;
    if (!eligible) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          content: const Text('Not eligible to reject this jobcard'),
        ),
      );
      return;
    }

    if (_approvalId == null || _roleUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Unable to determine approval context'),
        ),
      );
      return;
    }

    final reason = await _askRejectionReason();
    if (!mounted) return;
    if (reason == null) return;

    setState(() => _isRejecting = true);
    showAppLoadingDialog(context, message: 'Rejecting...');
    final rejectUc = ref.read(rejectJobcardUseCaseProvider);
    final res = await rejectUc.call(
      jobcardId: id,
      status: 2,
      approvalId: _approvalId!,
      roleUserId: _roleUserId!,
      comment: reason,
    );
    if (!mounted) return;
    hideAppLoadingDialog(context);

    setState(() => _isRejecting = false);

    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          content: Text('Rejection failed: $l'),
        ),
      ),
      (_) async {
        // Immediately hide the buttons before the async reload completes.
        if (mounted) setState(() => _isApprovalEligible = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Jobcard rejected'),
          ),
        );
        if (_id != null) {
          await ref.read(jobcardDetailNotifierProvider.notifier).load(_id!);
          await _refreshApprovalEligibility();
        }
      },
    );
  }

  Future<void> _deleteJobcard(BuildContext context, int? id) async {
    if (id == null) return;
    context.showConfirmationModal(
      title: 'Delete Jobcard',
      message: 'Delete this jobcard? This cannot be undone.',
      confirmText: 'Delete',
      confirmColor: Colors.red,
      icon: AppIcons.trash2,
      onConfirm: () async {
        showAppLoadingDialog(context, message: 'Deleting...');
        final res = await ref.read(deleteJobcardUseCaseProvider).call(id: id);
        if (!mounted) return;
        hideAppLoadingDialog(context);
        res.fold(
          (l) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Failed to delete: $l'),
              backgroundColor: Colors.red,
            ),
          ),
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Jobcard deleted'),
              ),
            );
            Navigator.of(context).pop();
            try {
              ref
                  .read(jobcardNotifierProvider.notifier)
                  .loadJobcards(force: true);
            } catch (_) {}
          },
        );
      },
    );
  }

  Widget _buildDetailSkeleton(bool isDark) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Jobcard Information card skeleton ──────────────────────
              _shimmerCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _shimmerBox(
                          width: 18.w,
                          height: 18.h,
                          isDark: isDark,
                          radius: 4.r,
                        ),
                        SizedBox(width: 8.w),
                        _shimmerBox(width: 140.w, height: 16.h, isDark: isDark),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    ...List.generate(
                      6,
                      (_) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          children: [
                            _shimmerBox(
                              width: 100.w,
                              height: 13.h,
                              isDark: isDark,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _shimmerBox(
                                width: double.infinity,
                                height: 13.h,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // ── Status section skeleton ────────────────────────────────
              _shimmerCard(
                isDark: isDark,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    _shimmerBox(
                      width: 16.w,
                      height: 16.h,
                      isDark: isDark,
                      radius: 4.r,
                    ),
                    SizedBox(width: 8.w),
                    _shimmerBox(width: 48.w, height: 14.h, isDark: isDark),
                    SizedBox(width: 16.w),
                    _shimmerBox(
                      width: 9.w,
                      height: 9.h,
                      isDark: isDark,
                      isCircle: true,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _shimmerBox(
                        width: double.infinity,
                        height: 14.h,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // ── Summary of Tasks skeleton ──────────────────────────────
              _shimmerCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _shimmerBox(
                          width: 18.w,
                          height: 18.h,
                          isDark: isDark,
                          radius: 4.r,
                        ),
                        SizedBox(width: 8.w),
                        _shimmerBox(width: 155.w, height: 16.h, isDark: isDark),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _shimmerBox(
                      width: double.infinity,
                      height: 13.h,
                      isDark: isDark,
                    ),
                    SizedBox(height: 8.h),
                    _shimmerBox(
                      width: double.infinity,
                      height: 13.h,
                      isDark: isDark,
                    ),
                    SizedBox(height: 8.h),
                    _shimmerBox(width: 220.w, height: 13.h, isDark: isDark),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // ── Recommendation skeleton ────────────────────────────────
              _shimmerCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _shimmerBox(
                          width: 18.w,
                          height: 18.h,
                          isDark: isDark,
                          radius: 4.r,
                        ),
                        SizedBox(width: 8.w),
                        _shimmerBox(width: 130.w, height: 16.h, isDark: isDark),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _shimmerBox(
                      width: double.infinity,
                      height: 13.h,
                      isDark: isDark,
                    ),
                    SizedBox(height: 8.h),
                    _shimmerBox(width: 180.w, height: 13.h, isDark: isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// A shimmer-animated coloured box.
  Widget _shimmerBox({
    required double width,
    required double height,
    required bool isDark,
    double? radius,
    bool isCircle = false,
  }) {
    final t = _shimmerAnimation.value;
    final baseColor = isDark
        ? const Color(0xFF1E2433)
        : const Color(0xFFE8EAED);
    final highlightColor = isDark
        ? const Color(0xFF2E3650)
        : const Color(0xFFF4F5F7);
    final color = Color.lerp(baseColor, highlightColor, t)!;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: isCircle ? null : BorderRadius.circular(radius ?? 6.r),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }

  /// A shimmer-animated card container.
  Widget _shimmerCard({
    required bool isDark,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    final t = _shimmerAnimation.value;
    final borderColor = isDark
        ? Color.lerp(Colors.white10, Colors.white12, t)!
        : Color.lerp(Colors.grey.shade200, Colors.grey.shade100, t)!;
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Color.lerp(const Color(0xFF10142A), const Color(0xFF151A2E), t)!
            : Color.lerp(Colors.white, const Color(0xFFFAFAFA), t)!,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: child,
    );
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
        backgroundColor: isDark
            ? const Color(0xFF0A0E21)
            : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: state.item != null
              ? 'Jobcard #${_getJobcardNumber(state.item)}'
              : 'Jobcard Detail',
          elevation: 0,
          actions: [
            if (!_hasRejectedApproval(state.item))
              IconButton(
                icon: Icon(
                  AppIcons.edit,
                  color: isDark ? Colors.white70 : AppColors.white,
                ),
                onPressed: () {
                  if (state.item != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            JobcardCreatePage(existingJobcard: state.item),
                      ),
                    );
                  }
                },
              ),
            PopupMenuButton<String>(
              icon: Icon(
                AppIcons.moreVertical,
                color: isDark ? Colors.white70 : AppColors.white,
              ),
              onSelected: (v) {
                if (v == 'set_reminder') {
                  if (state.item != null) {
                    // TODO: implement set reminder functionality (date picker, save reminder)
                  }
                } else if (v == 'print') {
                  // TODO: implement print functionality
                } else if (v == 'delete') {
                  _deleteJobcard(context, state.item?.id);
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'set_reminder',
                  child: Row(
                    children: [
                      Icon(
                        AppIcons.notificationsRounded,
                        size: 16.r,
                        color: AppColors.black,
                      ),
                      SizedBox(width: 8.w),
                      const Text('Set Reminder'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'print',
                  child: Row(
                    children: [
                      Icon(AppIcons.print, size: 16.r, color: AppColors.black),
                      SizedBox(width: 8.w),
                      const Text(
                        'Print',
                        style: TextStyle(color: AppColors.black),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(AppIcons.trash2, size: 16.r, color: Colors.red),
                      SizedBox(width: 8.w),
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: state.loading
            ? _buildDetailSkeleton(isDark)
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
                AppIcons.errorOutlineRounded,
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
              icon: Icon(AppIcons.refreshCcwRounded),
              onPressed: () {
                if (_id != null) {
                  ref.read(jobcardDetailNotifierProvider.notifier).load(_id!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    dynamic jobcard,
    bool isDark,
  ) {
    return Column(
      children: [
        // Tab Bar
        AppTabBar(
          controller: _tabController!,
          tabs: const [
            'Overview',
            'Approval Logs',
            'Repairs & Replacement',
            'Logs',
            'Inspection',
            'Picking Slip',
          ],
          margin: EdgeInsets.only(top: 16.h, left: 4.w, right: 16.w),
        ),
        const SizedBox(height: 12),

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
    final usersAsync = ref.watch(jobcardUsersForDetailProvider);
    final departmentsAsync = ref.watch(jobcardDepartmentsForDetailProvider);
    final relatedTo = jobcard.relatedTo?.toString() ?? '';
    final receiversAsync = relatedTo.isNotEmpty
        ? ref.watch(jobcardReceiversForDetailProvider(relatedTo))
        : const AsyncData(<Map<String, dynamic>>[]);

    final users = usersAsync.valueOrNull ?? [];

    final receivers = receiversAsync.valueOrNull ?? [];

    final currentStatusId = jobcard.status?.toString() ?? '';
    final statusRow = jobcard.statusRow as Map<String, dynamic>?;
    final currentStatusName = statusRow?['name']?.toString() ?? currentStatusId;
    final currentStatusColor = statusRow?['color'] != null
        ? _hexColor(statusRow!['color'].toString())
        : _getStatusColor(currentStatusName);

    // Resolve departments - look up IDs to names
    final rawDepts = jobcard.departments?.toString() ?? '[]';
    String departmentsDisplay = '-';
    try {
      final cleaned = rawDepts.replaceAll(RegExp(r'[\[\]" \\]'), '').trim();
      if (cleaned.isNotEmpty && cleaned != 'null') {
        final ids = cleaned
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        final depts = departmentsAsync.valueOrNull ?? [];
        if (depts.isNotEmpty) {
          final names = ids.map((id) {
            final dept = depts.firstWhere(
              (d) => d.id?.toString() == id,
              orElse: () => const SupportDepartment(id: null, name: null),
            );
            return dept.name ?? id;
          }).toList();
          departmentsDisplay = names.join(', ');
        } else if (departmentsAsync.isLoading) {
          departmentsDisplay = 'Loading...';
        } else {
          departmentsDisplay = ids.join(', ');
        }
      }
    } catch (_) {}

    // Resolve staff names from technician IDs
    String staffDisplay = '-';
    try {
      final rawTech = jobcard.technicianId?.toString() ?? '[]';
      final cleaned = rawTech.replaceAll(RegExp(r'[\[\]"\\]'), '').trim();
      if (cleaned.isNotEmpty && cleaned != 'null') {
        final ids = cleaned
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (users.isNotEmpty) {
          final names = ids.map((id) {
            final user = users.firstWhere(
              (u) => u['id']?.toString() == id,
              orElse: () => {},
            );
            return user.isNotEmpty ? (user['name']?.toString() ?? id) : id;
          }).toList();
          staffDisplay = names.join(', ');
        } else if (usersAsync.isLoading) {
          staffDisplay = 'Loading...';
        } else {
          staffDisplay = ids.join(', ');
        }
      }
    } catch (_) {}

    // Resolve receiver name
    String receiverDisplay = '-';
    final receiverRaw = jobcard.receiver?.toString();
    if (jobcard.receiverName?.toString().isNotEmpty == true &&
        jobcard.receiverName != 'null') {
      receiverDisplay = jobcard.receiverName!;
    } else if (receiverRaw != null &&
        receiverRaw.isNotEmpty &&
        receiverRaw != 'null' &&
        receiverRaw != '0') {
      if (receivers.isNotEmpty) {
        final match = receivers.firstWhere(
          (r) => r['id']?.toString() == receiverRaw,
          orElse: () => {},
        );
        if (match.isNotEmpty) {
          receiverDisplay =
              (match['vehicle_name'] ??
                      match['name'] ??
                      match['title'] ??
                      match['registration'] ??
                      match['plate_number'] ??
                      match['username'])
                  ?.toString() ??
              receiverRaw;
        } else {
          receiverDisplay = receiverRaw;
        }
      } else if (receiversAsync.isLoading) {
        receiverDisplay = 'Loading...';
      } else {
        receiverDisplay = receiverRaw;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Jobcard Information ─────────────────────────────────────
          _buildInfoCard(
            context,
            title: 'Jobcard Information',
            icon: AppIcons.infoRounded,
            isDark: isDark,
            children: [
              _infoRow(
                'Subject',
                jobcard.service?.toString().isNotEmpty == true
                    ? jobcard.service.toString()
                    : '-',
              ),
              _infoRow('Jobcard #', jobcard.jobcardNumber ?? '-'),
              _infoRow(
                'Related To',
                jobcard.relatedTo?.toString().isNotEmpty == true
                    ? jobcard.relatedTo.toString()
                    : '-',
              ),
              _infoRow('Receiver', receiverDisplay),
              _infoRow(
                'Contact',
                jobcard.contact?.toString().isNotEmpty == true
                    ? jobcard.contact!.toString()
                    : '-',
              ),
              _infoRow('Department', departmentsDisplay),
              _infoRow('Assigned Staff', staffDisplay),
              _infoRow(
                'Started On',
                _formatDate(jobcard.reportedDate?.toString()),
              ),
              _infoRow(
                'Completed On',
                _formatDate(jobcard.dispatchedDate?.toString()),
              ),
              _infoRow(
                'Location',
                jobcard.location?.toString().isNotEmpty == true
                    ? jobcard.location!.toString()
                    : '-',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── 2. Status ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: currentStatusColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(AppIcons.flagRounded, size: 16, color: currentStatusColor),
                const SizedBox(width: 8),
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: currentStatusColor,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: currentStatusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentStatusName.isNotEmpty ? currentStatusName : '-',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 3. Summary of Tasks ─────────────────────────────────────────
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
                    Icon(
                      AppIcons.summarizeRounded,
                      size: 18,
                      color: primaryColor,
                    ),
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
                Text(
                  jobcard.description?.toString().isNotEmpty == true
                      ? jobcard.description.toString()
                      : 'No summary provided.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontStyle:
                        jobcard.description?.toString().isNotEmpty == true
                        ? FontStyle.normal
                        : FontStyle.italic,
                    color: jobcard.description?.toString().isNotEmpty == true
                        ? (isDark ? Colors.white70 : Colors.grey.shade800)
                        : (isDark ? Colors.white38 : Colors.grey.shade400),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 4. Recommendation ───────────────────────────────────────────
          _buildInfoCard(
            context,
            title: 'Recommendation',
            icon: AppIcons.noteRounded,
            isDark: isDark,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  jobcard.notes?.toString().isNotEmpty == true
                      ? jobcard.notes.toString()
                      : 'No recommendation provided.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontStyle: jobcard.notes?.toString().isNotEmpty == true
                        ? FontStyle.normal
                        : FontStyle.italic,
                    color: jobcard.notes?.toString().isNotEmpty == true
                        ? (isDark ? Colors.white70 : Colors.grey.shade800)
                        : (isDark ? Colors.white38 : Colors.grey.shade400),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _hexColor(String hex) {
    try {
      final h = hex.replaceAll('#', '').padLeft(8, 'FF').toUpperCase();
      return Color(int.parse(h, radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty || raw == 'null') return '-';
    try {
      final dt = DateTime.parse(raw);
      final months = [
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
      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}  $hour:$min';
    } catch (_) {
      return raw;
    }
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

  Widget _buildRepairsTab(BuildContext context, dynamic jobcard, bool isDark) {
    final items = jobcard.items ?? <dynamic>[];

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.buildOutlined,
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
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1A2634),
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
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1A2634),
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
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1A2634),
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
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade800,
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
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2634),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item['item_description']?.toString() ??
                                item['item_description2']?.toString() ??
                                item['description']?.toString() ??
                                '-',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600,
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
    final statusesAsync = ref.watch(jobcardStatusesForDetailProvider);
    final statusesMap = statusesAsync.maybeWhen(
      data: (list) => {for (final s in list) s.id?.toString(): s.name ?? ''},
      orElse: () => <String?, String>{},
    );

    // Fallback map: use the jobcard's own statusRow for the current status
    final statusRowData = jobcard.statusRow as Map<String, dynamic>?;
    final Map<String, String> statusRowFallback = {};
    if (statusRowData != null) {
      final sid = statusRowData['id']?.toString();
      final sname = statusRowData['name']?.toString();
      if (sid != null && sname != null) statusRowFallback[sid] = sname;
    }

    String resolveStatusName(String rawStatus) {
      return statusesMap[rawStatus] ??
          statusRowFallback[rawStatus] ??
          rawStatus;
    }

    // Build a map of user_id -> user name.
    // Seed from the jobcard creator, then enrich from nested user objects
    // that may be present on each log entry (various API shapes supported).
    final userCreator = jobcard.userCreator as Map<String, dynamic>?;
    final Map<String, String> userNameMap = {};
    if (userCreator != null) {
      final uid = userCreator['id']?.toString();
      final uname = userCreator['name']?.toString();
      if (uid != null && uname != null) {
        userNameMap[uid] = uname;
      }
    }
    // Enrich map from inline user objects on each log record.
    for (final logEntry in logs) {
      if (logEntry is! Map) continue;
      final entryId = logEntry['user_id']?.toString();
      if (entryId == null || userNameMap.containsKey(entryId)) continue;
      // Try log['user'], log['causer'], log['author']
      for (final key in ['user', 'causer', 'author']) {
        final obj = logEntry[key];
        if (obj is Map) {
          final name =
              obj['name']?.toString() ??
              obj['full_name']?.toString() ??
              obj['username']?.toString();
          if (name != null && name.isNotEmpty) {
            userNameMap[entryId] = name;
            break;
          }
        }
      }
      // Also try direct user_name / username fields on the log entry
      if (!userNameMap.containsKey(entryId)) {
        final directName =
            logEntry['user_name']?.toString() ??
            logEntry['username']?.toString();
        if (directName != null && directName.isNotEmpty) {
          userNameMap[entryId] = directName;
        }
      }
    }

    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.historyRounded,
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
        final rawStatus = log['status']?.toString() ?? '';
        final statusName = resolveStatusName(rawStatus);
        final statusColor = _getStatusColor(statusName);
        final userId = log['user_id']?.toString() ?? '';
        final userName = userNameMap[userId] ?? 'User #$userId';
        final createdAt = _formatDate(log['created_at']?.toString());
        final detail =
            log['comment']?.toString() ?? log['note']?.toString() ?? '';
        final isLast = index == logs.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      AppIcons.historyRounded,
                      size: 10,
                      color: statusColor,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 80,
                    margin: const EdgeInsets.only(top: 4),
                    color: isDark ? Colors.white10 : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          AppIcons.user,
                          size: 14,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            userName,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Text(
                          createdAt,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    if (detail.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        detail,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _hasRejectedApproval(dynamic jobcard) {
    if (jobcard == null) return false;
    null;
    final approvals = (jobcard.approvals ?? <dynamic>[]) as List;
    for (final approval in approvals) {
      final statusVal = approval['status'];
      if (statusVal == null) continue;
      final status = statusVal is int
          ? statusVal
          : int.tryParse(statusVal.toString());
      if (status == 2) return true;
    }
    return false;
  }

  Widget _buildApprovalLogsTab(
    BuildContext context,
    dynamic jobcard,
    bool isDark,
  ) {
    final approvals = (jobcard.approvals ?? <dynamic>[]) as List;

    bool hasPendingApprovalStatus() {
      if (approvals.isEmpty) return false;

      // Pick the approval record with the highest numeric ID (most recent).
      // Some backends return records oldest-first, so checking only
      // approvals.first would show "pending" even after the action completes.
      Map<String, dynamic>? latest;
      int latestId = -1;
      for (final a in approvals) {
        if (a is! Map) continue;
        final rid = a['id'];
        final numId = (rid is int)
            ? rid
            : (int.tryParse(rid?.toString() ?? '') ?? -1);
        if (numId > latestId) {
          latestId = numId;
          latest = Map<String, dynamic>.from(a);
        }
      }
      // If we couldn't find any valid record fall back to first.
      latest ??= (approvals.first is Map)
          ? Map<String, dynamic>.from(approvals.first as Map)
          : null;
      if (latest == null) return false;

      final status = latest['status'];
      // Pending is indicated by: null or 1
      if (status == null) return true;
      if (status is int) return status == 1;
      return status.toString() == '1';
    }

    // Only show approve/reject actions if the server explicitly confirms eligibility
    // and the approval log indicates the jobcard is still pending.
    final canAct = _isApprovalEligible == true && hasPendingApprovalStatus();

    Widget buildActionButtons() {
      if (!canAct || _id == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Approve',
                onPressed: _isApproving || _isRejecting
                    ? null
                    : () => _approveJobcard(_id!),
                isLoading: _isApproving,
                backgroundColor: Colors.green.shade700,
                textColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: 'Reject',
                onPressed: _isApproving || _isRejecting
                    ? null
                    : () => _rejectJobcard(_id!),
                isLoading: _isRejecting,
                backgroundColor: Colors.red.shade700,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (approvals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.approvalRounded,
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

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: approvals.length,
            itemBuilder: (context, index) {
              final approval = approvals[index] as Map<String, dynamic>;
              final dependent = approval['dependent'] as Map<String, dynamic>?;

              // Resolve the display name by trying multiple API response shapes:
              // 1. approval[user][name]  — nested user object
              // 2. approval[approver][name]
              // 3. dependent[user][name]
              // 4. dependent[name]      — role / approver name
              // 5. approval[user_name] / approval[username]
              // 6. Fall back to "User #<id>"
              String? findName(Map<String, dynamic>? m, List<String> keys) {
                if (m == null) return null;
                for (final k in keys) {
                  final v = m[k];
                  if (v is String && v.isNotEmpty) return v;
                }
                return null;
              }

              final userObj = approval['user'] is Map
                  ? Map<String, dynamic>.from(approval['user'] as Map)
                  : null;
              final approverObj = approval['approver'] is Map
                  ? Map<String, dynamic>.from(approval['approver'] as Map)
                  : null;
              final depUserObj = (dependent != null && dependent['user'] is Map)
                  ? Map<String, dynamic>.from(dependent['user'] as Map)
                  : null;

              final userId = approval['user_id']?.toString();
              final displayName =
                  findName(userObj, ['name', 'full_name', 'username']) ??
                  findName(approverObj, ['name', 'full_name', 'username']) ??
                  findName(depUserObj, ['name', 'full_name', 'username']) ??
                  findName(dependent, ['name']) ??
                  (approval['user_name']?.toString().isNotEmpty == true
                      ? approval['user_name'].toString()
                      : null) ??
                  (approval['username']?.toString().isNotEmpty == true
                      ? approval['username'].toString()
                      : null) ??
                  (userId != null && userId.isNotEmpty
                      ? 'User #$userId'
                      : 'Unknown');
              final statusVal = approval['status'];
              int? statusId;
              if (statusVal is int) {
                statusId = statusVal;
              } else if (statusVal != null) {
                statusId = int.tryParse(statusVal.toString());
              }

              final isApproved = statusId == 3;
              final isRejected = statusId == 2;

              final statusLabel = isApproved
                  ? 'Approved'
                  : isRejected
                  ? 'Rejected'
                  : 'Pending';

              final comment = approval['comment']?.toString();
              final hasComment = comment != null && comment.isNotEmpty;
              final createdAt = _formatDate(approval['created_at']?.toString());
              final isNewRound =
                  approval['is_new_round'] == '1' ||
                  approval['is_new_round'] == 1;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row: name + badge
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.1,
                                ),
                                child: Text(
                                  displayName.isNotEmpty
                                      ? displayName[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF1A2634),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          AppIcons.calendar,
                                          size: 12,
                                          color: isDark
                                              ? Colors.white38
                                              : Colors.grey.shade500,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          createdAt,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? Colors.white54
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                        if (isNewRound) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.orange
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            child: Text(
                                              'New Round',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.orange.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isApproved
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isApproved
                                        ? Colors.green.withOpacity(0.3)
                                        : Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isApproved
                                        ? Colors.green.shade700
                                        : (isRejected
                                              ? Colors.red.shade700
                                              : Colors.grey.shade700),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Comment section
                          if (hasComment) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.04)
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.grey.shade200,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Comment',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white38
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    comment,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (!hasComment) ...[
                            const SizedBox(height: 8),
                            Text(
                              'No comment',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        buildActionButtons(),
      ],
    );
  }

  Widget _buildInspectionTab(
    BuildContext context,
    dynamic jobcard,
    bool isDark,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.searchRounded,
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

  Widget _buildPickingSlipTab(
    BuildContext context,
    dynamic jobcard,
    bool isDark,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.receiptLongRounded,
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
    return jobcard.jobcardNumber?.toString() ?? jobcard.id?.toString() ?? 'N/A';
  }

  Color _getStatusColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('completed') ||
        lower.contains('done') ||
        lower.contains('closed')) {
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
