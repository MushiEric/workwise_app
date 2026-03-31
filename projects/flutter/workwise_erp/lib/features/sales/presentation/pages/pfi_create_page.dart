import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_icons.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_textfields.dart';
import '../../../../core/widgets/app_smart_dropdown.dart';
import '../../../pfi/domain/entities/pfi.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_providers.dart';
import '../../../pfi/presentation/providers/pfi_providers.dart';

class PfiCreatePage extends ConsumerStatefulWidget {
  final Pfi? pfi;
  const PfiCreatePage({super.key, this.pfi});

  @override
  ConsumerState<PfiCreatePage> createState() => _PfiCreatePageState();
}

class _PfiCreatePageState extends ConsumerState<PfiCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _proposalNumberCtl = TextEditingController();
  final _subjectCtl = TextEditingController();
  final _dateCtl = TextEditingController();
  final _notesCtl = TextEditingController();
  final _termsCtl = TextEditingController();

  int? _selectedCustomerId;
  int? _selectedStatusId;
  DateTime? _selectedDate;

  List<Customer> _customers = [];
  bool _isLoadingMetadata = false;
  bool _isSubmitting = false;
  bool _generatingPfiNumber = false;

  @override
  void initState() {
    super.initState();
    if (widget.pfi != null) {
      _proposalNumberCtl.text = widget.pfi!.proposalNumber ?? '';
      _subjectCtl.text = widget.pfi!.subject ?? '';
      _selectedCustomerId = widget.pfi!.customerId;
      if (widget.pfi!.createdAt != null) {
        _selectedDate = widget.pfi!.createdAt!;
        _dateCtl.text = DateFormat.yMMMd().format(_selectedDate!);
      }
    }
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    // customers are now handled by global customersNotifierProvider
    Future.microtask(() {
      ref.read(customersNotifierProvider.notifier).loadCustomers();
    });
  }

  @override
  void dispose() {
    _proposalNumberCtl.dispose();
    _subjectCtl.dispose();
    _dateCtl.dispose();
    _notesCtl.dispose();
    _termsCtl.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtl.text = DateFormat.yMMMd().format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a customer')));
      return;
    }

    setState(() => _isSubmitting = true);
    // TODO: Implement save logic in PFI notifier
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.pfi != null ? 'PFI updated' : 'PFI created'),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final settingsAsync = ref.watch(pfiSettingsProvider);
    final cfg = settingsAsync.value ?? <String, dynamic>{};
    bool show(String key) {
      if (!cfg.containsKey(key)) return true;
      return cfg[key] == true;
    }

    ref.listen<AsyncValue<Map<String, dynamic>>>(pfiSettingsProvider, (
      prev,
      next,
    ) {
      if (widget.pfi == null && next.hasValue) {
        final data = next.value!;
        if (_notesCtl.text.isEmpty) {
          final notesRaw =
              data['pfi_client_notes']
                  ?.toString()
                  .replaceAll('&nbsp;', ' ')
                  .replaceAll('<br>', '\n') ??
              '';
          _notesCtl.text = notesRaw.trim();
        }
        if (_termsCtl.text.isEmpty) {
          final termsRaw =
              data['pfi_terms_condition']
                  ?.toString()
                  .replaceAll('&nbsp;', ' ')
                  .replaceAll('<br>', '\n') ??
              '';
          _termsCtl.text = termsRaw.trim();
        }
      }
    });

    // Ensure pfiSettingsProvider is read so we can dynamically adapt form layout
    ref.watch(pfiSettingsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : Colors.white,
      appBar: CustomAppBar(
        title: widget.pfi != null ? 'Edit PFI' : 'Create PFI',
      ),
      body: _isLoadingMetadata
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: _proposalNumberCtl,
                      label: 'Proposal Number *',
                      hintText: 'e.g. PFI-2024-001',
                      validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _subjectCtl,
                      label: 'Subject *',
                      hintText: 'e.g. Pro Forma for Spares',
                      validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    ),
                    SizedBox(height: 16.h),
                    AppSmartDropdown<int>(
                      value: _selectedCustomerId,
                      items: _customers.map((c) => c.id!).toList(),
                      itemBuilder: (id) =>
                          _customers.firstWhere((c) => c.id == id).name ??
                          'Unknown',
                      label: 'Customer *',
                      hintText: 'Select customer',
                      onChanged: (id) =>
                          setState(() => _selectedCustomerId = id),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _dateCtl,
                      label: 'PFI Date',
                      hintText: 'Select date',
                      readOnly: true,
                      onTap: _selectDate,
                      suffixIcon: Icon(
                        AppIcons.calendar,
                        size: 20.r,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    AppButton(
                      text: widget.pfi != null ? 'Update PFI' : 'Create PFI',
                      onPressed: _submit,
                      isLoading: _isSubmitting,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
