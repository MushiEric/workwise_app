import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/themes/app_icons.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/widgets/app_textfields.dart';
import 'package:workwise_erp/core/widgets/app_smart_dropdown.dart';
import '../providers/invoice_providers.dart';
import '../../../../features/sales/presentation/providers/sales_providers.dart';
import '../../../../features/customer/presentation/providers/customer_providers.dart';
import '../../../../features/jobcard/presentation/providers/jobcard_providers.dart';
import '../widgets/invoice_items_list.dart';

class InvoiceCreatePage extends ConsumerStatefulWidget {
  final int? editId;
  const InvoiceCreatePage({super.key, this.editId});

  @override
  ConsumerState<InvoiceCreatePage> createState() => _InvoiceCreatePageState();
}

class _InvoiceCreatePageState extends ConsumerState<InvoiceCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtl = TextEditingController();
  final _issueDateCtl = TextEditingController();
  final _dueDateCtl = TextEditingController();
  final _notesCtl = TextEditingController();
  final _termsCtl = TextEditingController();

  int? _customerId;
  int? _currencyId;
  String? _discountType = 'Before Tax';
  String? _showDiscountPerItem = 'Disable';
  bool _showTaxPerItem = true;
  int? _ticketId;
  int? _jobcardId;
  int? _projectId;
  int? _tripId;
  int? _orderId;
  int? _deliveryNoteId;
  int? _warehouseId;
  int? _agentId;
  int? _paymentTermId;
  String? _paymentMethod = 'Cash';
  String? _exchangeRate = '1.0';
  String? _defaultUnitLabel = 'Qty';
  bool _showPeriod = false;

  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _issueDateCtl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _dueDateCtl.text = DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)));
    
    if (widget.editId != null) {
      Future.microtask(() async {
        await ref.read(invoiceNotifierProvider.notifier).fetchInvoiceById(widget.editId!.toString());
        final inv = ref.read(invoiceNotifierProvider).currentInvoice;
        if (inv != null) {
          _subjectCtl.text = inv.subject ?? '';
          _issueDateCtl.text = inv.issueDate ?? '';
          _dueDateCtl.text = inv.dueDate ?? '';
          _notesCtl.text = inv.notes ?? '';
          _termsCtl.text = inv.termsConditions ?? '';
          
          setState(() {
            _customerId = inv.customerId;
            // Map strings to IDs if possible, or keep as is.
            _discountType = inv.discountType ?? 'Before Tax';
            _showDiscountPerItem = inv.showDiscountPerItem == true ? 'Yes' : 'No';
            _showTaxPerItem = inv.showTaxPerItem ?? true;
            _ticketId = inv.ticketId;
            _jobcardId = inv.jobcardId;
            _projectId = inv.projectId;
            _tripId = inv.tripId;
            _orderId = int.tryParse(inv.orderId ?? '');
            _deliveryNoteId = inv.deliveryNoteId;
            _warehouseId = inv.warehouseId;
            _agentId = inv.agentId;
            _paymentTermId = inv.paymentTermId;
            _paymentMethod = inv.paymentMethod ?? 'Cash';
            
            if (inv.items != null) {
              _items = inv.items!.map((it) => {
                'id': it.id,
                'item_id': it.itemId,
                'item_name': it.itemName,
                'description': it.description,
                'quantity': it.quantity,
                'rate': it.rate,
                'tax_id': it.taxId,
                'subtotal': it.subtotal,
              }).toList();
            }
          });
        }
      });
    }
    
    // Load metadata
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customersNotifierProvider.notifier).loadCustomers();
      ref.read(jobcardNotifierProvider.notifier).loadJobcards(perPage: 10000);
    });
  }

  @override
  void dispose() {
    _subjectCtl.dispose();
    _issueDateCtl.dispose();
    _dueDateCtl.dispose();
    _notesCtl.dispose();
    _termsCtl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(invoiceNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
      appBar: CustomAppBar(
        title: widget.editId == null ? 'Create Invoice' : 'Edit Invoice',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('General Information'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _subjectCtl,
                      label: 'Subject',
                      hintText: 'Add subject',
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Builder(builder: (context) {
                      final customersState = ref.watch(customersNotifierProvider);
                      final list = customersState.maybeWhen(
                        loaded: (customers) => customers,
                        orElse: () => [],
                      );
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Customer',
                        hintText: 'Select Customer',
                        value: list
                            .where((e) => e.id == _customerId)
                            .map((e) => {'id': e.id, 'name': e.name})
                            .firstOrNull,
                        items: list.map((e) => {'id': e.id, 'name': e.name}).toList(),
                        itemBuilder: (e) => (e['name'] ?? '').toString(),
                        onChanged: (val) => setState(() => _customerId = val?['id'] as int?),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _issueDateCtl,
                      label: 'Issue Date',
                      readOnly: true,
                      onTap: () => _selectDate(_issueDateCtl),
                      suffixIcon: const Icon(Icons.calendar_today, size: 18),
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: _dueDateCtl,
                      label: 'Due Date',
                      readOnly: true,
                      onTap: () => _selectDate(_dueDateCtl),
                      suffixIcon: const Icon(Icons.calendar_today, size: 18),
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesCurrenciesProvider).valueOrNull ?? [])
                          .map((e) => {'id': e['id'], 'name': e['name']})
                          .toList();
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Currency',
                        hintText: 'Select Currency',
                        value: list.where((e) => e['id'] == _currencyId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => e['name'].toString(),
                        onChanged: (val) => setState(() => _currencyId = val?['id'] as int?),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppSmartDropdown<String>(
                      label: 'Discount Type',
                      hintText: 'Select Type',
                      value: _discountType,
                      items: const ['Before Tax', 'After Tax'],
                      itemBuilder: (e) => e,
                      onChanged: (val) => setState(() => _discountType = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildRadioField(
                label: 'Show Discount Per Items',
                value: _showDiscountPerItem,
                options: ['Yes', 'No', 'Disable'],
                onChanged: (val) => setState(() => _showDiscountPerItem = val),
              ),
              const SizedBox(height: 12),
              _buildRadioField(
                label: 'Show Tax Per Items',
                value: _showTaxPerItem ? 'Yes' : 'No',
                options: ['Yes', 'No'],
                onChanged: (val) => setState(() => _showTaxPerItem = val == 'Yes'),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Related To'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesSupportTicketsProvider).valueOrNull ?? []);
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Support Ticket',
                        hintText: 'Select Ticket',
                        value: list.where((e) => e['id'] == _ticketId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => (e['subject'] ?? e['name'] ?? e['ticket_code'] ?? 'Ticket ${e['id']}').toString(),
                        onChanged: (val) => setState(() => _ticketId = val?['id'] as int?),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesJobcardsProvider).valueOrNull ?? []);
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Job Card',
                        hintText: 'Select Jobcard',
                        value: list.where((e) => e['id'] == _jobcardId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => (e['jobcard_number'] ?? e['name'] ?? 'JC ${e['id']}').toString(),
                        onChanged: (val) => setState(() => _jobcardId = val?['id'] as int?),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesProjectsProvider).valueOrNull ?? []);
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Project',
                        hintText: 'Select Project',
                        value: list.where((e) => e['id'] == _projectId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => (e['name']).toString(),
                        onChanged: (val) => setState(() => _projectId = val?['id'] as int?),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesTripsProvider).valueOrNull ?? []);
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Trip',
                        hintText: 'Select Trip',
                        value: list.where((e) => e['id'] == _tripId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => (e['name']).toString(),
                        onChanged: (val) => setState(() => _tripId = val?['id'] as int?),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesOrdersProvider).valueOrNull ?? []);
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Sale Order',
                        hintText: 'Select order',
                        value: list.where((e) => e['id'] == _orderId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => (e['order_number'] ?? e['name'] ?? 'Order ${e['id']}').toString(),
                        onChanged: (val) => setState(() => _orderId = val?['id'] as int?),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesDeliveryNotesProvider).valueOrNull ?? []);
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Delivery Note',
                        hintText: 'Select delivery note',
                        value: list.where((e) => e['id'] == _deliveryNoteId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => (e['delivery_note_number'] ?? e['name'] ?? 'DN ${e['id']}').toString(),
                        onChanged: (val) => setState(() => _deliveryNoteId = val?['id'] as int?),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesWarehousesProvider).valueOrNull ?? []);
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Warehouse',
                        hintText: 'Select warehouse',
                        value: list.where((e) => e['id'] == _warehouseId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => (e['name']).toString(),
                        onChanged: (val) => setState(() => _warehouseId = val?['id'] as int?),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesUsersProvider).valueOrNull ?? []);
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Sales Agent',
                        hintText: 'Select Sales Agent',
                        value: list.where((e) => e['id'] == _agentId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => (e['name']).toString(),
                        onChanged: (val) => setState(() => _agentId = val?['id'] as int?),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Payment Information'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Builder(builder: (context) {
                      final list = (ref.watch(salesPaymentTermsProvider).valueOrNull ?? []);
                      return AppSmartDropdown<Map<String, dynamic>>(
                        label: 'Payment Terms',
                        hintText: 'Select Terms',
                        value: list.where((e) => e['id'] == _paymentTermId).firstOrNull,
                        items: list,
                        itemBuilder: (e) => (e['name']).toString(),
                        onChanged: (val) => setState(() => _paymentTermId = val?['id'] as int?),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Builder(builder: (context) {
                      final meta = ref.watch(salesPaymentMethodProvider);
                      final list = meta.valueOrNull ?? [];
                      
                      // Handle both dynamic list and hardcoded fallbacks
                      final displayList = list.isNotEmpty 
                        ? list.map((e) => (e['name'] ?? e['label'] ?? '').toString()).toList()
                        : const ['Cash', 'Bank', 'Cheque'];
                      
                      return AppSmartDropdown<String>(
                        label: 'Payment Method',
                        hintText: 'Select Method',
                        value: _paymentMethod,
                        items: displayList,
                        itemBuilder: (e) => e,
                        onChanged: (val) => setState(() => _paymentMethod = val),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              InvoiceItemsList(
                items: _items,
                onChanged: (newItems) => setState(() => _items = newItems),
                exchangeRate: _exchangeRate,
                onExchangeRateChanged: (val) => setState(() => _exchangeRate = val),
                defaultUnitLabel: _defaultUnitLabel,
                onDefaultUnitLabelChanged: (val) => setState(() => _defaultUnitLabel = val),
                showPeriod: _showPeriod,
                onShowPeriodChanged: (val) => setState(() => _showPeriod = val),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Other Notes'),
              const SizedBox(height: 12),
              AppTextField(
                controller: _notesCtl,
                label: 'Notes',
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _termsCtl,
                label: 'Terms & Conditions',
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: widget.editId == null ? 'Create Invoice' : 'Update Invoice',
                isLoading: state.isSaving,
                onPressed: _submit,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
    );
  }

  Widget _buildRadioField({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: options.map((opt) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: opt,
                  groupValue: value,
                  onChanged: (v) => onChanged(v!),
                  activeColor: AppColors.primary,
                ),
                Text(opt),
                const SizedBox(width: 16),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one item is required')),
      );
      return;
    }

    final data = {
      'subject': _subjectCtl.text.trim(),
      'customer_id': _customerId,
      'issue_date': _issueDateCtl.text,
      'due_date': _dueDateCtl.text,
      'currency_id': _currencyId,
      'discount_type': _discountType,
      'show_discount_per_item': _showDiscountPerItem,
      'show_tax_per_item': _showTaxPerItem ? 'Yes' : 'No',
      'ticket_id': _ticketId,
      'jobcard_id': _jobcardId,
      'project_id': _projectId,
      'trip_id': _tripId,
      'order_id': _orderId,
      'delivery_note_id': _deliveryNoteId,
      'warehouse_id': _warehouseId,
      'agent_id': _agentId,
      'payment_term_id': _paymentTermId,
      'payment_method': _paymentMethod,
      'exchange_rate': _exchangeRate,
      'default_unit_label': _defaultUnitLabel,
      'show_period': _showPeriod ? 'Yes' : 'No',
      'notes': _notesCtl.text.trim(),
      'terms_conditions': _termsCtl.text.trim(),
      'items': _items,
    };

    final bool success = widget.editId == null
        ? await ref.read(invoiceNotifierProvider.notifier).createInvoice(data)
        : await ref.read(invoiceNotifierProvider.notifier).editInvoice(widget.editId!.toString(), data);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }
}
