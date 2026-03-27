import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_textfields.dart';
import '../../../../core/widgets/app_smart_dropdown.dart';
import '../../domain/entities/sales_order.dart';
import '../../domain/entities/product_summary.dart';
import '../../../customer/domain/entities/customer.dart';

import 'package:dio/dio.dart';

import '../../../customer/presentation/providers/customer_providers.dart';
import '../providers/sales_providers.dart';
import '../../domain/entities/sales_settings.dart';

class SalesOrderCreatePage extends ConsumerStatefulWidget {
  final SalesOrder? order;
  const SalesOrderCreatePage({super.key, this.order});

  @override
  ConsumerState<SalesOrderCreatePage> createState() =>
      _SalesOrderCreatePageState();
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
      final o = widget.order!;
      _titleCtl.text = o.title ?? '';
      _orderNumberCtl.text = o.orderNumber ?? '';
      _exchangeRateCtl.text = o.exchangeRate ?? '';
      _cargoValueCtl.text = o.cargoValue ?? '';
      _amountCtl.text = o.amount?.toString() ?? '';
      _senderNameCtl.text = o.senderName ?? '';
      _senderPhoneCtl.text = o.senderPhone ?? '';
      _receiverNameCtl.text = o.receiverName ?? '';
      _receiverPhoneCtl.text = o.receiverPhone ?? '';
      _consignmentDetailsCtl.text = o.consignmentDetails ?? '';
      _lpoNumberCtl.text = o.lpoNumber ?? '';

      _selectedCustomerId = o.customerId;
      _selectedCurrency = o.currencyId;
      _selectedCargoUnit = o.cargoUnit;
      _selectedPriority = o.priority;
      _selectedWarehouseId = o.warehouseId;
      _selectedStatusId = o.statusId;
      _assignUserId = o.assignUserId;
      _selectedPackageType = o.packageType;
      _selectedContract = o.contractId;
      _selectedRequest = o.requestId;
      _selectedQuotation = o.quotationId;
      _selectedPaymentType = o.paymentType;

      if (o.startDate != null) {
        final d = DateTime.tryParse(o.startDate!);
        if (d != null) {
          _startDateCtl.text = DateFormat('yyyy-MM-dd').format(d);
        }
      }

      // Map items to _DraftItem
      if (o.items != null) {
        _items = o.items!.map((i) {
          return _DraftItem(
            itemId: i.itemId ?? 0,
            name: i.product?.name ?? 'Item',
            available: 0,
            qty: double.tryParse(i.quantity ?? '0') ?? 0,
            price: double.tryParse(i.price ?? '0') ?? 0,
            discount: double.tryParse(i.discount ?? '0') ?? 0,
            tax: i.tax,
            packSize: i.packageUnit?.name,
          );
        }).toList();
      }

      // Truck details (assuming first one for now as per form structure)
      if (o.truckList != null && o.truckList!.isNotEmpty) {
        final t = o.truckList!.first;
        _selectedMyVehicleId = t.vehicleId;
        _transporterNameCtl.text = t.vehicleName ?? '';
        _truckNumberCtl.text = t.vehiclePlateNumber ?? '';
        _trailerNumberCtl.text = t.vehicleTrailerNumber ?? '';
        _driverNameCtl.text = t.driverName ?? '';
        _driverPhoneCtl.text = t.driverPhone ?? '';
        _driverLicenseCtl.text = t.driverLicenseNumber ?? '';
        _truckDetailsCtl.text = ''; // Add helper if needed
        _checkinWeightCtl.text = t.checkinWeight?.toString() ?? '';
      }

      // Ensure totals are calculated after populating items
      _updateTotals();
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

    // Read typed settings for validation & payload building.
    final settings =
        ref.read(salesSettingsProvider).value ?? SalesSettings.defaults;

    // Manual required-field checks (dropdowns aren't covered by Form validators).
    if (settings.orderShowCustomer && _selectedCustomerId == null) {
      _showError('Please select a customer');
      return;
    }
    if (settings.orderShowAmount &&
        settings.orderAmountRequired &&
        _amountCtl.text.trim().isEmpty) {
      _showError('Amount is required');
      return;
    }
    if (settings.orderShowContract &&
        settings.orderContractRequired &&
        _selectedContract == null) {
      _showError('Contract is required');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      // Use multipart FormData only when a file is attached; otherwise JSON.
      final hasFiles =
          _priorityFilePath != null ||
          _lpoFilePath != null ||
          _popFilePath != null;

      final dynamic payload = hasFiles
          ? await _buildFormData(settings)
          : _buildJsonPayload(settings);

      await ref.read(salesRemoteDataSourceProvider).saveOrder(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.order != null
                  ? 'Order updated successfully'
                  : 'Order created successfully',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString().replaceAll('Exception: ', '').trim());
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Builds a plain JSON payload (no file attachments).
  Map<String, dynamic> _buildJsonPayload(SalesSettings s) {
    final m = <String, dynamic>{};

    if (widget.order?.id != null) m['id'] = widget.order!.id;
    if (s.orderShowCustomer && _selectedCustomerId != null) {
      m['customer_id'] = _selectedCustomerId;
    }
    if (s.orderShowTitle && _titleCtl.text.isNotEmpty) {
      m['title'] = _titleCtl.text;
    }
    if (s.orderShowCurrency) {
      if (_selectedCurrency != null) m['currency_id'] = _selectedCurrency;
      if (_exchangeRateCtl.text.isNotEmpty) {
        m['exchange_rate'] = _exchangeRateCtl.text;
      }
    }
    if (s.orderShowVehicleAllocation && _selectedVehicleId != null) {
      m['vehicle_id'] = _selectedVehicleId;
    }
    if (s.orderShowCargo) {
      m['cargo_value'] = _cargoValueCtl.text;
      m['cargo_unit'] = _selectedCargoUnit ?? '';
    }
    m['start_date'] = _startDateCtl.text;
    if (s.orderShowEndDate && _endDateCtl.text.isNotEmpty) {
      m['end_date'] = _endDateCtl.text;
    }
    if (s.orderShowPriority && _selectedPriority != null) {
      m['priority'] = _selectedPriority;
    }
    if (_selectedWarehouseId != null) m['warehouse_id'] = _selectedWarehouseId;
    if (s.orderShowStatus && _selectedStatusId != null) {
      m['status_id'] = _selectedStatusId;
    }
    if (s.orderShowUserAssignment && _assignUserId != null) {
      m['assign_user_id'] = _assignUserId;
    }
    if (_orderNumberCtl.text.isNotEmpty) {
      m['order_number'] = _orderNumberCtl.text;
    }
    if (s.orderShowAmount && _amountCtl.text.isNotEmpty) {
      m['amount'] = _amountCtl.text;
    }
    if (s.orderShowPackage && _selectedPackageType != null) {
      m['package_type'] = _selectedPackageType;
    }
    if (s.orderShowSenderReceiver) {
      m['sender_name'] = _senderNameCtl.text;
      m['sender_phone'] = _senderPhoneCtl.text;
      m['receiver_name'] = _receiverNameCtl.text;
      m['receiver_phone'] = _receiverPhoneCtl.text;
      m['consignment_details'] = _consignmentDetailsCtl.text;
    }
    if (s.orderShowContract && _selectedContract != null) {
      m['contract_id'] = _selectedContract;
    }
    if (s.orderShowRequest && _selectedRequest != null) {
      m['request_id'] = _selectedRequest;
    }
    if (s.orderShowPfi && _selectedQuotation != null) {
      m['quotation_id'] = _selectedQuotation;
    }
    if (s.orderShowLpo && _lpoNumberCtl.text.isNotEmpty) {
      m['lpo_number'] = _lpoNumberCtl.text;
    }
    if (s.orderShowPaymentType && _selectedPaymentType != null) {
      m['payment_type'] = _selectedPaymentType;
    }

    // Items
    if (s.orderShowProductService && _items.isNotEmpty) {
      m['items'] = _items
          .map(
            (item) => {
              'item_id': item.itemId,
              'qty': item.qty.toString(),
              'pack_size': item.packSize ?? '',
              'price': item.price.toString(),
              'discount': item.discount.toString(),
              'tax': item.tax ?? '',
            },
          )
          .toList();
    }

    // Truck list
    if (s.orderShowTruckList) {
      final t = <String, dynamic>{
        'vehicle_name': _transporterNameCtl.text,
        'plate_number': _truckNumberCtl.text,
        'trailer_number': _trailerNumberCtl.text,
        'driver_name': _driverNameCtl.text,
        'driver_phone': _driverPhoneCtl.text,
        'driver_license': _driverLicenseCtl.text,
        'truck_details': _truckDetailsCtl.text,
      };
      if (_selectedMyVehicleId != null) t['vehicle_id'] = _selectedMyVehicleId;
      if (s.orderEnableVehicleCheckinCheckout &&
          _checkinWeightCtl.text.isNotEmpty) {
        t['checkin_weight'] = _checkinWeightCtl.text;
      }
      m['truck_list'] = [t];
    }

    if (s.orderShowLocation && _locationCtl.text.isNotEmpty) {
      m['location'] = _locationCtl.text;
    }
    m['notify_email'] = _notifyEmail ? 1 : 0;
    m['notify_sms'] = _notifySms ? 1 : 0;
    m['notify_all'] = _notifyAll ? 1 : 0;
    m['after_save'] = _afterSaveAction;
    return m;
  }

  /// Builds a multipart [FormData] payload used when file(s) are attached.
  Future<FormData> _buildFormData(SalesSettings s) async {
    final fields = <MapEntry<String, String>>[];
    final files = <MapEntry<String, MultipartFile>>[];

    void f(String key, dynamic value) {
      if (value != null) fields.add(MapEntry(key, value.toString()));
    }

    if (widget.order?.id != null) f('id', widget.order!.id);
    if (s.orderShowCustomer && _selectedCustomerId != null) {
      f('customer_id', _selectedCustomerId);
    }
    if (s.orderShowTitle) f('title', _titleCtl.text);
    if (s.orderShowCurrency) {
      if (_selectedCurrency != null) f('currency_id', _selectedCurrency);
      if (_exchangeRateCtl.text.isNotEmpty) {
        f('exchange_rate', _exchangeRateCtl.text);
      }
    }
    if (s.orderShowVehicleAllocation && _selectedVehicleId != null) {
      f('vehicle_id', _selectedVehicleId);
    }
    if (s.orderShowCargo) {
      f('cargo_value', _cargoValueCtl.text);
      f('cargo_unit', _selectedCargoUnit ?? '');
    }
    f('start_date', _startDateCtl.text);
    if (s.orderShowEndDate && _endDateCtl.text.isNotEmpty) {
      f('end_date', _endDateCtl.text);
    }
    if (s.orderShowPriority) {
      if (_selectedPriority != null) f('priority', _selectedPriority);
      if (_priorityFilePath != null) {
        files.add(
          MapEntry(
            'priority_document',
            await MultipartFile.fromFile(
              _priorityFilePath!,
              filename: _priorityFileName,
            ),
          ),
        );
      }
    }
    if (_selectedWarehouseId != null) f('warehouse_id', _selectedWarehouseId);
    if (s.orderShowStatus && _selectedStatusId != null) {
      f('status_id', _selectedStatusId);
    }
    if (s.orderShowUserAssignment && _assignUserId != null) {
      f('assign_user_id', _assignUserId);
    }
    if (_orderNumberCtl.text.isNotEmpty)
      f('order_number', _orderNumberCtl.text);
    if (s.orderShowAmount && _amountCtl.text.isNotEmpty) {
      f('amount', _amountCtl.text);
    }
    if (s.orderShowPackage && _selectedPackageType != null) {
      f('package_type', _selectedPackageType);
    }
    if (s.orderShowSenderReceiver) {
      f('sender_name', _senderNameCtl.text);
      f('sender_phone', _senderPhoneCtl.text);
      f('receiver_name', _receiverNameCtl.text);
      f('receiver_phone', _receiverPhoneCtl.text);
      f('consignment_details', _consignmentDetailsCtl.text);
    }
    if (s.orderShowContract && _selectedContract != null) {
      f('contract_id', _selectedContract);
    }
    if (s.orderShowRequest && _selectedRequest != null) {
      f('request_id', _selectedRequest);
    }
    if (s.orderShowPfi && _selectedQuotation != null) {
      f('quotation_id', _selectedQuotation);
    }
    if (s.orderShowLpo) {
      if (_lpoNumberCtl.text.isNotEmpty) f('lpo_number', _lpoNumberCtl.text);
      if (_lpoFilePath != null) {
        files.add(
          MapEntry(
            'lpo_document',
            await MultipartFile.fromFile(_lpoFilePath!, filename: _lpoFileName),
          ),
        );
      }
    }
    if (s.orderShowPaymentType && _selectedPaymentType != null) {
      f('payment_type', _selectedPaymentType);
    }
    if (s.orderShowProf && _popFilePath != null) {
      files.add(
        MapEntry(
          'proof_of_payment',
          await MultipartFile.fromFile(_popFilePath!, filename: _popFileName),
        ),
      );
    }

    // Items (bracket notation for Laravel multipart)
    if (s.orderShowProductService) {
      for (int i = 0; i < _items.length; i++) {
        f('items[$i][item_id]', _items[i].itemId);
        f('items[$i][qty]', _items[i].qty);
        f('items[$i][pack_size]', _items[i].packSize ?? '');
        f('items[$i][price]', _items[i].price);
        f('items[$i][discount]', _items[i].discount);
        f('items[$i][tax]', _items[i].tax ?? '');
      }
    }

    // Truck list
    if (s.orderShowTruckList) {
      if (_selectedMyVehicleId != null) {
        f('truck_list[0][vehicle_id]', _selectedMyVehicleId);
      }
      f('truck_list[0][vehicle_name]', _transporterNameCtl.text);
      f('truck_list[0][plate_number]', _truckNumberCtl.text);
      f('truck_list[0][trailer_number]', _trailerNumberCtl.text);
      f('truck_list[0][driver_name]', _driverNameCtl.text);
      f('truck_list[0][driver_phone]', _driverPhoneCtl.text);
      f('truck_list[0][driver_license]', _driverLicenseCtl.text);
      f('truck_list[0][truck_details]', _truckDetailsCtl.text);
      if (s.orderEnableVehicleCheckinCheckout &&
          _checkinWeightCtl.text.isNotEmpty) {
        f('truck_list[0][checkin_weight]', _checkinWeightCtl.text);
      }
    }

    if (s.orderShowLocation && _locationCtl.text.isNotEmpty) {
      f('location', _locationCtl.text);
    }
    f('notify_email', _notifyEmail ? 1 : 0);
    f('notify_sms', _notifySms ? 1 : 0);
    f('notify_all', _notifyAll ? 1 : 0);
    f('after_save', _afterSaveAction);

    final formData = FormData();
    formData.fields.addAll(fields);
    formData.files.addAll(files);
    return formData;
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
    final settingsAsync = ref.watch(salesSettingsConfigProvider);

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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
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
      loading: () => _buildField(
        AppTextField(label: label, hintText: 'Loading...', readOnly: true),
      ),
      error: (e, _) => _buildField(
        AppTextField(label: label, hintText: 'Error loading', readOnly: true),
      ),
      data: (list) {
        String? getId(Map m) =>
            (m['id'] ??
                    m['uuid'] ??
                    m['quotation_id'] ??
                    m['request_id'] ??
                    m['contract_id'] ??
                    m['currency_id'] ??
                    m['pfi_id'] ??
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
                    m['trip_number'])
                ?.toString();

        final items = list
            .map((m) => getId(m))
            .where((s) => s != null)
            .cast<String>()
            .toList();
        final selectedVal = items.contains(value?.toString())
            ? value?.toString()
            : null;

        return _buildField(
          AppSmartDropdown<String>(
            value: selectedVal,
            items: items,
            itemBuilder: (id) {
              final m = list.firstWhere(
                (e) => getId(e) == id,
                orElse: () => {},
              );
              // Assemble full name for user records
              if (m['first_name'] != null || m['last_name'] != null) {
                final full =
                    '${m['first_name'] ?? ''} ${m['last_name'] ?? ''}'.trim();
                if (full.isNotEmpty) return full;
              }
              final val =
                  m[displayKey] ??
                  m['name'] ??
                  m['title'] ??
                  m['desc'] ??
                  m['label'] ??
                  m['priority'] ??
                  m['unit'] ??
                  m['unit_name'] ??
                  m['short_name'] ??
                  m['customer_name'] ??
                  m['subject'] ??
                  m['type'] ??
                  m['value'] ??
                  m['discount_type'] ??
                  m['currency_name'] ??
                  m['currency_symbol'] ??
                  m['currency_code'] ??
                  m['code'] ??
                  m['email'] ??
                  m['username'];

              final number =
                  m['number'] ??
                  m['form_number'] ??
                  m['quotation_number'] ??
                  m['pfi_number'] ??
                  m['request_number'] ??
                  m['contract_number'] ??
                  m['ticket_code'];
              if (number != null &&
                  val != null &&
                  number.toString() != val.toString()) {
                return '$number - $val';
              }
              if (number != null) return number.toString();

              return val?.toString() ?? 'ID: $id';
            },
            itemWidgetBuilder: itemWidgetBuilder == null
                ? null
                : (id) {
                    final m = list.firstWhere(
                      (e) => getId(e) == id,
                      orElse: () => {},
                    );
                    return itemWidgetBuilder(m);
                  },
            label: label,
            hintText: hintText,
            onChanged: (v) {
              if (v == null) return onChanged(null);
              if (T == int) return onChanged(int.tryParse(v) as T);
              onChanged(v as T);
            },
          ),
        );
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
            if (_fieldEnabled(cfg, [
              'show_details_section',
              'enable_details_section',
            ])) ...[
              _buildSectionHeader('Details'),
              if (_fieldEnabled(cfg, ['enable_title', 'show_title']))
                _buildField(
                  AppTextField(
                    controller: _titleCtl,
                    label: 'Title',
                    hintText: 'Enter a order title',
                  ),
                ),
              if (_fieldEnabled(cfg, ['enable_customer_id', 'enable_customer']))
                _buildField(
                  AppSmartDropdown<int>(
                    value: _selectedCustomerId,
                    items: _customers.map((c) => c.id!).toList(),
                    itemBuilder: (id) =>
                        _customers.firstWhere((c) => c.id == id, orElse: () => Customer(id: id, name: 'Customer #$id')).name ??
                        'Unknown',
                    label: 'Customer *',
                    hintText: 'Select Customer',
                    enabled: _customers.isNotEmpty,
                    onChanged: (id) => setState(() => _selectedCustomerId = id),
                  ),
                ),
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
                        final rate = await ref
                            .read(salesRemoteDataSourceProvider)
                            .getExchangeRate(id);
                        if (rate != null) {
                          _exchangeRateCtl.text = rate.toString();
                          setState(() {});
                        }
                      }
                    }
                  },
                  displayKey: 'code',
                ),
              if (_fieldEnabled(cfg, [
                'enable_exchange_rate',
                'show_exchange_rate',
              ]))
                _buildField(
                  AppTextField(
                    controller: _exchangeRateCtl,
                    label: 'Exchange rate',
                    hintText: '1.00',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_vehicle_id',
                'enable_vehicle_dropdowns',
                'show_vehicle_dropdowns',
              ]))
                _buildAsyncMapDropdown<int>(
                  asyncValue: ref.watch(salesVehiclesProvider),
                  value: _selectedVehicleId,
                  label: 'Vehicle *',
                  hintText: 'Select Vehicle',
                  onChanged: (v) => setState(() => _selectedVehicleId = v),
                  displayKey: 'plate_number',
                ),
              if (_fieldEnabled(cfg, [
                'enable_cargo_value',
                'show_cargo_value',
              ]))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        controller: _cargoValueCtl,
                        label: 'Cargo Value *',
                        hintText: 'Enter Cargo Value',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: _buildAsyncMapDropdown<String>(
                        asyncValue: ref.watch(salesCargoUnitsProvider),
                        value: _selectedCargoUnit,
                        label: ' ',
                        hintText: 'Unit',
                        onChanged: (v) =>
                            setState(() => _selectedCargoUnit = v),
                      ),
                    ),
                  ],
                ),
              if (_fieldEnabled(cfg, [
                'enable_cargo_value',
                'show_cargo_value',
              ]))
                const SizedBox(height: 12),
              if (_fieldEnabled(cfg, ['enable_start_date', 'show_start_date']))
                _buildField(
                  AppTextField(
                    controller: _startDateCtl,
                    label: 'Start',
                    hintText: 'YYYY-MM-DD',
                    readOnly: true,
                    onTap: () => _selectDate(_startDateCtl),
                  ),
                ),
              if (_fieldEnabled(cfg, ['enable_end_date', 'show_end_date']))
                _buildField(
                  AppTextField(
                    controller: _endDateCtl,
                    label: 'End',
                    hintText: 'Enter Date',
                    readOnly: true,
                    onTap: () => _selectDate(_endDateCtl),
                  ),
                ),
              if (_fieldEnabled(cfg, ['enable_priority', 'show_priority'])) ...[
                _buildAsyncMapDropdown<String>(
                  asyncValue: ref.watch(salesPrioritiesProvider),
                  value: _selectedPriority,
                  label: 'Priority',
                  hintText: 'Select priority',
                  onChanged: (v) => setState(() => _selectedPriority = v),
                ),
                _buildField(
                  AppTextField(
                    label: 'Priority Document',
                    hintText: _priorityFileName ?? 'Choose File',
                    readOnly: true,
                    suffixIcon: const Icon(Icons.attach_file),
                    onTap: _pickPriorityFile,
                  ),
                ),
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
            if (_fieldEnabled(cfg, [
              'show_other_details',
              'enable_other_details',
            ])) ...[
              _buildSectionHeader('Other Details'),
              if (_fieldEnabled(cfg, [
                'enable_status_id',
                'enable_status',
                'show_status',
              ]))
                _buildAsyncMapDropdown<int>(
                  asyncValue: ref.watch(salesOrderStatusesProvider),
                  value: _selectedStatusId,
                  label: 'Status *',
                  hintText: 'Draft',
                  onChanged: (v) => setState(() => _selectedStatusId = v),
                ),
              if (_fieldEnabled(cfg, [
                'enable_assign_user',
                'show_assign_user',
              ]))
                _buildAsyncMapDropdown<int>(
                  asyncValue: ref.watch(salesUsersProvider),
                  value: _assignUserId,
                  label: 'Assign User',
                  hintText: 'Select User',
                  onChanged: (v) => setState(() => _assignUserId = v),
                ),
            ],

            // Sender & Receiver Information
            if (_fieldEnabled(cfg, [
              'show_sender_receiver',
              'enable_sender_receiver',
            ])) ...[
              _buildSectionHeader(
                'Sender & Receiver Information',
                trailing: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Another Sender/Receiver'),
                ),
              ),
              if (_fieldEnabled(cfg, [
                'enable_order_number',
                'show_order_number',
              ]))
                _buildField(
                  AppTextField(
                    controller: _orderNumberCtl,
                    label: 'Order Number *',
                    hintText: 'ORD...',
                  ),
                ),
              if (_fieldEnabled(cfg, ['enable_amount', 'show_amount']))
                _buildField(
                  AppTextField(
                    controller: _amountCtl,
                    label: 'Amount *',
                    hintText: 'eg 5,000',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_package_type',
                'show_package_type',
              ]))
                _buildAsyncMapDropdown<String>(
                  asyncValue: ref.watch(salesPackageTypesProvider),
                  value: _selectedPackageType,
                  label: 'Package Type *',
                  hintText: 'Select Package Type',
                  onChanged: (v) => setState(() => _selectedPackageType = v),
                  displayKey: 'name',
                ),
              if (_fieldEnabled(cfg, [
                'enable_sender_name',
                'show_sender_name',
              ]))
                _buildField(
                  AppTextField(
                    controller: _senderNameCtl,
                    label: 'Sender Name *',
                    hintText: 'Enter Sender Name',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_sender_phone',
                'show_sender_phone',
              ]))
                _buildField(
                  AppTextField(
                    controller: _senderPhoneCtl,
                    label: 'Sender Phone',
                    hintText: 'Enter Sender Phone',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_receiver_name',
                'show_receiver_name',
              ]))
                _buildField(
                  AppTextField(
                    controller: _receiverNameCtl,
                    label: 'Receiver Name *',
                    hintText: 'Enter Receiver Name',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_receiver_phone',
                'show_receiver_phone',
              ]))
                _buildField(
                  AppTextField(
                    controller: _receiverPhoneCtl,
                    label: 'Receiver Phone',
                    hintText: 'Enter Receiver Phone',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_consignment_details',
                'show_consignment_details',
              ]))
                _buildField(
                  AppTextField(
                    controller: _consignmentDetailsCtl,
                    label: 'Consignment Details',
                    maxLines: 3,
                  ),
                ),
            ],

            // LPO and Documents
            if (_fieldEnabled(cfg, [
              'show_contract_section',
              'enable_contract_section',
              'enable_contract',
              'enable_request_id',
              'enable_quotation',
              'enable_lpo_number',
              'enable_payment_type',
            ])) ...[
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
                    final pfi = (q['quotation_number'] ?? q['pfi_number'] ?? '')
                        .toString();
                    final subject =
                        (q['subject'] ?? q['name'] ?? q['title'] ?? '')
                            .toString();
                    return RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.grey.shade800,
                        ),
                        children: [
                          TextSpan(
                            text: pfi,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (pfi.isNotEmpty && subject.isNotEmpty)
                            const TextSpan(text: ' - '),
                          TextSpan(text: subject),
                        ],
                      ),
                    );
                  },
                ),
              if (_fieldEnabled(cfg, ['enable_lpo_number', 'show_lpo_number']))
                _buildField(
                  AppTextField(
                    controller: _lpoNumberCtl,
                    label: 'LPO Number',
                    hintText: 'Enter lpo number',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_lpo_document',
                'show_lpo_document',
              ]))
                _buildField(
                  AppTextField(
                    label: 'LPO Document',
                    hintText: _lpoFileName ?? 'Choose File',
                    readOnly: true,
                    suffixIcon: const Icon(Icons.attach_file),
                    onTap: _pickLpoFile,
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_payment_type',
                'show_payment_type',
              ]))
                _buildAsyncMapDropdown<String>(
                  asyncValue: ref.watch(salesPaymentTypesProvider),
                  value: _selectedPaymentType,
                  label: 'Payment Type',
                  hintText: 'Select',
                  onChanged: (v) => setState(() => _selectedPaymentType = v),
                ),
              if (_fieldEnabled(cfg, [
                'enable_prof_of_payment',
                'show_prof_of_payment',
              ]))
                _buildField(
                  AppTextField(
                    label: 'Prof Of Payment',
                    hintText: _popFileName ?? 'Choose File',
                    readOnly: true,
                    suffixIcon: const Icon(Icons.attach_file),
                    onTap: _pickPopFile,
                  ),
                ),
            ],

            // Items List
            if (_fieldEnabled(cfg, [
              'show_items_section',
              'enable_items_section',
              'enable_items',
            ])) ...[
              _buildSectionHeader('Items'),
              _buildItems(isDark, cfg),
            ],

            // Order Truck List
            if (_fieldEnabled(cfg, [
              'show_trucks_section',
              'enable_truck_details',
              'enable_trucks',
              'show_truck_list',
            ])) ...[
              _buildSectionHeader('Order Truck List'),
              if (_fieldEnabled(cfg, [
                'enable_truck_vehicle_id',
                'show_vehicle_dropdowns',
              ])) ...[
                _buildAsyncMapDropdown<int>(
                  asyncValue: ref.watch(salesVehiclesProvider),
                  value: _selectedMyVehicleId,
                  label: 'My Vehicles',
                  hintText: 'Select Vehicle',
                  onChanged: (v) => setState(() => _selectedMyVehicleId = v),
                  displayKey: 'plate_number',
                ),
              ],
              if (_fieldEnabled(cfg, [
                'enable_vehicle_name',
                'show_vehicle_name',
              ]))
                _buildField(
                  AppTextField(
                    controller: _transporterNameCtl,
                    label: 'Transpoter Name',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_vehicle_plate_number',
                'show_vehicle_plate_number',
              ]))
                _buildField(
                  AppTextField(
                    controller: _truckNumberCtl,
                    label: 'Truck Number',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_vehicle_trailer_number',
                'show_vehicle_trailer_number',
              ]))
                _buildField(
                  AppTextField(
                    controller: _trailerNumberCtl,
                    label: 'Trailer Number',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_driver_name',
                'show_driver_name',
              ]))
                _buildField(
                  AppTextField(
                    controller: _driverNameCtl,
                    label: 'Driver Name',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_driver_phone',
                'show_driver_phone',
              ]))
                _buildField(
                  AppTextField(
                    controller: _driverPhoneCtl,
                    label: 'Driver Phone',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_driver_license_number',
                'show_driver_license_number',
              ]))
                _buildField(
                  AppTextField(
                    controller: _driverLicenseCtl,
                    label: 'Driver License',
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_truck_details',
                'show_truck_details',
              ]))
                _buildField(
                  AppTextField(
                    controller: _truckDetailsCtl,
                    label: 'Truck Details',
                    maxLines: 2,
                  ),
                ),
              if (_fieldEnabled(cfg, [
                'enable_checkin_weight',
                'show_checkin_weight',
              ]))
                _buildField(
                  AppTextField(
                    controller: _checkinWeightCtl,
                    label: 'Check-in Weight',
                    suffixIcon: TextButton(
                      onPressed: () {},
                      child: const Text('Fetch from Weighbridge'),
                    ),
                  ),
                ),
            ],

            // Location
            if (_fieldEnabled(cfg, ['enable_location', 'show_location'])) ...[
              _buildSectionHeader('Location'),
              _buildField(
                AppTextField(
                  controller: _locationCtl,
                  label: '',
                  hintText: 'Enter location (optional)',
                  prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Specify the order location',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Notifications
            _buildSectionHeader(
              'Notifications',
              trailing: const Icon(
                Icons.notifications_active_outlined,
                size: 18,
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _notifyEmail,
                  onChanged: (v) => setState(() => _notifyEmail = v ?? false),
                ),
                const Text('Email'),
                const SizedBox(width: 8),
                Checkbox(
                  value: _notifySms,
                  onChanged: (v) => setState(() => _notifySms = v ?? false),
                ),
                const Text('SMS'),
                const SizedBox(width: 8),
                Checkbox(
                  value: _notifyAll,
                  onChanged: (v) => setState(() => _notifyAll = v ?? false),
                ),
                const Text('All'),
              ],
            ),

            // After Save Order
            _buildSectionHeader(
              'After Save Order',
              trailing: const Icon(
                Icons.article_outlined,
                size: 18,
                color: Colors.grey,
              ),
            ),
            Wrap(
              spacing: 16,
              children:
                  [
                    'Create Trip',
                    'Create Task',
                    'Create Receipt',
                    'Nothing',
                  ].map((val) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: val,
                          groupValue: _afterSaveAction,
                          onChanged: (v) =>
                              setState(() => _afterSaveAction = v ?? 'Nothing'),
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
    return Padding(padding: const EdgeInsets.only(bottom: 12.0), child: child);
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
        final percent =
            double.tryParse(percentMatch?.group(1) ?? '0') ??
            18.0; // Default to 18 if 'VAT' present but no %
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
                          ),
                        ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2634),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildItemTag(isDark, 'Qty: ${item.qty}'),
                              if (item.packSize != null)
                                _buildItemTag(isDark, 'Pack: ${item.packSize}'),
                              _buildItemTag(
                                isDark,
                                'Price: ${NumberFormat.decimalPattern().format(item.price)}',
                              ),
                              if (item.tax != null)
                                _buildItemTag(isDark, 'Tax: ${item.tax}'),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
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
                      onPressed: () async {
                        final result = await showModalBottomSheet<_DraftItem>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => _AddItemDrawer(cfg: cfg, editItem: item),
                        );
                        if (result != null) {
                          if (mounted) {
                            setState(() => _items[i] = result);
                            _updateTotals();
                          }
                        }
                      },
                      icon: Icon(
                        Icons.edit_rounded,
                        size: 20,
                        color: primaryColor,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
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
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
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
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
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
                _buildSummaryRow(
                  'Grand Total',
                  grandTotal,
                  isDark,
                  isTotal: true,
                ),
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
                Icon(
                  Icons.add_circle_outline_rounded,
                  size: 20,
                  color: primaryColor,
                ),
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

  Widget _buildSummaryRow(
    String label,
    double value,
    bool isDark, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.white60 : Colors.grey.shade600),
          ),
        ),
        Text(
          NumberFormat.decimalPattern().format(value),
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal
                ? AppColors.primary
                : (isDark ? Colors.white : Colors.black87),
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
  final _DraftItem? editItem;
  const _AddItemDrawer({required this.cfg, this.editItem});

  @override
  ConsumerState<_AddItemDrawer> createState() => _AddItemDrawerState();
}

class _AddItemDrawerState extends ConsumerState<_AddItemDrawer> {
  final _itemNameCtl = TextEditingController(); // For custom entry
  final _qtyCtl = TextEditingController();
  final _packSizeInputCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  final _discountCtl = TextEditingController(text: '0');

  ProductSummary? _selectedProduct;
  String? _selectedUnit;
  String? _selectedPackSize;
  double _availableStock = 0;
  String? _selectedTax;

  @override
  void initState() {
    super.initState();
    if (widget.editItem != null) {
      final item = widget.editItem!;
      _itemNameCtl.text = item.name;
      _qtyCtl.text = item.qty.toString();
      _priceCtl.text = item.price.toString();
      _discountCtl.text = item.discount.toString();
      _selectedTax = item.tax;
      _selectedPackSize = item.packSize;
      _availableStock = item.available;
      
      // Attempt to restore selected product if ID is known
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && item.itemId > 0) {
          final products = ref.read(salesProductsProvider).value ?? [];
          final match = products.where((p) => p.id == item.itemId).toList();
          if (match.isNotEmpty) {
            setState(() => _selectedProduct = match.first);
          }
        }
      });
    }
  }
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

    // When enable_auto_qty_unit_capture == 1: qty auto-fills to 1 on product
    // selection and remains editable. When 0: no auto-fill, field is disabled.
    final autoQtyCapture =
        (widget.cfg['enable_auto_qty_unit_capture'] as int? ?? 1) != 0;

    final qty = double.tryParse(_qtyCtl.text) ?? 1;
    final price = double.tryParse(_priceCtl.text) ?? 0;
    final discount = double.tryParse(_discountCtl.text) ?? 0;
    final calculatedAmount = (qty * price) - discount;

    final productCandidates = productsAsync.value ?? [];
    final unitList =
        (unitsAsync.value ?? []).map((u) => u.name ?? 'Unit').toList()..addAll(
          [
            'PCS',
            'LITERS',
            'tonne',
            'kgs',
            'Bags',
            'drum',
            'BOX',
            'Pair',
            'bottles',
          ].where(
            (d) => !(unitsAsync.value ?? []).any(
              (e) => e.name?.toLowerCase() == d.toLowerCase(),
            ),
          ),
        );
    if (_selectedUnit != null && !unitList.contains(_selectedUnit)) {
      unitList.add(_selectedUnit!);
    }

    final taxList =
        (taxesAsync.value ?? [])
            .map(
              (e) =>
                  e['name']?.toString() ??
                  e['title']?.toString() ??
                  e['tax_name']?.toString() ??
                  e['desc']?.toString() ??
                  e['value']?.toString() ??
                  '',
            )
            .where((s) => s.isNotEmpty)
            .toList()
          ..addAll(
            ['No Tax', 'VAT 18%'].where(
              (d) => !(taxesAsync.value ?? []).any(
                (e) =>
                    (e['name'] ?? '').toString().toLowerCase() ==
                    d.toLowerCase(),
              ),
            ),
          );
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
                        Text(
                          widget.editItem != null ? 'Edit Material' : 'Add Material',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade600,
                          ),
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
                      hintText: productsAsync.isLoading
                          ? 'Loading materials...'
                          : 'Select material',
                      onChanged: (p) {
                        if (p != null) {
                          setState(() {
                            _selectedProduct = p;
                            _itemNameCtl.text = p.name ?? '';
                            _priceCtl.text = p.salePrice?.toString() ?? '0';
                            _availableStock = 100; // Mock available balance

                            // Auto-populate qty to 1 only when capture is enabled.
                            if (autoQtyCapture) _qtyCtl.text = '1';

                            // Auto-populate unit from product
                            if (p.unitName != null && p.unitName!.isNotEmpty) {
                              final match = unitList.firstWhere(
                                (u) =>
                                    u.toLowerCase() ==
                                    p.unitName!.toLowerCase(),
                                orElse: () => p.unitName!,
                              );
                              _selectedUnit = match;
                            }

                            // Auto-populate tax from product
                            if (p.taxName != null && p.taxName!.isNotEmpty) {
                              final match = taxList.firstWhere(
                                (t) =>
                                    t.toLowerCase() == p.taxName!.toLowerCase(),
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
                      AppTextField(
                        controller: _itemNameCtl,
                        label: 'Custom Material Name',
                        hintText: 'Enter name manually',
                      ),
                      const SizedBox(height: 12),
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _qtyCtl,
                            label: 'Qty',
                            isRequired: true,
                            enabled: autoQtyCapture,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
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
                        Expanded(
                          child: AppTextField(
                            controller: _packSizeInputCtl,
                            label: 'Pack Size (Input)',
                            hintText: 'eg. 50',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppSmartDropdown<String>(
                            value: _selectedPackSize,
                            items: unitList,
                            itemBuilder: (s) => s,
                            label: 'Pack Size (Drop)',
                            hintText: 'Select',
                            onChanged: (v) =>
                                setState(() => _selectedPackSize = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _priceCtl,
                            label: 'Price',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppTextField(
                            controller: _discountCtl,
                            label: 'Discount',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    AppSmartDropdown<String>(
                      value: _selectedTax,
                      items: taxList,
                      itemBuilder: (s) => s,
                      label: 'Tax',
                      hintText: taxesAsync.isLoading
                          ? 'Loading...'
                          : 'Select tax',
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Add Item'),
                          ),
                        ),
                      ],
                    ),
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
