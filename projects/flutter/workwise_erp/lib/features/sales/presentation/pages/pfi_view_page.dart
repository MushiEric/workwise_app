import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../pfi/domain/entities/pfi.dart';

class PfiViewPage extends ConsumerWidget {
  final Pfi pfi;
  const PfiViewPage({super.key, required this.pfi});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
      appBar: CustomAppBar(
        title: 'PFI #${pfi.proposalNumber ?? pfi.id}',
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded, color: isDark ? Colors.white70 : Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/sales/pfi/edit', arguments: pfi),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              context,
              title: 'PFI Details',
              isDark: isDark,
              children: [
                _infoRow('Proposal #', pfi.proposalNumber ?? '-'),
                _infoRow('Subject', pfi.subject ?? '-'),
                _infoRow('Created At', pfi.createdAt != null ? DateFormat.yMMMd().format(pfi.createdAt!) : '-'),
                if (pfi.notes != null && pfi.notes!.isNotEmpty) ...[
                  const Divider(),
                  _infoRow('Notes', pfi.notes!),
                ],
              ],
            ),
            
            SizedBox(height: 20.h),
            
            _buildInfoCard(
              context,
              title: 'Line Items',
              isDark: isDark,
              children: [
                if (pfi.items == null || pfi.items!.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(child: Text('No items listed', style: TextStyle(color: Colors.grey, fontSize: 13.sp))),
                  )
                else
                  ...pfi.items!.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        if (idx > 0) const Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
                                child: Icon(Icons.inventory_2_outlined, color: primaryColor, size: 16.r),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.itemId ?? 'Material', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                                    if (item.description != null) 
                                      Text(item.description!, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Text('${item.qty} ${item.uomId ?? ''}', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                                        const Spacer(),
                                        Text('${item.subtotal?.toStringAsFixed(2) ?? '0.00'} TSh', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 13.sp)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
              ],
            ),

            if (pfi.terms != null && pfi.terms!.isNotEmpty) ...[
               SizedBox(height: 20.h),
               _buildInfoCard(
                 context, 
                 title: 'Terms & Conditions', 
                 isDark: isDark, 
                 children: [
                   Text(pfi.terms!, style: TextStyle(fontSize: 13.sp, height: 1.5)),
                 ],
               ),
            ],
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required List<Widget> children, required bool isDark}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
