import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/ticket_detail_content.dart';
import '../providers/support_providers.dart';
import '../../domain/entities/support_ticket.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_modal.dart';
import '../../../../core/themes/app_colors.dart';
import 'create_ticket_page.dart';
import '../../../../core/themes/app_icons.dart';

class SupportViewPage extends ConsumerWidget {
  final SupportTicket ticket;
  const SupportViewPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Ticket #${ticket.id}",
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              AppIcons.edit,
              color: isDark ? Colors.white70 : AppColors.white,
              size: 20.r,
            ),
            onPressed: () {              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateTicketPage(ticket: ticket),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: isDark ? Colors.white70 : AppColors.white,
              size: 20.r,
            ),
            onSelected: (v) {
              switch (v) {
                case 'create_pfi':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Create PFI — not implemented'),
                    ),
                  );
                  break;
                case 'create_jobcard':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Create JobCard — not implemented'),
                    ),
                  );
                  break;
                case 'more':
                default:
                  _showMoreOptions(context, ref, ticket);
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'create_pfi',
                child: Text('Create PFI', style: TextStyle(fontSize: 14.sp)),
              ),
              PopupMenuItem(
                value: 'create_jobcard',
                child: Text(
                  'Create JobCard',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              const PopupMenuDivider(),
             
            ],
          ),
        ],
      ),

      body: DefaultTabController(
        length: 4,
        child: Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: TicketDetailContent(ticket: ticket),
        ),
      ),
    );
  }

  void _showMoreOptions(
    BuildContext context,
    WidgetRef ref,
    SupportTicket ticket,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: Colors.blue,
                    size: 20.r,
                  ),
                ),
                title: Text('Edit Ticket', style: TextStyle(fontSize: 14.sp)),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateTicketPage(ticket: ticket),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.person_add_rounded,
                    color: Colors.green,
                    size: 20.r,
                  ),
                ),
                title: Text('Assign To', style: TextStyle(fontSize: 14.sp)),
                onTap: () => Navigator.pop(sheetCtx),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                    size: 20.r,
                  ),
                ),
                title: Text('Delete Ticket', style: TextStyle(fontSize: 14.sp)),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _showDeleteConfirmation(context, ref, ticket);
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    SupportTicket ticket,
  ) {
    context.showConfirmationModal(
      title: 'Delete Ticket',
      message:
          'Are you sure you want to delete this ticket? This action cannot be undone.',
      confirmText: 'Delete',
      onConfirm: () async {
        final ticketId = ticket.id;
        if (ticketId == null) return;

        final deleteUc = ref.read(deleteSupportTicketUseCaseProvider);
        try {
          final res = await deleteUc.call(ticketId: ticketId);
          res.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Failed to delete ticket: ${failure.message}'),
                ),
              );
            },
            (_) {
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

              if (Navigator.canPop(context)) Navigator.pop(context);

              Future.microtask(() {
                if (Navigator.canPop(context)) Navigator.pop(context);
                try {
                  ref.read(supportNotifierProvider.notifier).loadTickets();
                } catch (_) {}
              });
            },
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Failed to delete ticket'),
            ),
          );
        }
      },
      icon: Icons.delete_rounded,
      confirmColor: Colors.red,
    );
  }
}
