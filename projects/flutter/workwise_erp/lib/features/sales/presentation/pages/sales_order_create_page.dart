import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_icons.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_textfields.dart';
import '../../../../core/widgets/app_smart_dropdown.dart';
import '../../../jobcard/presentation/widgets/searchable_dialog.dart';

import '../../domain/entities/sales_order.dart';
import '../../domain/entities/product_summary.dart';
import '../../domain/entities/package_unit.dart';
import '../../../customer/domain/entities/customer.dart';

import '../../../customer/presentation/providers/customer_providers.dart';
import '../providers/sales_providers.dart';

class SalesOrderCreatePage extends ConsumerStatefulWidget {
  final SalesOrder? order;
  const SalesOrderCreatePage({super.key, this.order});

  @override
  ConsumerState<SalesOrderCreatePage> createState() => _SalesOrderCreatePageState();
}

class _SalesOrderCreatePageState extends ConsumerState<SalesOrderCreatePage> {
  final _formKey = GlobalKey<FormState>();

  // Detail section
  final _titleCtl = TextEditingController();
  final _exchangeRateCtl = TextEditingController();
  final _cargoValueCtl = TextEditingController();
  final _startDateCtl = TextEditingController();
  final _endDateCtl = TextEditingController();
  int? _selectedCustomerId;
  String? _selectedCurrency;
  int? _selectedVehicleId;
  String? _selectedCargoUnit;
  String? _selectedPriority;
  String? _priorityFileName;
  String? _priorityFilePath;
  String? _lpoFileName;
  String? _lpoFilePath;
  String? _popFileName;
  String? _popFilePath;
  int? _selectedWarehouseId;

  // Other Details
  int? _selectedStatusId;
  int? _assignUserId;

  // Sender & Receiver Information
  final _orderNumberCtl = TextEditingController();
  final _amountCtl = TextEditingController();
  final _senderNameCtl = TextEditingController();
  final _senderPhoneCtl = TextEditingController();
  final _receiverNameCtl = TextEditingController();
  final _receiverPhoneCtl = TextEditingController();
  final _consignmentDetailsCtl = TextEditingController();
  String? _selectedPackageType;

  // Contract, Request, Quotation, LPO
  String? _selectedContract;
  String? _selectedRequest;
  String? _selectedQuotation;
  final _lpoNumberCtl = TextEditingController();
  String? _selectedPaymentType;

  // Items
  List<_DraftItem> _items = [];

  // Truck Details
  int? _selectedMyVehicleId;
  final _transporterNameCtl = TextEditingController();
  final _truckNumberCtl = TextEditingController();
  final _trailerNumberCtl = TextEditingController();
  final _driverNameCtl = TextEditingController();
  final _driverPhoneCtl = TextEditingController();
  final _driverLicenseCtl = TextEditingController();
  final _truckDetailsCtl = TextEditingController();
  final _checkinWeightCtl = TextEditingController();

  // Location
  final _locationCtl = TextEditingController();

  // Notifications & After Save
  bool _notifyEmail = true;
  bool _notifySms = true;
  bool _notifyAll = false;
  String _afterSaveAction = 'Nothing';

  List<Customer> _customers = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _orderNumberCtl.text = widget.order!.orderNumber ?? '';
      _selectedCustomerId = widget.order!.customerId;
      
      if (widget.order!.startDate != null) {
        final d = DateTime.tryParse(widget.order!.startDate!);
        if (d != null) {
          _startDateCtl.text = DateFormat('yyyy-MM-dd').format(d);
        }
      }
    } else {
      _startDateCtl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final res = await ref.read(getCustomersUseCaseProvider).call();
      res.fold((_) {}, (list) {
        if (mounted) setState(() => _customers = list);
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _exchangeRateCtl.dispose();
    _cargoValueCtl.dispose();
    _startDateCtl.dispose();
    _endDateCtl.dispose();
    _orderNumberCtl.dispose();
    _amountCtl.dispose();
    _senderNameCtl.dispose();
    _senderPhoneCtl.dispose();
    _receiverNameCtl.dispose();
    _receiverPhoneCtl.dispose();
    _consignmentDetailsCtl.dispose();
    _lpoNumberCtl.dispose();
    _transporterNameCtl.dispose();
    _truckNumberCtl.dispose();
    _trailerNumberCtl.dispose();
    _driverNameCtl.dispose();
    _driverPhoneCtl.dispose();
    _driverLicenseCtl.dispose();
    _truckDetailsCtl.dispose();
    _checkinWeightCtl.dispose();
    _locationCtl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
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
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickPriorityFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _priorityFileName = result.files.first.name;
        _priorityFilePath = result.files.first.path;
      });
    }
  }

  Future<void> _pickLpoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _lpoFileName = result.files.first.name;
        _lpoFilePath = result.files.first.path;
      });
    }
  }

  Future<void> _pickPopFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _popFileName = result.files.first.name;
        _popFilePath = result.files.first.path;
      });
    }
  }

  void _updateTotals() {
    double grandTotal = 0;
    for (var item in _items) {
      grandTotal += item.amount;
      if (item.tax != null && item.tax!.toLowerCase().contains('vat')) {
        final percentMatch = RegExp(r'(\d+)\s*%').firstMatch(item.tax!);
        final percent = double.tryParse(percentMatch?.group(1) ?? '0') ?? 18.0;
        grandTotal += (item.amount * percent / 100);
      }
    }
    _amountCtl.text = grandTotal.toStringAsFixed(2);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.order != null ? 'Order updated' : 'Order created'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  bool _fieldEnabled(Map<String, dynamic> cfg, List<String> keys) {
    if (cfg.isEmpty) return true;
    for (final k in keys) {
      final v = cfg[k];
      if (v == null) continue;
      if (v is bool) return v;
      if (v is int) return v != 0;
      final s = v.toString().trim().toLowerCase();
      if ({'1', 'true', 'yes', 'on', 'enabled'}.contains(s)) return true;
      if ({'0', 'false', 'no', 'off', 'disabled'}.contains(s)) return false;
    }
    return true; 
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsAsync = ref.watch(salesSettingsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : Colors.white,
      appBar: CustomAppBar(
        title: widget.order != null ? 'Edit Order' : 'New Order',
        actions: const [],
      ),
      body: _buildForm(isDark, settingsAsync.value ?? {}),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.primary(
                      text: widget.order != null ? 'Save Order' : 'Save',
                      onPressed: _isSubmitting ? null : _submit,
                      isLoading: _isSubmitting,
                      isSticky: true,
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

  Widget _buildAsyncMapDropdown<T>({
    required AsyncValue<List<Map<String, dynamic>>> asyncValue,
    required T? value,
    required String label,
    required String hintText,
    required void Function(T?) onChanged,
    String displayKey = 'name',
    Widget Function(Map<String, dynamic>)? itemWidgetBuilder,
  }) {
    return asyncValue.when(
      loading: () => _buildField(AppTextField(label: label, hintText: 'Loading...', readOnly: true)),
      error: (e, _) => _buildField(AppTextField(label: label, hintText: 'Error loading', readOnly: true)),
      data: (list) {
        String? getId(Map m) => (m['id'] ?? m['uuid'] ?? m['quotation_id'] ?? m['request_id'] ?? m['contract_id'] ?? m['currency_id'] ?? m['pfi_id'] ?? m['form_number'])?.toString();
        
        final items = list.map((m) => getId(m)).where((s) => s != null).cast<String>().toList();
        final selectedVal = items.contains(value?.toString()) ? value?.toString() : null;

        return _buildField(AppSmartDropdown<String>(
          value: selectedVal,
          items: items,
          itemBuilder: (id) {
            final m = list.firstWhere((e) => getId(e) == id, orElse: () => {});
            final val = m[displayKey] ?? m['name'] ?? m['title'] ?? m['desc'] ?? m['customer_name'] ?? m['subject'] ?? m['currency_name'] ?? m['currency_symbol'] ?? m['currency_code'] ?? m['code'];
            
            final number = m['number'] ?? m['form_number'] ?? m['quotation_number'] ?? m['pfi_number'] ?? m['request_number'] ?? m['contract_number'];
            if (number != null && val != null) return '$number - $val';
            if (number != null) return number.toString();
            
            return val?.toString() ?? 'ID: $id';
          },
          itemWidgetBuilder: itemWidgetBuilder == null ? null : (id) {
            final m = list.firstWhere((e) => getId(e) == id, orElse: () => {});
            return itemWidgetBuilder(m);
          },
          label: label,
          hintText: hintText,
          onChanged: (v) {
            if (v == null) return onChanged(null);
            if (T == int) return onChanged(int.tryParse(v) as T);
            onChanged(v as T);
          },
        ));
      },
    );
  }

  Widget _buildForm(bool isDark, Map<String, dynamic> cfg) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Details Section
            if (_fieldEnabled(cfg, ['show_details_section', 'enable_details_section'])) ...[
              _buildSectionHeader('Details'),
              if (_fieldEnabled(cfg, ['enable_title', 'show_title'])) 
                _buildField(AppTextField(controller: _titleCtl, label: 'Title', hintText: 'Enter a order title')),
              if (_fieldEnabled(cfg, ['enable_customer_id', 'enable_customer'])) 
                _buildField(AppSmartDropdown<int>(
                  value: _selectedCustomerId,
                  items: _customers.map((c) => c.id!).toList(),
                  itemBuilder: (id) => _customers.firstWhere((c) => c.id == id).name ?? 'Unknown',
                  label: 'Customer *',
                  hintText: 'Select Customer',
                  enabled: _customers.isNotEmpty,
                  onChanged: (id) => setState(() => _selectedCustomerId = id),
                )),
              if (_fieldEnabled(cfg, ['enable_currency', 'show_currency'])) 
                _buildAsyncMapDropdown<String>(
                  asyncValue: ref.watch(salesCurrenciesProvider),
                  value: _selectedCurrency,
                  label: 'Currency *',
                  hintText: 'Select',
                  onChanged: (v) async {
                    setState(() => _selectedCurrency = v);
                    if (v != null) {
                      final id = int.tryParse(v);
                      if (id != null) {
                        final rate = await ref.read(salesRemoteDataSourceProvider).getExchangeRate(id);
                        if (rate != null) {
                          _exchangeRateCtl.text = rate.toString();
                          setState(() {});
                        }
                      }
                    }
                  },
                  displayKey: 'code',
                ),
              if (_fieldEnabled(cfg, ['enable_exchange_rate', 'show_exchange_rate'])) 
                _buildField(AppTextField(controller: _exchangeRateCtl, label: 'Exchange rate', hintText: '1.00')),
              if (_fieldEnabled(cfg, ['enable_vehicle_id', 'enable_vehicle_dropdowns', 'show_vehicle_dropdowns'])) 
                _buildAsyncMapDropdown<int>(
                  asyncValue: ref.watch(salesVehiclesProvider),
                  value: _selectedVehicleId,
                  label: 'Vehicle *',
                  hintText: 'Select Vehicle',
                  onChanged: (v) => setState(() => _selectedVehicleId = v),
                  displayKey: 'plate_number',
                ),
              if (_fieldEnabled(cfg, ['enable_cargo_value', 'show_cargo_value'])) 
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextField(controller: _cargoValueCtl, label: 'Cargo Value *', hintText: 'Enter Cargo Value'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: AppSmartDropdown<String>(
                        value: _selectedCargoUnit,
                        items: const ['kilograms(kg)', 'gramms(g)', 'litters', 'tonnes', 'pounds'],
                        itemBuilder: (s) => s,
                        label: ' ',
                        hintText: 'Unit',
                        onChanged: (v) => setState(() => _selectedCargoUnit = v),
                      ),
                    ),
                  ],
                ),
              if (_fieldEnabled(cfg, ['enable_cargo_value', 'show_cargo_value'])) const SizedBox(height: 12),
              if (_fieldEnabled(cfg, ['enable_start_date', 'show_start_date'])) 
                _buildField(AppTextField(
                  controller: _startDateCtl, label: 'Start', hintText: 'YYYY-MM-DD',
                  readOnly: true, onTap: () => _selectDate(_startDateCtl),
                )),
              if (_fieldEnabled(cfg, ['enable_end_date', 'show_end_date'])) 
                _buildField(AppTextField(
                  controller: _endDateCtl, label: 'End', hintText: 'Enter Date',
                  readOnly: true, onTap: () => _selectDate(_endDateCtl),
                )),
              if (_fieldEnabled(cfg, ['enable_priority', 'show_priority'])) ...[
                _buildField(AppSmartDropdown<String>(
                  value: _selectedPriority,
                  items: const ['Fragile (F)', 'High', 'Normal', 'Document'],
                  itemBuilder: (s) => s,
                  label: 'Priority',
                  hintText: 'Select priority',
                  onChanged: (v) => setState(() => _selectedPriority = v),
                )),
                _buildField(AppTextField(
                  label: 'Priority Document', 
                  hintText: _priorityFileName ?? 'Choose File', 
                  readOnly: true, 
                  suffixIcon: const Icon(Icons.attach_file),
                  onTap: _pickPriorityFile,
                )),
              ],
              if (_fieldEnabled(cfg, ['enable_warehouse', 'show_warehouse'])) 
                _buildAsyncMapDropdown<int>(
                  asyncValue: ref.watch(salesWarehousesProvider),
                  value: _selectedWarehouseId,
                  label: 'Warehouse *',
                  hintText: 'Select location',
                  onChanged: (v) => setState(() => _selectedWarehouseId = v),
                  displayKey: 'name',
                ),
            ],

            // Other Details
            if (_fieldEnabled(cfg, ['show_other_details', 'enable_other_details'])) ...[
              _buildSectionHeader('Other Details'),
              if (_fieldEnabled(cfg, ['enable_status_id', 'enable_status', 'show_status'])) 
                _buildAsyncMapDropdown<int>(
                  asyncValue: ref.watch(salesOrderStatusesProvider),
                  value: _selectedStatusId,
                  label: 'Status *',
                  hintText: 'Draft',
                  onChanged: (v) => setState(() => _selectedStatusId = v),
                ),
              if (_fieldEnabled(cfg, ['enable_assign_user', 'show_assign_user'])) 
                _buildAsyncMapDropdown<int>(
                  asyncValue: ref.watch(salesUsersProvider),
                  value: _assignUserId,
                  label: 'Assign User',
                  hintText: 'Select User',
                  onChanged: (v) => setState(() => _assignUserId = v),
                ),
            ],

            // Sender & Receiver Information
            if (_fieldEnabled(cfg, ['show_sender_receiver', 'enable_sender_receiver'])) ...[
              _buildSectionHeader(
                'Sender & Receiver Information',
                trailing: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Another Sender/Receiver'),
                ),
              ),
              if (_fieldEnabled(cfg, ['enable_order_number', 'show_order_number'])) 
                _buildField(AppTextField(controller: _orderNumberCtl, label: 'Order Number *', hintText: 'ORD...')),
              if (_fieldEnabled(cfg, ['enable_amount', 'show_amount'])) 
                _buildField(AppTextField(controller: _amountCtl, label: 'Amount *', hintText: 'eg 5,000')),
              if (_fieldEnabled(cfg, ['enable_package_type', 'show_package_type'])) 
                _buildAsyncMapDropdown<String>(
                  asyncValue: ref.watch(salesPackageTypesProvider),
                  value: _selectedPackageType,
                  label: 'Package Type *',
                  hintText: 'Select Package Type',
                  onChanged: (v) => setState(() => _selectedPackageType = v),
                  displayKey: 'name',
                ),
              if (_fieldEnabled(cfg, ['enable_sender_name', 'show_sender_name'])) 
                _buildField(AppTextField(controller: _senderNameCtl, label: 'Sender Name *', hintText: 'Enter Sender Name')),
              if (_fieldEnabled(cfg, ['enable_sender_phone', 'show_sender_phone'])) 
                _buildField(AppTextField(controller: _senderPhoneCtl, label: 'Sender Phone', hintText: 'Enter Sender Phone')),
              if (_fieldEnabled(cfg, ['enable_receiver_name', 'show_receiver_name'])) 
                _buildField(AppTextField(controller: _receiverNameCtl, label: 'Receiver Name *', hintText: 'Enter Receiver Name')),
              if (_fieldEnabled(cfg, ['enable_receiver_phone', 'show_receiver_phone'])) 
                _buildField(AppTextField(controller: _receiverPhoneCtl, label: 'Receiver Phone', hintText: 'Enter Receiver Phone')),
              if (_fieldEnabled(cfg, ['enable_consignment_details', 'show_consignment_details'])) 
                _buildField(AppTextField(controller: _consignmentDetailsCtl, label: 'Consignment Details', maxLines: 3)),
            ],

            // LPO and Documents
            if (_fieldEnabled(cfg, ['show_contract_section', 'enable_contract_section', 'enable_contract', 'enable_request_id', 'enable_quotation', 'enable_lpo_number', 'enable_payment_type'])) ...[
              _buildSectionHeader('Contract & Quotation'),
              if (_fieldEnabled(cfg, ['enable_contract', 'show_contract'])) 
                _buildAsyncMapDropdown<String>(
                  asyncValue: ref.watch(salesContractsProvider),
                  value: _selectedContract,
                  label: 'Contract *',
                  hintText: 'Select Contract',
                  onChanged: (v) => setState(() => _selectedContract = v),
                ),
              if (_fieldEnabled(cfg, ['enable_request_id', 'show_request_id'])) 
                _buildAsyncMapDropdown<String>(
                  asyncValue: ref.watch(salesRequestsProvider),
                  value: _selectedRequest,
                  label: 'Request',
                  hintText: 'Select Request',
                  onChanged: (v) => setState(() => _selectedRequest = v),
                ),
              if (_fieldEnabled(cfg, ['enable_quotation', 'show_quotation'])) 
                _buildAsyncMapDropdown<String>(
                  asyncValue: ref.watch(salesQuotationsProvider),
                  value: _selectedQuotation,
                  label: 'Quotations',
                  hintText: 'Select PFI',
                  onChanged: (v) => setState(() => _selectedQuotation = v),
                  itemWidgetBuilder: (q) {
                    final pfi = (q['quotation_number'] ?? q['pfi_number'] ?? '').toString();
                    final subject = (q['subject'] ?? q['name'] ?? q['title'] ?? '').toString();
                    return RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey.shade800,
                        ),
                        children: [
                          TextSpan(text: pfi, style: const TextStyle(fontWeight: FontWeight.bold)),
                          if (pfi.isNotEmpty && subject.isNotEmpty) const TextSpan(text: ' - '),
                          TextSpan(text: subject),
                        ],
                      ),
                    );
                  },
                ),
              if (_fieldEnabled(cfg, ['enable_lpo_number', 'show_lpo_number'])) 
                _buildField(AppTextField(controller: _lpoNumberCtl, label: 'LPO Number', hintText: 'Enter lpo number')),
              if (_fieldEnabled(cfg, ['enable_lpo_document', 'show_lpo_document'])) 
                _buildField(AppTextField(
                  label: 'LPO Document', 
                  hintText: _lpoFileName ?? 'Choose File', 
                  readOnly: true, 
                  suffixIcon: const Icon(Icons.attach_file),
                  onTap: _pickLpoFile,
                )),
              if (_fieldEnabled(cfg, ['enable_payment_type', 'show_payment_type'])) 
                _buildField(AppSmartDropdown<String>(
                  value: _selectedPaymentType,
                  items: const ['Cash', 'Credit'],
                  itemBuilder: (s) => s,
                  label: 'Payment Type',
                  hintText: 'Cash',
                  onChanged: (v) => setState(() => _selectedPaymentType = v),
                )),
              if (_fieldEnabled(cfg, ['enable_prof_of_payment', 'show_prof_of_payment'])) 
                _buildField(AppTextField(
                  label: 'Prof Of Payment', 
                  hintText: _popFileName ?? 'Choose File', 
                  readOnly: true, 
                  suffixIcon: const Icon(Icons.attach_file),
                  onTap: _pickPopFile,
                )),
            ],

            // Items List
            if (_fieldEnabled(cfg, ['show_items_section', 'enable_items_section', 'enable_items'])) ...[
              _buildSectionHeader('Items'),
              _buildItems(isDark, cfg),
            ],

            // Order Truck List
            if (_fieldEnabled(cfg, ['show_trucks_section', 'enable_truck_details', 'enable_trucks', 'show_truck_list'])) ...[
               _buildSectionHeader('Order Truck List'),
               if (_fieldEnabled(cfg, ['enable_truck_vehicle_id', 'show_vehicle_dropdowns'])) ...[
                _buildAsyncMapDropdown<int>(
                  asyncValue: ref.watch(salesVehiclesProvider),
                  value: _selectedMyVehicleId,
                  label: 'My Vehicles',
                  hintText: 'Select Vehicle',
                  onChanged: (v) => setState(() => _selectedMyVehicleId = v),
                  displayKey: 'plate_number',
                ),
               ],
               if (_fieldEnabled(cfg, ['enable_vehicle_name', 'show_vehicle_name'])) 
                 _buildField(AppTextField(controller: _transporterNameCtl, label: 'Transpoter Name')),
               if (_fieldEnabled(cfg, ['enable_vehicle_plate_number', 'show_vehicle_plate_number'])) 
                 _buildField(AppTextField(controller: _truckNumberCtl, label: 'Truck Number')),
               if (_fieldEnabled(cfg, ['enable_vehicle_trailer_number', 'show_vehicle_trailer_number'])) 
                 _buildField(AppTextField(controller: _trailerNumberCtl, label: 'Trailer Number')),
               if (_fieldEnabled(cfg, ['enable_driver_name', 'show_driver_name'])) 
                 _buildField(AppTextField(controller: _driverNameCtl, label: 'Driver Name')),
               if (_fieldEnabled(cfg, ['enable_driver_phone', 'show_driver_phone'])) 
                 _buildField(AppTextField(controller: _driverPhoneCtl, label: 'Driver Phone')),
               if (_fieldEnabled(cfg, ['enable_driver_license_number', 'show_driver_license_number'])) 
                 _buildField(AppTextField(controller: _driverLicenseCtl, label: 'Driver License')),
               if (_fieldEnabled(cfg, ['enable_truck_details', 'show_truck_details'])) 
                 _buildField(AppTextField(controller: _truckDetailsCtl, label: 'Truck Details', maxLines: 2)),
               if (_fieldEnabled(cfg, ['enable_checkin_weight', 'show_checkin_weight'])) 
                 _buildField(AppTextField(controller: _checkinWeightCtl, label: 'Check-in Weight', suffixIcon: TextButton(onPressed: () {}, child: const Text('Fetch from Weighbridge')))),
            ],

            // Location
            if (_fieldEnabled(cfg, ['enable_location', 'show_location'])) ...[
              _buildSectionHeader('Location'),
              _buildField(AppTextField(
                controller: _locationCtl,
                label: '',
                hintText: 'Enter location (optional)',
                prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
              )),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Specify the order location', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const SizedBox(height: 12),
            ],

            // Notifications
            _buildSectionHeader('Notifications', trailing: const Icon(Icons.notifications_active_outlined, size: 18, color: Colors.grey)),
            Row(
              children: [
                Checkbox(value: _notifyEmail, onChanged: (v) => setState(() => _notifyEmail = v ?? false)),
                const Text('Email'),
                const SizedBox(width: 8),
                Checkbox(value: _notifySms, onChanged: (v) => setState(() => _notifySms = v ?? false)),
                const Text('SMS'),
                const SizedBox(width: 8),
                Checkbox(value: _notifyAll, onChanged: (v) => setState(() => _notifyAll = v ?? false)),
                const Text('All'),
              ],
            ),

            // After Save Order
            _buildSectionHeader('After Save Order', trailing: const Icon(Icons.article_outlined, size: 18, color: Colors.grey)),
            Wrap(
              spacing: 16,
              children: ['Create Trip', 'Create Task', 'Create Receipt', 'Nothing'].map((val) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: val,
                      groupValue: _afterSaveAction,
                      onChanged: (v) => setState(() => _afterSaveAction = v ?? 'Nothing'),
                      activeColor: Colors.blueAccent,
                    ),
                    Text(val),
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildField(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: child,
    );
  }

  Widget _buildItems(bool isDark, Map<String, dynamic> cfg) {
    final primaryColor = AppColors.primary;

    // Calculate totals
    double subTotal = 0;
    double totalVat = 0;
    for (var item in _items) {
      subTotal += item.amount;
      if (item.tax != null && item.tax!.toLowerCase().contains('vat')) {
        final percentMatch = RegExp(r'(\d+)\s*%').firstMatch(item.tax!);
        final percent = double.tryParse(percentMatch?.group(1) ?? '0') ?? 18.0; // Default to 18 if 'VAT' present but no %
        totalVat += (item.amount * percent / 100);
      }
    }
    double grandTotal = subTotal + totalVat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                "No Item Added",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          )
        else ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final item = _items[i];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0x1AFFFFFF) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                  ),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isDark ? Colors.white : const Color(0xFF1A2634),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildItemTag(isDark, 'Qty: ${item.qty}'),
                              if (item.packSize != null) _buildItemTag(isDark, 'Pack: ${item.packSize}'),
                              _buildItemTag(isDark, 'Price: ${NumberFormat.decimalPattern().format(item.price)}'),
                              if (item.tax != null) _buildItemTag(isDark, 'Tax: ${item.tax}'),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Total: ${NumberFormat.decimalPattern().format(item.amount)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => _items.removeAt(i));
                        _updateTotals();
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: Colors.red.shade400,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          // Totals Summary (Matching Jobcard feel but adjusted for Sales)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Sub Total', subTotal, isDark),
                const SizedBox(height: 8),
                _buildSummaryRow('VAT', totalVat, isDark),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1),
                ),
                _buildSummaryRow('Grand Total', grandTotal, isDark, isTotal: true),
              ],
            ),
          ),
        ],
        
        const SizedBox(height: 16),
        
        InkWell(
          onTap: () async {
            final result = await showModalBottomSheet<_DraftItem>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => _AddItemDrawer(cfg: cfg),
            );
            if (result != null) {
              if (mounted) {
                setState(() => _items.add(result));
                _updateTotals();
              }
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline_rounded, size: 20, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  _items.isEmpty ? 'Add Item' : 'Add another item',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double value, bool isDark, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white60 : Colors.grey.shade600),
          ),
        ),
        Text(
          NumberFormat.decimalPattern().format(value),
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildItemTag(bool isDark, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? Colors.white12 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white70 : Colors.grey.shade700,
        ),
      ),
    );
  }
}

class _DraftItem {
  final int itemId;
  final String name;
  final double available;
  final double qty;
  final String? packSize;
  final double price;
  final double discount;
  final String? tax;

  _DraftItem({
    required this.itemId,
    required this.name,
    required this.available,
    required this.qty,
    this.packSize,
    required this.price,
    this.discount = 0.0,
    this.tax,
  });

  double get amount => (qty * price) - discount;
}

class _AddItemDrawer extends ConsumerStatefulWidget {
  final Map<String, dynamic> cfg;
  const _AddItemDrawer({required this.cfg});

  @override
  ConsumerState<_AddItemDrawer> createState() => _AddItemDrawerState();
}

class _AddItemDrawerState extends ConsumerState<_AddItemDrawer> {
  final _itemNameCtl = TextEditingController(); // For custom entry
  final _qtyCtl = TextEditingController(text: '1');
  final _packSizeInputCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  final _discountCtl = TextEditingController(text: '0');
  
  ProductSummary? _selectedProduct;
  String? _selectedUnit;
  String? _selectedPackSize;
  double _availableStock = 0; 
  String? _selectedTax;

  @override
  void dispose() {
    _itemNameCtl.dispose();
    _qtyCtl.dispose();
    _packSizeInputCtl.dispose();
    _priceCtl.dispose();
    _discountCtl.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _selectedProduct?.name ?? _itemNameCtl.text;
    if (name.trim().isEmpty) return;
    final qty = double.tryParse(_qtyCtl.text) ?? 1;
    final price = double.tryParse(_priceCtl.text) ?? 0;
    final discount = double.tryParse(_discountCtl.text) ?? 0;

    Navigator.pop(
      context,
      _DraftItem(
        itemId: _selectedProduct?.id ?? 0,
        name: name,
        available: _availableStock,
        qty: qty,
        packSize: _selectedPackSize ?? _packSizeInputCtl.text,
        price: price,
        discount: discount,
        tax: _selectedTax,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsAsync = ref.watch(salesProductsProvider);
    final unitsAsync = ref.watch(salesPackageUnitsProvider);
    final taxesAsync = ref.watch(salesTaxesProvider);

    final qty = double.tryParse(_qtyCtl.text) ?? 1;
    final price = double.tryParse(_priceCtl.text) ?? 0;
    final discount = double.tryParse(_discountCtl.text) ?? 0;
    final calculatedAmount = (qty * price) - discount;

    final productCandidates = productsAsync.value ?? [];
    final unitList = (unitsAsync.value ?? []).map((u) => u.name ?? 'Unit').toList()
      ..addAll(['PCS', 'LITERS', 'tonne', 'kgs', 'Bags', 'drum', 'BOX', 'Pair', 'bottles']
      .where((d) => !(unitsAsync.value ?? []).any((e) => e.name?.toLowerCase() == d.toLowerCase())));
    if (_selectedUnit != null && !unitList.contains(_selectedUnit)) {
      unitList.add(_selectedUnit!);
    }
    
    final taxList = (taxesAsync.value ?? []).map((e) =>
      e['name']?.toString() ?? e['title']?.toString() ?? e['tax_name']?.toString() ?? e['desc']?.toString() ?? e['value']?.toString() ?? ''
    ).where((s) => s.isNotEmpty).toList()
      ..addAll(['No Tax', 'VAT 18%']
      .where((d) => !(taxesAsync.value ?? []).any((e) => (e['name']??'').toString().toLowerCase() == d.toLowerCase())));
    if (_selectedTax != null && !taxList.contains(_selectedTax)) {
      taxList.add(_selectedTax!);
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.inventory_2_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Add Material',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: isDark ? Colors.white54 : Colors.grey.shade600),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Material selection using AppSmartDropdown (matching other form fields)
                    AppSmartDropdown<ProductSummary>(
                      value: _selectedProduct,
                      items: productCandidates,
                      itemBuilder: (p) => p.name ?? 'Unknown',
                      label: 'Material',
                      hintText: productsAsync.isLoading ? 'Loading materials...' : 'Select material',
                      onChanged: (p) {
                        if (p != null) {
                          setState(() {
                            _selectedProduct = p;
                            _itemNameCtl.text = p.name ?? '';
                            _priceCtl.text = p.salePrice?.toString() ?? '0';
                            _availableStock = 100; // Mock available balance
                            
                            // Auto-populate unit from product
                            if (p.unitName != null && p.unitName!.isNotEmpty) {
                              final match = unitList.firstWhere(
                                (u) => u.toLowerCase() == p.unitName!.toLowerCase(),
                                orElse: () => p.unitName!,
                              );
                              _selectedUnit = match;
                            }
                            
                            // Auto-populate tax from product
                            if (p.taxName != null && p.taxName!.isNotEmpty) {
                              final match = taxList.firstWhere(
                                (t) => t.toLowerCase() == p.taxName!.toLowerCase(),
                                orElse: () => p.taxName!,
                              );
                              _selectedTax = match;
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    if (_selectedProduct == null) ...[
                      AppTextField(controller: _itemNameCtl, label: 'Custom Material Name', hintText: 'Enter name manually'),
                      const SizedBox(height: 12),
                    ],
                    
                    Row(
                      children: [
                        Expanded(child: AppTextField(
                          controller: _qtyCtl, 
                          label: 'Qty', 
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState((){}),
                        )),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppSmartDropdown<String>(
                            value: _selectedUnit,
                            items: unitList,
                            itemBuilder: (s) => s,
                            label: 'Unit',
                            hintText: 'Select unit',
                            onChanged: (v) => setState(() => _selectedUnit = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: _packSizeInputCtl, label: 'Pack Size (Input)', hintText: 'eg. 50')),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppSmartDropdown<String>(
                            value: _selectedPackSize,
                            items: unitList,
                            itemBuilder: (s) => s,
                            label: 'Pack Size (Drop)',
                            hintText: 'Select',
                            onChanged: (v) => setState(() => _selectedPackSize = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(child: AppTextField(
                          controller: _priceCtl, 
                          label: 'Price', 
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState((){}),
                        )),
                        const SizedBox(width: 8),
                        Expanded(child: AppTextField(
                          controller: _discountCtl, 
                          label: 'Discount', 
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState((){}),
                        )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    AppSmartDropdown<String>(
                      value: _selectedTax,
                      items: taxList,
                      itemBuilder: (s) => s,
                      label: 'Tax',
                      hintText: taxesAsync.isLoading ? 'Loading...' : 'Select tax',
                      onChanged: (v) => setState(() => _selectedTax = v),
                    ),
                    const SizedBox(height: 12),
                    
                    AppTextField(
                      label: 'Amount',
                      readOnly: true,
                      hintText: calculatedAmount.toStringAsFixed(2),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons (matching Jobcard)
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Add Item'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
