import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/ticket_detail_content.dart';
import '../providers/support_providers.dart';
import '../../domain/entities/support_ticket.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_modal.dart';
import '../../../../core/themes/app_colors.dart';

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
            icon: Icon(Icons.share_rounded, color: isDark ? Colors.white70 : AppColors.white),
            onPressed: () {
              // page-level share
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share ticket — not implemented')));
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: isDark ? Colors.white70 : AppColors.white),
            onSelected: (v) {
              switch (v) {
                case 'create_pfi':
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create PFI — not implemented')));
                  break;
                case 'create_jobcard':
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create JobCard — not implemented')));
                  break;
                case 'more':
                default:
                  _showMoreOptions(context, ref, ticket);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'create_pfi', child: Text('Create PFI')),
              const PopupMenuItem(value: 'create_jobcard', child: Text('Create JobCard')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'more', child: Text('More...')),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: TicketDetailContent(ticket: ticket),
      ),
    );
  }

  void _showMoreOptions(BuildContext context, WidgetRef ref, SupportTicket ticket) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
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
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.edit_rounded, color: Colors.blue),
                ),
                title: const Text('Edit Ticket'),
                onTap: () => Navigator.pop(sheetCtx),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.person_add_rounded, color: Colors.green),
                ),
                title: const Text('Assign To'),
                onTap: () => Navigator.pop(sheetCtx),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.delete_rounded, color: Colors.red),
                ),
                title: const Text('Delete Ticket'),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  // use the page-level `context` (captured) so subsequent modals use a valid navigator
                  _showDeleteConfirmation(context, ref, ticket);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, SupportTicket ticket) {
    context.showConfirmationModal(
      title: 'Delete Ticket',
      message: 'Are you sure you want to delete this ticket? This action cannot be undone.',
      confirmText: 'Delete',
      onConfirm: () async {
        final ticketId = ticket.id;
        if (ticketId == null) return;

        final deleteUc = ref.read(deleteSupportTicketUseCaseProvider);
        try {
          final res = await deleteUc.call(ticketId: ticketId);
          res.fold((failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete ticket: ${failure.message}')));
          }, (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Ticket deleted'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );

            // close confirmation modal
            if (Navigator.canPop(context)) Navigator.pop(context);

            // close page and refresh list
            Future.microtask(() {
              if (Navigator.canPop(context)) Navigator.pop(context);
              try {
                ref.read(supportNotifierProvider.notifier).loadTickets();
              } catch (_) {}
            });
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete ticket')));
        }
      },
      icon: Icons.delete_rounded,
      confirmColor: Colors.red,
    );
  }
}

