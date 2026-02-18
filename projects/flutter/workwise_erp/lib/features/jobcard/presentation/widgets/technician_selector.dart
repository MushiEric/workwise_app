import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/themes/app_colors.dart';
import 'searchable_dialog.dart';

class TechnicianSelector extends ConsumerWidget {
  final List<int> selectedIds;
  final List<Map<String, dynamic>> users;
  final Function(List<int>) onChanged;

  const TechnicianSelector({
    super.key,
    required this.selectedIds,
    required this.users,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(16),
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.people_rounded,
                  size: 16,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Assigned Staff',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${selectedIds.length} selected',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Selected technicians chips
          if (selectedIds.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedIds.map((id) {
                final user = users.firstWhere(
                  (u) => (int.tryParse(u['id']?.toString() ?? '') ?? 0) == id,
                  orElse: () => {},
                );
                final name = user.isNotEmpty 
                    ? (user['name'] ?? user['username'] ?? 'Staff $id')
                    : 'Staff $id';
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          final newList = List<int>.from(selectedIds)..remove(id);
                          onChanged(newList);
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Text(
                'No staff selected',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // Select button
          AppButton(
            text: 'Select Staff',
            icon: Icons.person_add_rounded,
            onPressed: () async {
              final selected = await showDialog<List<int>>(
                context: context,
                builder: (ctx) => SearchableDialog<int>(
                  title: 'Select Staff',
                  items: users.map((u) => int.tryParse(u['id']?.toString() ?? '') ?? 0).where((id) => id > 0).toList(),
                  itemDisplay: (id) {
                    final user = users.firstWhere(
                      (u) => (int.tryParse(u['id']?.toString() ?? '') ?? 0) == id,
                      orElse: () => {},
                    );
                    return user.isNotEmpty 
                        ? (user['name'] ?? user['username'] ?? 'Technician $id')
                        : 'Technician $id';
                  },
                  initialMultiValue: selectedIds,
                  multiSelect: true,
                  onMultiSelected: (selected) => onChanged(selected),
                ),
              );              if (selected != null) onChanged(selected);            },
            variant: AppButtonVariant.outline,
            size: AppButtonSize.small,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}