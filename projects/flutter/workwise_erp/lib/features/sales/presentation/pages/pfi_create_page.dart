import 'package:file_picker/file_picker.dart';
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
import '../../domain/entities/sales_order.dart';
import '../../domain/entities/product_summary.dart';
import '../../../pfi/domain/entities/pfi.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_providers.dart';
import '../../../jobcard/presentation/providers/jobcard_providers.dart';
import '../../../support/presentation/providers/support_providers.dart';
import '../../../support/presentation/state/support_state.dart';
import '../providers/sales_providers.dart';
import '../../../pfi/presentation/providers/pfi_providers.dart';

class PfiCreatePage extends ConsumerStatefulWidget {
  final Pfi? pfi;
  const PfiCreatePage({super.key, this.pfi});

  @override
  ConsumerState<PfiCreatePage> createState() => _PfiCreatePageState();
}

class _PfiCreatePageState extends ConsumerState<PfiCreatePage> {
  final _formKey = GlobalKey<FormState>();

  // 1. Details
  final _proposalNumberCtl = TextEditingController();
  final _subjectCtl = TextEditingController();
  final _issueDateCtl = TextEditingController();
  final _dueDateCtl = TextEditingController();

  // 2. Pricing & Linking
  final _exchangeRateCtl = TextEditingController();
  String? _selectedCurrencyId;
  String? _selectedDiscountType;
  String? _showDiscountPerItem = 'Disable';
  String? _showTaxPerItem = 'Yes';
  String? _selectedSupportTicketId;
  String? _selectedJobcardId;
  String? _selectedProjectId;
  String? _selectedTripId;

  // 3. Logistics & Assignment
  String? _selectedWarehouseId;
  String? _selectedSalesAgentId;
  String? _attachmentPath;
  String? _attachmentName;
  String? _selectedPaymentTermsId;
  String? _selectedPaymentMethodId;

  // 4. Subscription
  final _subscriptionStartDateCtl = TextEditingController();
  final _subscriptionEndDateCtl = TextEditingController();
  String? _subscriptionDuration;
  bool _isRecurring = false;

  // 5. Items
  List<PfiItem> _items = [];
  final _defaultUnitLabelCtl = TextEditingController(text: 'Qty');
  bool _showPeriod = true;

  // 6. Footer
  final _notesCtl = TextEditingController();
  final _termsCtl = TextEditingController();

  int? _selectedCustomerId;
  bool _isLoadingMetadata = false;
  bool _isSubmitting = false;
  bool _generatingPfiNumber = false;

  @override
  void initState() {
    super.initState();
    _exchangeRateCtl.text = '1.00';
    if (widget.pfi != null) {
      _loadPfiData();
    } else {
      final now = DateTime.now();
      _issueDateCtl.text = DateFormat('yyyy-MM-dd').format(now);
      _dueDateCtl.text = DateFormat('yyyy-MM-dd').format(now);
      WidgetsBinding.instance.addPostFrameCallback((_) => _generatePfiNumber());
    }
    _loadMetadata();
    // Pre-fetch support tickets using the existing module notifier
    Future.microtask(() {
      ref.read(supportNotifierProvider.notifier).loadTickets(limit: 1000);
    });
  }

  Future<void> _generatePfiNumber() async {
    setState(() => _generatingPfiNumber = true);
    try {
      final remote = ref.read(salesRemoteDataSourceProvider);
      final num = await remote.generateUniqueNumber('proposals', 'proposal_number');
      if (num != null && mounted) {
        _proposalNumberCtl.text = num;
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _generatingPfiNumber = false);
    }
  }

  void _loadPfiData() {
    final p = widget.pfi!;
    _proposalNumberCtl.text = p.proposalNumber ?? '';
    _subjectCtl.text = p.subject ?? '';
    _selectedCustomerId = p.customerId;
    if (p.issue_date != null) _issueDateCtl.text = DateFormat('yyyy-MM-dd').format(p.issue_date!);
    if (p.due_date != null) _dueDateCtl.text = DateFormat('yyyy-MM-dd').format(p.due_date!);
    _exchangeRateCtl.text = p.currencyExchangeRate ?? '1.00';
    _selectedCurrencyId = p.currency?.toString();
    _selectedDiscountType = p.discountType;
    _showDiscountPerItem = p.showDiscountPerItem ?? 'Disable';
    _showTaxPerItem = p.showTaxPerItem ?? 'Yes';
    _selectedSupportTicketId = p.supportTicketId;
    _selectedJobcardId = p.jobcardId;
    _selectedProjectId = p.projectId;
    _selectedTripId = p.tripId;
    _selectedWarehouseId = p.warehouseId;
    _selectedSalesAgentId = p.salesAgentId;
    _attachmentName = p.attachmentPath?.split('/').last;
    _selectedPaymentTermsId = p.paymentTermsId;
    _selectedPaymentMethodId = p.paymentMethodId;
    if (p.subscriptionStartDate != null) _subscriptionStartDateCtl.text = DateFormat('yyyy-MM-dd').format(p.subscriptionStartDate!);
    if (p.subscriptionEndDate != null) _subscriptionEndDateCtl.text = DateFormat('yyyy-MM-dd').format(p.subscriptionEndDate!);
    _subscriptionDuration = p.subscriptionDuration;
    _isRecurring = p.isRecurring ?? false;
    _items = p.items ?? [];
    _notesCtl.text = p.notes ?? '';
    _termsCtl.text = p.terms ?? '';
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
    _issueDateCtl.dispose();
    _dueDateCtl.dispose();
    _exchangeRateCtl.dispose();
    _subscriptionStartDateCtl.dispose();
    _subscriptionEndDateCtl.dispose();
    _defaultUnitLabelCtl.dispose();
    _notesCtl.dispose();
    _termsCtl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController ctl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        ctl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _addItem(bool globallyShowPeriod) async {
     final result = await showModalBottomSheet<PfiItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddItemDrawer(showPeriod: globallyShowPeriod && _showPeriod),
    );
    if (result != null) {
       setState(() => _items.add(result));
    }
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  double get _subTotal {
    return _items.fold(0.0, (sum, item) => sum + (item.subtotal ?? 0.0));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomerId == null) {
      _showError('Please select a customer');
      return;
    }
    if (_items.isEmpty) {
      _showError('Please add at least one item');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final remote = ref.read(salesRemoteDataSourceProvider);
      
      final Map<String, dynamic> payload = {
        if (widget.pfi?.id != null) 'id': widget.pfi!.id,
        'proposal_number': _proposalNumberCtl.text,
        'subject': _subjectCtl.text,
        'customer_id': _selectedCustomerId,
        'date': _issueDateCtl.text,
        'valid_until': _dueDateCtl.text,
        'currency_id': _selectedCurrencyId,
        'exchange_rate': _exchangeRateCtl.text,
        'discount_type': _selectedDiscountType,
        'show_discount_per_item': _showDiscountPerItem,
        'show_tax_per_item': _showTaxPerItem,
        'support_ticket_id': _selectedSupportTicketId,
        'jobcard_id': _selectedJobcardId,
        'project_id': _selectedProjectId,
        'trip_id': _selectedTripId,
        'warehouse_id': _selectedWarehouseId,
        'sales_agent_id': _selectedSalesAgentId,
        'attachment': _attachmentPath,
        'payment_terms_id': _selectedPaymentTermsId,
        'payment_method_id': _selectedPaymentMethodId,
        'notes': _notesCtl.text,
        'terms': _termsCtl.text,
        'subscription_start_date': _subscriptionStartDateCtl.text,
        'subscription_end_date': _subscriptionEndDateCtl.text,
        'subscription_duration': _subscriptionDuration,
        'recurring': _isRecurring ? 1 : 0,
        'items': _items.map((it) => {
          'item_id': it.itemId,
          'description': it.description,
          'qty': it.qty,
          'uom': it.uomId,
          'rate': it.rate,
          'tax': it.tax,
          'period': it.period,
          'period_unit': it.periodUnit,
          'subtotal': it.subtotal,
        }).toList(),
      };

      final res = await remote.savePfi(payload);
      
      if (mounted) {
        if (res['status'] == 200 || res['success'] == true || res['message']?.toString().toLowerCase().contains('success') == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.pfi != null ? 'PFI updated successfully' : 'PFI created successfully'), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true);
        } else {
          _showError(res['message']?.toString() ?? 'Failed to save PFI');
        }
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String msg) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _populateItemsFromMap(Map<String, dynamic> selectedMap) {
    if (selectedMap.isEmpty) return;

    final rawItems = selectedMap['items'] ?? selectedMap['materials'] ?? selectedMap['tasks'];
    if (rawItems is List && rawItems.isNotEmpty) {
      final newItems = rawItems.map((raw) {
        final m = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
        String? extractedName;
        if (m['product'] is Map) {
          extractedName = m['product']['name']?.toString();
        } else if (m['material'] is Map) {
          extractedName = m['material']['name']?.toString();
        } else if (m['service'] is Map) {
          extractedName = m['service']['name']?.toString();
        }
        
        final itemId = extractedName ?? (m['item_name'] ?? m['name'] ?? m['title'] ?? m['material_name'] ?? m['service_name'] ?? m['task_name'] ?? m['material'] ?? m['service'] ?? m['task'] ?? m['description'] ?? m['item_id'])?.toString();
        final description = (m['description'] ?? m['details'])?.toString();
        
        final qty = double.tryParse((m['qty'] ?? m['quantity'])?.toString() ?? '1') ?? 1.0;
        final rate = double.tryParse((m['rate'] ?? m['price'] ?? m['amount'] ?? m['sale_price'] ?? m['cost'])?.toString() ?? '0') ?? 0.0;
        
        final uomId = (m['uom'] ?? m['uom_id'] ?? m['unit'] ?? m['unit_id'] ?? m['measure_unit_id'])?.toString();
        
        final period = double.tryParse((m['period'])?.toString() ?? '1') ?? 1.0;
        final periodUnit = m['period_unit']?.toString();
        
        final tax = (m['tax'] ?? m['tax_id'] ?? m['tax_name'])?.toString();
        
        final computedSubtotal = qty * rate * (_showPeriod ? period : 1.0);
        final subtotal = double.tryParse(m['subtotal']?.toString() ?? '') ?? computedSubtotal;

        return PfiItem(
          itemId: itemId ?? 'Item',
          isCustom: true,
          description: description,
          qty: qty,
          uomId: uomId,
          rate: rate,
          tax: tax,
          period: period,
          periodUnit: periodUnit,
          subtotal: subtotal,
        );
      }).toList();

      if (newItems.isNotEmpty) {
        setState(() {
          for (var item in newItems) {
             _items.add(item);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${newItems.length} items populated.'), backgroundColor: Colors.green));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    final settingsAsync = ref.watch(pfiSettingsProvider);
    final cfg = settingsAsync.value ?? <String, dynamic>{};
    bool show(String key) {
      if (!cfg.containsKey(key)) return true;
      return cfg[key] == true;
    }

    ref.listen<AsyncValue<Map<String, dynamic>>>(pfiSettingsProvider, (prev, next) {
      if (widget.pfi == null && next.hasValue) {
        final data = next.value!;
        if (_notesCtl.text.isEmpty) {
          final notesRaw = data['pfi_client_notes']?.toString().replaceAll('&nbsp;', ' ').replaceAll('<br>', '\n') ?? '';
          _notesCtl.text = notesRaw.trim();
        }
        if (_termsCtl.text.isEmpty) {
          final termsRaw = data['pfi_terms_condition']?.toString().replaceAll('&nbsp;', ' ').replaceAll('<br>', '\n') ?? '';
          _termsCtl.text = termsRaw.trim();
        }
      }
    });

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : Colors.white,
      appBar: CustomAppBar(
        title: widget.pfi != null ? 'Edit PFI' : 'Create PFI',
      ),
      body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   // ── Section: General Details ─────────────────────
                  // _buildSectionHeader('General Details'),
                  _buildField(AppTextField(
                    controller: _proposalNumberCtl,
                    label: 'Proposal Number',
                    hintText: 'Auto-generated if empty',
                  )),
                  _buildField(AppTextField(
                    controller: _subjectCtl,
                    label: 'Subject *',
                    hintText: 'e.g. Pro Forma for Spares',
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  )),
                  _buildField(Builder(builder: (context) {
                    final customerState = ref.watch(customersNotifierProvider);
                    final customers = customerState.maybeWhen(
                      loaded: (list) => list,
                      orElse: () => <Customer>[],
                    );

                    return AppSmartDropdown<int>(
                      value: _selectedCustomerId,
                      items: customers.map((c) => c.id!).toList(),
                      itemBuilder: (id) {
                        if (customers.isEmpty) return 'Loading...';
                        final customer = customers.cast<Customer?>().firstWhere(
                              (c) => c?.id == id,
                              orElse: () => null,
                            );
                        return customer?.name ?? 'Unknown ($id)';
                      },
                      label: 'Customer *',
                      hintText: customers.isEmpty ? 'Loading customers...' : 'Select Customer',
                      enabled: customers.isNotEmpty,
                      onChanged:
                          (id) => setState(() => _selectedCustomerId = id),
                    );
                  })),
                  Row(
                    children: [
                      Expanded(child: _buildField(AppTextField(
                        controller: _issueDateCtl,
                        label: 'Issue Date',
                        readOnly: true,
                        onTap: () => _selectDate(_issueDateCtl),
                        suffixIcon: Icon(AppIcons.calendar, size: 18.r),
                      ))),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildField(AppTextField(
                        controller: _dueDateCtl,
                        label: 'Due Date',
                        readOnly: true,
                        onTap: () => _selectDate(_dueDateCtl),
                        suffixIcon: Icon(AppIcons.calendar, size: 18.r),
                      ))),
                    ],
                  ),

                  // ── Section: Pricing & Linking ──────────────────
                  // _buildSectionHeader('Pricing & Linking'),
                  Row(
                    children: [
                      Expanded(child: _buildAsyncMapDropdown<String>(
                        asyncValue: ref.watch(salesCurrenciesProvider),
                        value: _selectedCurrencyId,
                        label: 'Currency *',
                        hintText: 'Select',
                        onChanged: (v) async {
                          setState(() => _selectedCurrencyId = v);
                          if (v != null) {
                            final id = int.tryParse(v);
                            if (id != null) {
                              final rate = await ref.read(salesRemoteDataSourceProvider).getExchangeRate(id);
                              if (rate != null) {
                                setState(() => _exchangeRateCtl.text = rate.toString());
                              }
                            }
                          }
                        },
                        labelBuilder: (m) {
                          final code = m['code']?.toString() ?? m['currency_code']?.toString();
                          final name = m['name']?.toString() ?? m['currency_name']?.toString();
                          final symbol = m['symbol']?.toString() ?? m['currency_symbol']?.toString();
                          if (code != null && name != null) return '$code - $name';
                          return code ?? name ?? symbol ?? 'Currency ${m['id'] ?? ''}';
                        },
                      )),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildField(AppTextField(
                        controller: _exchangeRateCtl,
                        label: 'Exchange Rate',
                        keyboardType: TextInputType.number,
                      ))),
                    ],
                  ),
                  _buildField(AppSmartDropdown<String>(
                    value: _selectedDiscountType,
                    items: const ['Before Tax', 'After Tax'],
                    itemBuilder: (v) => v,
                    label: 'Discount Type',
                    hintText: 'Select',
                    onChanged: (v) => setState(() => _selectedDiscountType = v),
                  )),
                  
                  Row(
                    children: [
                      Expanded(child: _buildRadioGroup('Show Discount Per Items', ['Yes', 'No', 'Disable'], _showDiscountPerItem, (v) => setState(() => _showDiscountPerItem = v))),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildRadioGroup('Show Tax Per Items', ['Yes', 'No'], _showTaxPerItem, (v) => setState(() => _showTaxPerItem = v))),
                    ],
                  ),

                  _buildAsyncMapDropdown<String>(
                    asyncValue: ref.watch(salesSupportTicketsProvider),
                    value: _selectedSupportTicketId,
                    label: 'Support Ticket',
                    hintText: 'Select Ticket',
                    onChanged: (v) => setState(() => _selectedSupportTicketId = v),
                    labelBuilder: (m) => '${m['ticket_code'] ?? ''} - ${m['subject'] ?? ''}',
                    itemWidgetBuilder: (m) => RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87),
                        children: [
                          TextSpan(text: '${m['ticket_code'] ?? ''} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: m['subject']?.toString() ?? ''),
                        ],
                      ),
                    ),
                  ),
                  _buildAsyncMapDropdown<String>(
                    asyncValue: ref.watch(salesJobcardsProvider),
                    value: _selectedJobcardId,
                    label: 'Job Card',
                    hintText: 'Select Jobcard',
                    onChanged: (v) => setState(() => _selectedJobcardId = v),
                    onMapChanged: _populateItemsFromMap,
                    labelBuilder: (m) => '${m['jobcard_number'] ?? m['job_number'] ?? ''} - ${m['subject'] ?? m['service'] ?? m['name'] ?? ''}',
                    itemWidgetBuilder: (m) => RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87),
                        children: [
                          TextSpan(text: '${m['jobcard_number'] ?? m['job_number'] ?? ''} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: m['subject']?.toString() ?? m['service']?.toString() ?? m['name']?.toString() ?? ''),
                        ],
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      if (show('pfi_show_project_agent')) ...[
                        Expanded(child: _buildAsyncMapDropdown<String>(
                          asyncValue: ref.watch(salesProjectsProvider),
                          value: _selectedProjectId,
                          label: 'Project',
                          hintText: 'Select Project',
                          onChanged: (v) => setState(() => _selectedProjectId = v),
                          onMapChanged: _populateItemsFromMap,
                          labelBuilder: (m) {
                            return m['name']?.toString() ??
                                m['title']?.toString() ??
                                m['project_name']?.toString() ??
                                m['subject']?.toString() ??
                                'Project ${m['id'] ?? ''}';
                          },
                        )),
                        SizedBox(width: 12.w),
                      ],
                      Expanded(child: _buildAsyncMapDropdown<String>(
                        asyncValue: ref.watch(salesTripsProvider),
                        value: _selectedTripId,
                        label: 'Trip',
                        hintText: 'Select Trip',
                        onChanged: (v) => setState(() => _selectedTripId = v),
                        onMapChanged: _populateItemsFromMap,
                        labelBuilder: (m) {
                          final num = m['trip_number'] ?? m['trip_no'] ?? m['number'] ?? m['code'];
                          final dest = m['name'] ?? m['title'] ?? m['route'] ?? m['destination'] ?? m['desc'];
                          if (num != null && dest != null) return '$num - $dest';
                          if (num != null) return num.toString();
                          return dest?.toString() ?? 'Trip ${m['id'] ?? ''}';
                        },
                      )),
                    ],
                  ),

                  // ── Section: Logistics & Assignment ──────────────
                  // _buildSectionHeader('Logistics & Assignment'),
                  Row(
                    children: [
                      Expanded(child: _buildAsyncMapDropdown<String>(
                        asyncValue: ref.watch(salesWarehousesProvider),
                        value: _selectedWarehouseId,
                        label: 'Warehouse',
                        hintText: 'Select',
                        onChanged: (v) => setState(() => _selectedWarehouseId = v),
                      )),
                      if (show('pfi_show_sale_agent')) ...[
                        SizedBox(width: 12.w),
                        Expanded(child: _buildAsyncMapDropdown<String>(
                          asyncValue: ref.watch(salesUsersProvider),
                          value: _selectedSalesAgentId,
                          label: 'Sales Agent',
                          hintText: 'Select',
                          onChanged: (v) => setState(() => _selectedSalesAgentId = v),
                          labelBuilder: (m) {
                            if (m['name'] != null) return m['name'].toString();
                            final first = m['first_name']?.toString() ?? '';
                            final last = m['last_name']?.toString() ?? '';
                            final full = '$first $last'.trim();
                            if (full.isNotEmpty) return full;
                            return m['email']?.toString() ?? m['username']?.toString() ?? 'User ${m['id'] ?? ''}';
                          },
                        )),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      if (show('pfi_allow_attachment')) ...[
                        Expanded(child: _buildField(AppTextField(
                           label: 'Attachment',
                           hintText: _attachmentName ?? 'No file chosen',
                           readOnly: true,
                           suffixIcon: Icon(Icons.attach_file_rounded, size: 18.r),
                           onTap: () async {
                             try {
                               final result = await FilePicker.platform.pickFiles();
                               if (result != null && result.files.single.path != null) {
                                 setState(() {
                                   _attachmentPath = result.files.single.path;
                                   _attachmentName = result.files.single.name;
                                 });
                               }
                             } catch (_) {}
                           },
                        ))),
                        if (show('pfi_enable_payment')) SizedBox(width: 12.w),
                      ],
                      if (show('pfi_enable_payment'))
                        Expanded(child: _buildAsyncMapDropdown<String>(
                          asyncValue: ref.watch(salesPaymentTermsProvider), 
                          value: _selectedPaymentTermsId,
                          label: 'Payment Terms',
                          hintText: 'Select Terms',
                          onChanged: (v) => setState(() => _selectedPaymentTermsId = v),
                        )),
                    ],
                  ),
                  if (show('pfi_enable_payment'))
                    _buildAsyncMapDropdown<String>(
                      asyncValue: ref.watch(salesPaymentMethodProvider),
                      value: _selectedPaymentMethodId,
                      label: 'Payment Method',
                      hintText: 'Select Method',
                      onChanged: (v) => setState(() => _selectedPaymentMethodId = v),
                    ),

                  // ── Section: Subscription ───────────────────────
                  if (show('pfi_subscription')) ...[
                    // _buildSectionHeader('Subscription'),
                    Row(
                      children: [
                        Expanded(child: _buildField(AppTextField(
                          controller: _subscriptionStartDateCtl,
                          label: 'Start Date',
                          readOnly: true,
                          onTap: () => _selectDate(_subscriptionStartDateCtl),
                          suffixIcon: Icon(AppIcons.calendar, size: 18.r),
                        ))),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildField(AppSmartDropdown<String>(
                            value: _subscriptionDuration,
                            items: const [
                              'daily',
                              'weekly',
                              'monthly',
                              'quater',
                              'semi-annually',
                              'Year',
                            ],
                            itemBuilder: (v) => v[0].toUpperCase() + v.substring(1),
                            label: 'Duration',
                            hintText: 'Select Duration',
                            onChanged: (v) => setState(() => _subscriptionDuration = v),
                          )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildField(AppTextField(
                          controller: _subscriptionEndDateCtl,
                          label: 'End Date',
                          readOnly: true,
                          onTap: () => _selectDate(_subscriptionEndDateCtl),
                          suffixIcon: Icon(AppIcons.calendar, size: 18.r),
                        ))),
                        SizedBox(width: 12.w),
                        if (show('pfi_subscription_recurring'))
                          Expanded(child: _buildRadioGroup('Recurring', ['Yes', 'No'], _isRecurring ? 'Yes' : 'No', (v) => setState(() => _isRecurring = v == 'Yes')))
                        else
                          const Spacer(),
                      ],
                    ),
                  ],

                  // ── Section: Items ──────────────────────────────
                  // _buildSectionHeader('Items'),
                  
                  // Setup UI (matching Reference 2)
                  Column(
                    children: [
                       Row(
                        children: [
                          Expanded(child: _buildField(AppTextField(controller: _defaultUnitLabelCtl, label: 'Default Unit Label'))),
                          if (show('pfi_show_period')) ...[
                            SizedBox(width: 12.w),
                            Expanded(child: _buildRadioGroup('Show Period', ['Yes', 'No'], _showPeriod ? 'Yes' : 'No', (v) => setState(() => _showPeriod = v == 'Yes'))),
                          ] else
                            const Spacer(),
                        ],
                      ),
                    ],
                  ),

                  // if (_items.isEmpty)
                  //   Container(
                  //     padding: EdgeInsets.all(24.r),
                  //     margin: EdgeInsets.only(bottom: 16.h),
                  //     decoration: BoxDecoration(
                  //       color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                  //       borderRadius: BorderRadius.circular(16.r),
                  //       border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  //     ),
                  //     child: Center(child: Text('No items added yet', style: TextStyle(color: Colors.grey, fontSize: 13.sp))),
                  //   )
                  // else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (ctx, i) => _buildItemCard(i, isDark),
                    ),

                  InkWell(
                    onTap: () => _addItem(show('pfi_show_period')),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: primaryColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded, size: 20.r, color: primaryColor),
                          SizedBox(width: 8.w),
                          Text(
                            _items.isEmpty ? 'Add Item' : 'Add another item',
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),
                  // _buildSummaryRow('Sub Total', _subTotal),
                  // _buildSummaryRow('Total Amount', _subTotal, isBold: true),

                  // ── Section: Footer ─────────────────────────────
                  if (show('pfi_allow_footer')) ...[
                    // _buildSectionHeader('Notes & Terms'),
                    _buildField(AppTextField(controller: _notesCtl, label: 'Notes', maxLines: 3)),
                    _buildField(AppTextField(controller: _termsCtl, label: 'Terms & Conditions', maxLines: 3)),
                  ],

                  SizedBox(height: 32.h),
                  AppButton(
                    text: widget.pfi != null ? 'Update Pro Forma Invoice' : 'Generate PFI',
                    onPressed: _isSubmitting ? null : _submit,
                    isLoading: _isSubmitting,
                    width: double.infinity,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildField(Widget child) {
    return Padding(padding: EdgeInsets.only(bottom: 16.h), child: child);
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2634)))),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildRadioGroup(String label, List<String> options, String? groupValue, Function(String) onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11.sp, color: isDark ? Colors.white60 : Colors.grey.shade600)),
        SizedBox(height: 4.h),
        Wrap(
          spacing: 8.w,
          children: options.map((opt) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(value: opt, groupValue: groupValue, onChanged: (v) => onChanged(v!), visualDensity: VisualDensity.compact, activeColor: AppColors.primary),
              GestureDetector(onTap: () => onChanged(opt), child: Text(opt, style: TextStyle(fontSize: 12.sp))),
            ],
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
     final isDark = Theme.of(context).brightness == Brightness.dark;
     return Padding(
       padding: EdgeInsets.symmetric(vertical: 4.h),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
           Text('${amount.toStringAsFixed(2)} TSh', style: TextStyle(fontSize: 14.sp, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: isBold ? AppColors.primary : (isDark ? Colors.white : Colors.black87))),
         ],
       ),
     );
  }

  Widget _buildItemCard(int index, bool isDark) {
    final item = _items[index];
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E243D) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(item.itemId ?? 'Custom Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp))),
              IconButton(onPressed: () => _removeItem(index), icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 20.r)),
            ],
          ),
          if (item.description?.isNotEmpty == true)
            Padding(padding: EdgeInsets.only(top: 4.h), child: Text(item.description!, style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500))),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildItemTag(isDark, '${item.qty} ${item.uomId ?? ''}'.trim()),
              if (item.period != null) Padding(padding: EdgeInsets.only(left: 8.w), child: _buildItemTag(isDark, '${item.period} ${item.periodUnit ?? ''}'.trim())),
              if (item.rate != null && item.rate! > 0)
                Padding(padding: EdgeInsets.only(left: 8.w), child: _buildItemTag(isDark, '@ ${(item.rate ?? 0).toStringAsFixed(2)}')),
              const Spacer(),
              Text('${(item.subtotal ?? 0.0).toStringAsFixed(2)} TSh', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemTag(bool isDark, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: isDark ? Colors.white12 : Colors.grey.shade100, borderRadius: BorderRadius.circular(6.r)),
      child: Text(text, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black54)),
    );
  }

  Widget _buildAsyncMapDropdown<T>({
    required AsyncValue<List<Map<String, dynamic>>> asyncValue,
    required T? value,
    required String label,
    required String hintText,
    required void Function(T?) onChanged,
    void Function(Map<String, dynamic>)? onMapChanged,
    String displayKey = 'name',
    Widget Function(Map<String, dynamic>)? itemWidgetBuilder,
    String Function(Map<String, dynamic>)? labelBuilder,
  }) {
    return asyncValue.when(
      loading: () => _buildField(AppTextField(label: label, hintText: 'Loading...', readOnly: true)),
      error: (e, _) => _buildField(AppTextField(label: label, hintText: 'Error loading', readOnly: true)),
      data: (list) {
        String? getId(Map m) => (m['id'] ??
            m['uuid'] ??
            m['currency_id'] ??
            m['ticket_id'] ??
            m['job_id'] ??
            m['project_id'] ??
            m['trip_id'] ??
            m['warehouse_id'] ??
            m['user_id'] ??
            m['agent_id'] ??
            m['sales_agent_id'] ??
            m['payment_term_id'] ??
            m['payment_method_id'] ??
            m['tax_id'] ??
            m['unit_id'] ??
            m['measure_unit_id'] ??
            m['priority_id'] ??
            m['payment_type_id'] ??
            m['duration_id'] ??
            m['form_number'] ??
            m['job_number'] ??
            m['jobcard_number'] ??
            m['ticket_code'] ??
            m['support_number'] ??
            m['trip_number'])
            ?.toString();

        final items = list
            .map((m) => getId(m))
            .where((s) => s != null)
            .cast<String>()
            .toList();
        final selectedVal = items.contains(value?.toString()) ? value?.toString() : null;
        return _buildField(AppSmartDropdown<String>(
          value: selectedVal,
          items: items,
          itemBuilder: (id) {
            final m = list.firstWhere((e) => getId(e) == id, orElse: () => <String, dynamic>{});
            if (labelBuilder != null) return labelBuilder(m);
            // user full name fallback
            if (m['first_name'] != null || m['last_name'] != null) {
              final full = '${m['first_name'] ?? ''} ${m['last_name'] ?? ''}'.trim();
              if (full.isNotEmpty) return full;
            }
            return m[displayKey] ??
                m['name'] ??
                m['title'] ??
                m['label'] ??
                m['priority'] ??
                m['unit'] ??
                m['short_name'] ??
                m['subject'] ??
                m['code'] ??
                m['type'] ??
                m['value'] ??
                m['discount_type'] ??
                m['currency_name'] ??
                m['currency_code'] ??
                m['symbol'] ??
                m['email'] ??
                m['username'] ??
                'ID: $id';
          },
          itemWidgetBuilder: itemWidgetBuilder == null
              ? null
              : (id) {
                  final m = list.firstWhere((e) => getId(e) == id, orElse: () => <String, dynamic>{});
                  return itemWidgetBuilder(m);
                },
          label: label, 
          hintText: hintText, 
          onChanged: (v) {
            if (onMapChanged != null) {
              final m = v != null ? list.firstWhere((e) => getId(e) == v, orElse: () => <String, dynamic>{}) : <String, dynamic>{};
              onMapChanged(m);
            }
            if (v == null) return onChanged(null);
            if (T == int) return onChanged(int.tryParse(v) as T);
            onChanged(v as T);
          },
        ));
      },
    );
  }
}

class _AddItemDrawer extends ConsumerStatefulWidget {
  final bool showPeriod;
  const _AddItemDrawer({required this.showPeriod});

  @override
  ConsumerState<_AddItemDrawer> createState() => _AddItemDrawerState();
}

class _AddItemDrawerState extends ConsumerState<_AddItemDrawer> {
  ProductSummary? _selectedProduct;
  String? _selectedUomId;
  String? _selectedPeriodUnit = 'Month';
  String? _selectedTax;
  final _qtyCtl = TextEditingController(text: '1');
  final _periodCtl = TextEditingController(text: '1');
  final _rateCtl = TextEditingController();
  final _descCtl = TextEditingController();
  final _customNameCtl = TextEditingController();

  void _submit() {
    final qty = double.tryParse(_qtyCtl.text) ?? 0;
    final rate = double.tryParse(_rateCtl.text) ?? 0;
    final period = double.tryParse(_periodCtl.text) ?? 1.0;
    
    Navigator.pop(context, PfiItem(
      itemId: _selectedProduct?.name ?? _customNameCtl.text,
      isCustom: _selectedProduct == null,
      description: _descCtl.text,
      qty: qty,
      uomId: _selectedUomId,
      period: period,
      periodUnit: _selectedPeriodUnit,
      rate: rate,
      tax: _selectedTax,
      subtotal: qty * rate * (widget.showPeriod ? period : 1.0),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsAsync = ref.watch(salesProductsProvider);
    final unitsAsync = ref.watch(salesPackageUnitsProvider);
    final taxesAsync = ref.watch(salesTaxesProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.85, 
      minChildSize: 0.5, 
      maxChildSize: 0.95, 
      expand: false, 
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(color: isDark ? const Color(0xFF151A2E) : Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
        child: Column(children: [
          Center(child: Container(margin: EdgeInsets.only(top: 12.h, bottom: 8.h), width: 40.w, height: 4.h, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.grey.shade300, borderRadius: BorderRadius.circular(2.r)))),
          Expanded(child: SingleChildScrollView(controller: scrollController, padding: EdgeInsets.all(24.r), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Container(padding: EdgeInsets.all(8.r), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)), child: Icon(Icons.inventory_2_rounded, color: AppColors.primary, size: 20.r)),
              SizedBox(width: 12.w),
              Text('Add Material', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(icon: Icon(Icons.close_rounded, color: isDark ? Colors.white54 : Colors.grey.shade600), onPressed: () => Navigator.pop(context)),
            ]),
            SizedBox(height: 24.h),
            productsAsync.when(
              data: (list) => AppSmartDropdown<ProductSummary>(
                value: _selectedProduct,
                label: 'Material',
                hintText: 'Select material',
                items: list,
                itemBuilder: (p) => p.name ?? 'Unknown',
                onChanged: (p) {
                   setState(() {
                     _selectedProduct = p;
                     if (p != null) {
                       _rateCtl.text = p.salePrice ?? '';
                       _selectedUomId = p.unitName;
                     }
                   });
                },
              ),
              loading: () => AppTextField(label: 'Material', hintText: 'Loading...', readOnly: true),
              error: (_, __) => AppTextField(label: 'Material', hintText: 'Error', readOnly: true),
            ),
            SizedBox(height: 12.h),
            if (_selectedProduct == null) ...[
              AppTextField(controller: _customNameCtl, label: 'Custom Material Name', hintText: 'Enter name manually'),
              SizedBox(height: 12.h),
            ],
            AppTextField(controller: _descCtl, label: 'Description', maxLines: 2, hintText: 'Enter details...'),
            SizedBox(height: 12.h),
            Row(children: [
              Expanded(child: AppTextField(controller: _qtyCtl, label: 'Qty', keyboardType: TextInputType.number)),
              SizedBox(width: 8.w),
              Expanded(child: unitsAsync.when(
                data: (list) => AppSmartDropdown<String>(label: 'Unit', items: list.map((e) => e.name ?? '').toList(), itemBuilder: (s) => s, value: _selectedUomId, onChanged: (v) => setState(() => _selectedUomId = v)),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              )),
            ]),
            SizedBox(height: 12.h),
            if (widget.showPeriod) ...[
              Row(children: [
                Expanded(child: AppTextField(controller: _periodCtl, label: 'Period', keyboardType: TextInputType.number)),
                SizedBox(width: 8.w),
                Expanded(child: AppSmartDropdown<String>(label: 'Period Unit', items: const ['Day', 'Week', 'Month', 'Year'], itemBuilder: (s) => s, onChanged: (v) => setState(() => _selectedPeriodUnit = v), value: _selectedPeriodUnit)),
              ]),
              SizedBox(height: 12.h),
            ],
            Row(children: [
              Expanded(child: AppTextField(controller: _rateCtl, label: 'Rate (TSh)*', keyboardType: TextInputType.number)),
              SizedBox(width: 8.w),
              Expanded(child: taxesAsync.when(
                data: (list) => AppSmartDropdown<String>(label: 'Tax', items: list.map((e) => e['name']?.toString() ?? '').toList(), itemBuilder: (s) => s, value: _selectedTax, onChanged: (v) => setState(() => _selectedTax = v)),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              )),
            ]),
            SizedBox(height: 32.h),
            AppButton(text: 'Add to PFI', onPressed: _submit, width: double.infinity),
            SizedBox(height: 24.h),
          ])))
        ]),
      )
    );
  }
}
