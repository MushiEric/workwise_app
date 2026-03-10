import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';
import 'package:workwise_erp/core/widgets/app_smart_dropdown.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../../domain/entities/jobcard_create_params.dart';
import '../providers/jobcard_providers.dart';
import '../../../support/presentation/providers/support_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/technician_selector.dart';
import '../widgets/items_list.dart';
import '../widgets/attachments_section.dart';
import '../../../../core/themes/app_icons.dart';

class JobcardCreatePage extends ConsumerStatefulWidget {
  const JobcardCreatePage({super.key});

  @override
  ConsumerState<JobcardCreatePage> createState() => _JobcardCreatePageState();
}

class _JobcardCreatePageState extends ConsumerState<JobcardCreatePage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  final _subjectCtl = TextEditingController();
  final _jobcardNumberCtl = TextEditingController();
  final _reportedDateCtl = TextEditingController();
  final _dispatchedDateCtl = TextEditingController();

  String? _relatedTo = 'Vehicle';
  int? _vehicleId;
  List<int> _technicianIds = [];
  int? _receiverId;
  String? _receiverType;
  String? _receiverName; // manual "Other" or explicit receiver name
  int? _statusId;
  int? _supervisorId;
  int? _locationId;
  List<Map<String, dynamic>> _items = [];
  num _grandTotal = 0;

  // attachments (local picks)
  List<Map<String, dynamic>> _itemFiles = [];
  List<Map<String, dynamic>> _serviceFiles = [];

  // dropdown caches
  List<Map<String, dynamic>> _vehicles = [];
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _receivers = [];

  // product/service catalogs for Items UI
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _productUnits = [];
  List<Map<String, dynamic>> _services = [];

  // support tickets & statuses (for dropdowns)
  List<Map<String, dynamic>> _tickets = [];
  List<Map<String, dynamic>> _supportStatuses = [];
  int? _supportTicketId;

  bool _submitting = false;
  bool _generatingNumber = false;

  final TextEditingController _relatedOtherCtl = TextEditingController();
  final TextEditingController _notesCtl = TextEditingController();

  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    // rotation controller for jobcard-number refresh icon
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _loadAuxData();
    // restore draft if present, otherwise prefill generated number
    _loadDraft().then((restored) {
      if (!restored) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _generateNumber());
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _relatedOtherCtl.dispose();
    _notesCtl.dispose();
    _subjectCtl.dispose();
    _jobcardNumberCtl.dispose();
    _reportedDateCtl.dispose();
    _dispatchedDateCtl.dispose();
    super.dispose();
  }

  Future<void> _loadAuxData() async {
    final authState = ref.read(authNotifierProvider);
    final creatorId = authState.maybeWhen(
      authenticated: (u) => u.id,
      orElse: () => null,
    );

    // ── form-data (vehicles, users, products, units) via use case ──────────
    final formDataResult = await ref
        .read(getJobcardFormDataUseCaseProvider)
        .call(creatorId: creatorId);

    List<Map<String, dynamic>> servicesFromProducts = [];

    formDataResult.fold(
      (_) {
        /* keep empty defaults */
      },
      (data) {
        _vehicles = data.vehicles;
        _users = data.users;

        final prodOnly = <Map<String, dynamic>>[];
        final svcOnly = <Map<String, dynamic>>[];
        for (final m in data.products) {
          final t = (m['type'] ?? m['item_type'] ?? '')
              .toString()
              .toLowerCase();
          if (t.contains('service')) {
            svcOnly.add(m);
          } else {
            prodOnly.add(m);
          }
        }
        _products = prodOnly;
        _productUnits = data.productUnits;
        servicesFromProducts = svcOnly
            .map((m) => {'id': m['id'], 'name': m['name'] ?? m['title'] ?? ''})
            .toList();
      },
    );

    // services (reuse support services use-case) — include any `service` entries embedded in product/getItem
    try {
      final svcRes = await ref.read(getSupportServicesUseCaseProvider).call();
      svcRes.fold(
        (_) =>
            _services = List<Map<String, dynamic>>.from(servicesFromProducts),
        (list) {
          final fromSupport = list
              .map((s) => {'id': s.id, 'name': s.name})
              .toList();
          // merge and dedupe by id
          final combined = <int, Map<String, dynamic>>{};
          for (final s in servicesFromProducts) {
            final id =
                int.tryParse(s['id']?.toString() ?? '') ??
                (s['id'] is int ? s['id'] as int : 0);
            if (id > 0) combined[id] = s;
          }
          for (final s in fromSupport) {
            final id = s['id'] is int
                ? s['id'] as int
                : int.tryParse(s['id']?.toString() ?? '') ?? 0;
            if (id > 0) combined[id] = s;
          }
          _services = combined.values.toList();
        },
      );
    } catch (_) {
      _services = List<Map<String, dynamic>>.from(servicesFromProducts);
    }

    // support statuses (for Status dropdown)
    try {
      final stRes = await ref.read(getSupportStatusesUseCaseProvider).call();
      stRes.fold((_) => _supportStatuses = [], (list) {
        _supportStatuses = list
            .map((s) => {'id': s.id, 'name': s.status})
            .toList();
      });
    } catch (_) {
      _supportStatuses = [];
    }

    // support tickets (for Support Ticket dropdown)
    try {
      final tRes = await ref.read(getSupportTicketsUseCaseProvider).call();
      tRes.fold((_) => _tickets = [], (list) {
        _tickets = list
            .map((t) => {'id': t.id, 'name': t.subject ?? 'Ticket ${t.id}'})
            .toList();
      });
    } catch (_) {
      _tickets = [];
    }

    setState(() {});
  }

  /// Load receiver names for a given receiver `type` (customer, vendor, user, employee)
  Future<void> _loadReceiversByType(String type) async {
    setState(() {
      _receiverType = type;
      _receiverId = null;
      _receivers = [];
    });

    final result = await ref.read(getReceiversByTypeUseCaseProvider).call(type);
    result.fold(
      (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load receivers')),
          );
        }
      },
      (list) {
        if (mounted) setState(() => _receivers = list);
      },
    );
  }

  String? _findReceiverNameById(int id) {
    try {
      final r = _receivers.firstWhere(
        (e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == id,
      );
      return r['name']?.toString() ??
          r['title']?.toString() ??
          r['username']?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<void> _generateNumber() async {
    // Start rotation animation
    setState(() {
      _generatingNumber = true;
    });
    _rotationController.reset();
    _rotationController.repeat();

    // debug: indicate start of generate call in logs
    assert(() {
      // ignore: avoid_print
      print('[JobcardCreatePage] Getting jobcard number...');
      return true;
    }());

    try {
      final genUc = ref.read(generateJobcardNumberUseCaseProvider);
      final res = await genUc.call();

      res.fold(
        (l) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to generate jobcard number')),
          );
        },
        (r) {
          _jobcardNumberCtl.text = r;
        },
      );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error generating jobcard number')),
        );
    } finally {
      // Stop animation
      _rotationController.stop();
      if (mounted) setState(() => _generatingNumber = false);
    }
  }

  void _recalcTotal() {
    _grandTotal = 0;
    for (final it in _items) {
      final qty = (it['qty'] is int)
          ? it['qty'] as int
          : int.tryParse(it['qty'].toString()) ?? 0;
      final price = (it['price'] is num)
          ? it['price'] as num
          : num.tryParse(it['price'].toString()) ?? 0;
      _grandTotal += qty * price;
    }
  }

  String _humanFileSize(int? bytes) {
    if (bytes == null) return 'Unknown size';
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  Future<void> _pickItemFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() {
      for (final f in result.files) {
        // enforce 5MB per-file limit
        if (f.size > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${f.name} exceeds 5MB limit')),
          );
          continue;
        }
        _itemFiles.add({'name': f.name, 'size': f.size, 'path': f.path});
      }
    });
  }

  Future<void> _pickServiceFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() {
      for (final f in result.files) {
        if (f.size > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${f.name} exceeds 5MB limit')),
          );
          continue;
        }
        _serviceFiles.add({'name': f.name, 'size': f.size, 'path': f.path});
      }
    });
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = {
      'jobcard_number': _jobcardNumberCtl.text,
      'subject': _subjectCtl.text,
      'reported_date': _reportedDateCtl.text,
      'dispatched_date': _dispatchedDateCtl.text,
      'related_to': _relatedTo,
      'vehicle_id': _vehicleId,
      'technician_ids': _technicianIds,
      'receiver_id': _receiverId,
      'receiver_type': _receiverType,
      'receiver_name': _receiverName ?? _relatedOtherCtl.text,
      'supervisor_id': _supervisorId,
      'location_id': _locationId,
      'items': _items,
      'grand_total': _grandTotal,
      'item_files': _itemFiles,
      'service_files': _serviceFiles,
      'notes': _notesCtl.text,
      'support_ticket_id': _supportTicketId,
      'current_step': _currentStep,
    };
    await prefs.setString('jobcard_create_draft_v1', json.encode(draft));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Draft saved')));
  }

  Future<bool> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('jobcard_create_draft_v1');
    if (s == null) return false;
    try {
      final data = json.decode(s) as Map<String, dynamic>;
      setState(() {
        _jobcardNumberCtl.text = data['jobcard_number'] ?? '';
        _subjectCtl.text = data['subject'] ?? '';
        _reportedDateCtl.text = data['reported_date'] ?? '';
        _dispatchedDateCtl.text = data['dispatched_date'] ?? '';
        _relatedTo = data['related_to'] ?? 'Vehicle';
        _vehicleId = data['vehicle_id'] != null
            ? int.tryParse(data['vehicle_id'].toString())
            : null;
        _technicianIds = (data['technician_ids'] is List)
            ? (data['technician_ids'] as List)
                  .map((e) => int.tryParse(e.toString()) ?? 0)
                  .where((v) => v > 0)
                  .toList()
            : [];
        _receiverId = data['receiver_id'] != null
            ? int.tryParse(data['receiver_id'].toString())
            : null;
        _receiverType = data['receiver_type'];
        _receiverName = data['receiver_name']?.toString();
        _relatedOtherCtl.text = _receiverName ?? '';
        _supervisorId = data['supervisor_id'] != null
            ? int.tryParse(data['supervisor_id'].toString())
            : null;
        _locationId = data['location_id'] != null
            ? int.tryParse(data['location_id'].toString())
            : null;
        _items = (data['items'] is List)
            ? List<Map<String, dynamic>>.from(data['items'] as List)
            : [];
        _grandTotal = num.tryParse(data['grand_total']?.toString() ?? '0') ?? 0;
        _itemFiles = (data['item_files'] is List)
            ? List<Map<String, dynamic>>.from(data['item_files'] as List)
            : [];
        _serviceFiles = (data['service_files'] is List)
            ? List<Map<String, dynamic>>.from(data['service_files'] as List)
            : [];
        _notesCtl.text = data['notes']?.toString() ?? '';
        _supportTicketId = data['support_ticket_id'] != null
            ? int.tryParse(data['support_ticket_id'].toString())
            : null;
        final rawStep = data['current_step'];
        final parsedStep = rawStep is int
            ? rawStep
            : int.tryParse(rawStep?.toString() ?? '') ?? 0;
        _currentStep = parsedStep.clamp(0, 4);
      });
      if (!mounted) return true;
      // if draft contained receiver type we should load its options so UI can show selection
      if (_receiverType != null &&
          (_receiverType == 'user' ||
              _receiverType == 'customer' ||
              _receiverType == 'vendor' ||
              _receiverType == 'employee')) {
        // ignore: unawaited_futures
        _loadReceiversByType(_receiverType!);
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Draft loaded')));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jobcard_create_draft_v1');
  }

  Future<void> _submit() async {
    // basic validation for required fields
    if (_jobcardNumberCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jobcard number is required')),
      );
      return;
    }
    if (_subjectCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Subject is required')));
      return;
    }
    if (_reportedDateCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Starting On is required')));
      return;
    }
    if (_technicianIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one staff member is required')),
      );
      return;
    }

    // Status is required
    if (_statusId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Status is required')));
      return;
    }

    // validate receiver/related fields depending on `Related To`
    if (_relatedTo == 'Other') {
      if ((_receiverName ?? _relatedOtherCtl.text).trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a value for "Other"')),
        );
        return;
      }
    } else if (_relatedTo == 'Customer' ||
        _relatedTo == 'Vendor' ||
        _relatedTo == 'Users' ||
        _relatedTo == 'Employee' ||
        _relatedTo == 'User') {
      if (_receiverId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Receiver is required')));
        return;
      }
    } else if (_relatedTo == 'Vehicle') {
      if (_vehicleId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Vehicle is required')));
        return;
      }
    }

    final params = JobcardCreateParams(
      jobcardNumber: _jobcardNumberCtl.text.trim(),
      subject: _subjectCtl.text.trim(),
      reportedDate: _reportedDateCtl.text.trim(),
      dispatchedDate: _dispatchedDateCtl.text.trim().isEmpty
          ? null
          : _dispatchedDateCtl.text.trim(),
      vehicleId: _vehicleId,
      technicianIds: _technicianIds,
      departmentIds: null,
      service: null,
      description: null,
      notes: _notesCtl.text.trim().isNotEmpty ? _notesCtl.text.trim() : null,
      relatedTo: _relatedTo,
      receiverId: _receiverId,
      receiverName: (_receiverName != null && _receiverName!.trim().isNotEmpty)
          ? _receiverName
          : (_relatedOtherCtl.text.trim().isNotEmpty
                ? _relatedOtherCtl.text.trim()
                : null),
      supportId: _supportTicketId,
      status: _statusId,
      supervisorId: _supervisorId,
      locationId: _locationId,
      proposalId: null,
      separationItem: 0,
      grandTotal: _grandTotal,
      items: _items,
      itemAttachmentPaths: _itemFiles
          .map((f) => f['path'] as String?)
          .whereType<String>()
          .toList(),
      serviceAttachmentPaths: _serviceFiles
          .map((f) => f['path'] as String?)
          .whereType<String>()
          .toList(),
    );

    // show modal loading dialog (button stays disabled but does not show spinner)
    setState(() => _submitting = true);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF151A2E)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Creating...'),
            ],
          ),
        ),
      ),
    );

    final createUc = ref.read(createJobcardUseCaseProvider);
    final res = await createUc.call(params);

    // dismiss modal
    if (mounted) Navigator.of(context).pop();
    setState(() => _submitting = false);

    res.fold(
      (l) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Create failed: ${l.toString()}')),
        );
      },
      (id) async {
        // clear saved draft
        await _clearDraft();
        // navigate to detail
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushReplacementNamed('/jobcards/detail', arguments: id);
      },
    );
  }

  // Date picker method
  Future<void> _selectDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  Widget _buildStep1(BuildContext ctx) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Jobcard Number (use AppTextField directly for consistent styling)
        AppTextField(
          controller: _jobcardNumberCtl,
          readOnly: true,
          labelText: 'Jobcard Number',
          backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: 16,
          suffixIcon: _generatingNumber
              ? SizedBox(
                  width: 32,
                  height: 24,
                  child: Center(
                    child: RotationTransition(
                      turns: _rotationController,
                      child: const Icon(AppIcons.autorenew, size: 18),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(AppIcons.autorenew, size: 18),
                  onPressed: _generateNumber,
                ),
        ),
        const SizedBox(height: 12),

        // Subject (use AppTextField without external container)
        AppTextField(
          controller: _subjectCtl,
          labelText: 'Subject',
          hintText: 'Enter subject',
          backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: 16,
          prefixIcon: Icon(AppIcons.subjectRounded, size: 18),
        ),
        const SizedBox(height: 12),

        // Related To
        AppSmartDropdown<String>(
          backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: 16,
          value: _relatedTo,
          items: const ['Customer', 'Vehicle', 'Vendor', 'Users', 'Other'],
          itemBuilder: (item) => item,
          label: 'Related To',
          // prefixIcon: Icons.category_rounded,
          onChanged: (v) async {
            if (v == null) return;
            setState(() {
              _relatedTo = v;
              _receiverId = null;
              _receiverType = null;
              _receiverName = null;
            });

            if (v == 'Customer' || v == 'Vendor' || v == 'Users') {
              final map = {
                'Customer': 'customer',
                'Vendor': 'vendor',
                'Users': 'user',
              };
              final type = map[v] ?? v.toLowerCase();
              await _loadReceiversByType(type);
            }
          },
        ),
        const SizedBox(height: 12),

        // Vehicle (conditional)
        if (_relatedTo == 'Vehicle' && _vehicles.isNotEmpty)
          AppSmartDropdown<int>(
            backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: 16,
            value: _vehicleId,
            items: _vehicles
                .map((v) => int.tryParse(v['id']?.toString() ?? '') ?? 0)
                .where((id) => id > 0)
                .toList(),
            itemBuilder: (id) {
              final v = _vehicles.firstWhere(
                (e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == id,
                orElse: () => {},
              );
              return v.isNotEmpty
                  ? (v['vehicle_name'] ?? v['name'] ?? 'Vehicle $id')
                  : 'Vehicle $id';
            },
            label: 'Select Vehicle',
            // prefixIcon: Icons.directions_car_rounded,
            onChanged: (v) => setState(() => _vehicleId = v),
          ),

        // Receiver selection when Related To is customer/vendor/users
        if ((_relatedTo == 'Customer' ||
            _relatedTo == 'Vendor' ||
            _relatedTo == 'Users'))
          AppSmartDropdown<int>(
            backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: 16,
            value: _receiverId,
            items: _receivers
                .map((r) => int.tryParse(r['id']?.toString() ?? '') ?? 0)
                .where((id) => id > 0)
                .toList(),
            itemBuilder: (id) {
              final r = _receivers.firstWhere(
                (e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == id,
                orElse: () => {},
              );
              return r.isNotEmpty
                  ? (r['name'] ?? r['title'] ?? r['username'] ?? 'Receiver $id')
                  : 'Receiver $id';
            },
            label: 'Select ${_relatedTo ?? 'Receiver'}',
            enabled: _receivers.isNotEmpty,
            onChanged: (v) => setState(() => _receiverId = v),
          ),

        // 'Other' free-text input
        if (_relatedTo == 'Other')
          AppTextField(
            controller: _relatedOtherCtl,
            onChanged: (v) => _receiverName = v,
            labelText: 'Specify (other)',
            hintText: 'Enter related value',
            backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: 16,
          ),
        const SizedBox(height: 12),

        // Dates Row
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _reportedDateCtl,
                readOnly: true,
                labelText: 'Starting On',
                hintText: 'Select date',
                prefixIcon: Icon(AppIcons.eventRounded, size: 18),
                suffixIcon: IconButton(
                  icon: Icon(AppIcons.calendarTodayRounded, size: 16),
                  onPressed: () => _selectDate(_reportedDateCtl),
                ),
                backgroundColor: isDark
                    ? const Color(0xFF151A2E)
                    : Colors.white,
                borderRadius: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: _dispatchedDateCtl,
                readOnly: true,
                labelText: 'Dispatched Date',
                hintText: 'Optional',
                prefixIcon: Icon(AppIcons.eventRounded, size: 18),
                suffixIcon: IconButton(
                  icon: Icon(AppIcons.calendarTodayRounded, size: 16),
                  onPressed: () => _selectDate(_dispatchedDateCtl),
                ),
                backgroundColor: isDark
                    ? const Color(0xFF151A2E)
                    : Colors.white,
                borderRadius: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2(BuildContext ctx) {
    return Column(
      children: [
        // Technician Selector
        TechnicianSelector(
          selectedIds: _technicianIds,
          users: _users,
          onChanged: (ids) => setState(() => _technicianIds = ids),
        ),
        const SizedBox(height: 12),

        // Receiver (managed in Basic / "Related To") — show summary here and allow quick jump
        ListTile(
          title: const Text('Receiver'),
          subtitle: _receiverId != null
              ? Text(
                  _findReceiverNameById(_receiverId!) ??
                      _receiverName ??
                      'Receiver $_receiverId',
                )
              : Text(
                  (_receiverName != null && _receiverName!.isNotEmpty)
                      ? _receiverName!
                      : 'Select via Basic -> Related To',
                ),
          trailing: IconButton(
            icon: const Icon(AppIcons.editRounded),
            onPressed: () => setState(() => _currentStep = 0),
          ),
        ),
        const SizedBox(height: 12),

        // Supervisor
        FutureBuilder(
          future: ref.read(getSupportSupervisorsUseCaseProvider).call(),
          builder: (ctx, snap) {
            if (!snap.hasData) return const SizedBox.shrink();
            final either = snap.data!;
            return either.fold((l) => const SizedBox.shrink(), (list) {
              return AppSmartDropdown<int>(
                backgroundColor: Colors.white,
                borderRadius: 16,
                value: _supervisorId,
                items: list.map((s) => s.user?.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final s = list.firstWhere((e) => e.user?.id == id);
                  return s.user?.name ?? 'Supervisor $id';
                },
                label: 'Supervisor (Optional)',
                onChanged: (v) => setState(() => _supervisorId = v),
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildStep3(BuildContext ctx) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Department
        FutureBuilder(
          future: ref.read(getSupportDepartmentsUseCaseProvider).call(),
          builder: (ctx, snap) {
            if (!snap.hasData) return const SizedBox.shrink();
            final either = snap.data!;
            return either.fold((l) => const SizedBox.shrink(), (list) {
              return AppSmartDropdown<int>(
                backgroundColor: isDark
                    ? const Color(0xFF151A2E)
                    : Colors.white,
                borderRadius: 16,
                value: _locationId,
                items: list.map((d) => d.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final d = list.firstWhere((e) => e.id == id);
                  return d.name ?? 'Department $id';
                },
                label: 'Department (Optional)',
                onChanged: (v) => setState(() => _locationId = v),
              );
            });
          },
        ),
        const SizedBox(height: 12),

        // Location
        FutureBuilder(
          future: ref.read(getSupportLocationsUseCaseProvider).call(),
          builder: (ctx, snap) {
            if (!snap.hasData) return const SizedBox.shrink();
            final either = snap.data!;
            return either.fold((l) => const SizedBox.shrink(), (list) {
              return AppSmartDropdown<int>(
                backgroundColor: isDark
                    ? const Color(0xFF151A2E)
                    : Colors.white,
                borderRadius: 16,
                value: _locationId,
                items: list.map((d) => d.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final d = list.firstWhere((e) => e.id == id);
                  return d.name ?? 'Location $id';
                },
                label: 'Location',
                onChanged: (v) => setState(() => _locationId = v),
              );
            });
          },
        ),

        const SizedBox(height: 12),

        // Status (required)
        AppSmartDropdown<int>(
          backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: 16,
          value: _statusId,
          items: _supportStatuses
              .map((s) => int.tryParse(s['id']?.toString() ?? '') ?? 0)
              .where((id) => id > 0)
              .toList(),
          itemBuilder: (id) {
            final s = _supportStatuses.firstWhere(
              (e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == id,
              orElse: () => {},
            );
            return s.isNotEmpty ? (s['name'] ?? 'Status $id') : 'Status $id';
          },
          label: 'Status',
          onChanged: (v) => setState(() => _statusId = v),
        ),

        const SizedBox(height: 12),

        // Recommendation (optional)
        AppTextField(
          controller: _notesCtl,
          labelText: 'Recommendation',
          hintText: 'Optional',
          maxLines: 3,
          backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: 16,
        ),
      ],
    );
  }

  Widget _buildStep4(BuildContext ctx) {
    return Column(
      children: [
        // Items List
        ItemsList(
          items: _items,
          grandTotal: _grandTotal,
          products: _products,
          productUnits: _productUnits,
          services: _services,
          onItemsChanged: (newItems) {
            setState(() {
              _items = newItems;
              _recalcTotal();
            });
          },
          onAddItem: () {},
        ),
        const SizedBox(height: 12),

        // Attachments
        // AttachmentsSection(
        //   title: 'Item Attachments',
        //   icon: AppIcons.inventory2Rounded,
        //   files: _itemFiles,
        //   onPickFiles: _pickItemFiles,
        //   onRemoveFile: (index) => setState(() => _itemFiles.removeAt(index)),
        //   formatFileSize: _humanFileSize,
        // ),
        // const SizedBox(height: 12),

        // AttachmentsSection(
        //   title: 'Service Attachments',
        //   icon: AppIcons.buildRounded,
        //   files: _serviceFiles,
        //   onPickFiles: _pickServiceFiles,
        //   onRemoveFile: (index) => setState(() => _serviceFiles.removeAt(index)),
        //   formatFileSize: _humanFileSize,
        // ),
      ],
    );
  }

  Widget _buildStep5(BuildContext ctx) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Preview CTA (summary hidden on the form)
        /*
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Summary is hidden on the form. Tap Preview to view the jobcard summary and manage drafts.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AppButton(
                text: 'Preview',
                icon: AppIcons.visibilityRounded,
                onPressed: _showPreviewDialog,
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.small,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Action Buttons
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151A2E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Draft Actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Save Draft',
                        icon: AppIcons.saveOutlined,
                        onPressed: _saveDraft,
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.small,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: 'Clear Draft',
                        icon: AppIcons.deleteOutlineRounded,
                        onPressed: () async {
                          await _clearDraft();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Draft cleared')),
                            );
                          }
                        },
                        variant: AppButtonVariant.danger,
                        size: AppButtonSize.small,
                      ),
                    ),
                  ],
                ),
              ),
        */
        // Submit Button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: AppButton(
            text: _submitting ? 'Creating...' : 'Create Jobcard',
            icon: AppIcons.checkCircleRounded,
            onPressed: _submitting ? null : _submit,
            variant: AppButtonVariant.primary,
            size: AppButtonSize.large,
            fullWidth: true,
            isLoading: false,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              color: highlight
                  ? AppColors.primary
                  : (isDark ? Colors.white : const Color(0xFF1A2634)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    AppIcons.receiptRounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Jobcard Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Jobcard Number',
                  _jobcardNumberCtl.text,
                  isDark,
                ),
                _buildSummaryRow('Subject', _subjectCtl.text, isDark),
                _buildSummaryRow('Related To', _relatedTo ?? '-', isDark),
                _buildSummaryRow('Starting On', _reportedDateCtl.text, isDark),
                if (_dispatchedDateCtl.text.isNotEmpty)
                  _buildSummaryRow(
                    'Dispatched Date',
                    _dispatchedDateCtl.text,
                    isDark,
                  ),
                _buildSummaryRow(
                  'Status',
                  _supportStatuses
                          .firstWhere(
                            (s) =>
                                (int.tryParse(s['id']?.toString() ?? '') ??
                                    0) ==
                                (_statusId ?? 0),
                            orElse: () => {},
                          )['name']
                          ?.toString() ??
                      (_statusId?.toString() ?? '-'),
                  isDark,
                ),
                _buildSummaryRow(
                  'Technicians',
                  '${_technicianIds.length} selected',
                  isDark,
                ),
                if (_receiverId != null ||
                    (_receiverName != null && _receiverName!.isNotEmpty))
                  _buildSummaryRow(
                    'Receiver',
                    _receiverId != null
                        ? (_findReceiverNameById(_receiverId!) ??
                              'ID: $_receiverId')
                        : _receiverName!,
                    isDark,
                  ),
                if (_supportTicketId != null)
                  _buildSummaryRow(
                    'Support Ticket',
                    _tickets
                            .firstWhere(
                              (t) =>
                                  (int.tryParse(t['id']?.toString() ?? '') ??
                                      0) ==
                                  _supportTicketId,
                              orElse: () => {},
                            )['name']
                            ?.toString() ??
                        '-',
                    isDark,
                  ),
                if (_notesCtl.text.trim().isNotEmpty)
                  _buildSummaryRow(
                    'Recommendation',
                    _notesCtl.text.trim(),
                    isDark,
                  ),
                _buildSummaryRow('Items', '${_items.length} items', isDark),
                _buildSummaryRow(
                  'Grand Total',
                  _grandTotal.toStringAsFixed(2),
                  isDark,
                  highlight: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPreviewDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: isDark ? const Color(0xFF151A2E) : Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildSummaryCard(isDark),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Save Draft',
                          icon: AppIcons.saveOutlined,
                          onPressed: () async {
                            await _saveDraft();
                          },
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.small,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          text: 'Clear Draft',
                          icon: AppIcons.deleteOutlineRounded,
                          onPressed: () async {
                            await _clearDraft();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Draft cleared')),
                              );
                            }
                            Navigator.pop(ctx);
                          },
                          variant: AppButtonVariant.danger,
                          size: AppButtonSize.small,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        text: 'Close',
                        onPressed: () => Navigator.pop(ctx),
                        variant: AppButtonVariant.text,
                        size: AppButtonSize.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0E21)
          : const Color(0xFFF8F9FC),
      appBar: CustomAppBar(
        title: 'Create Jobcard',
        actions: [
          IconButton(
            tooltip: 'Save draft',
            icon: Icon(
              AppIcons.saveOutlined,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
            onPressed: _saveDraft,
          ),
          IconButton(
            tooltip: 'Load draft',
            icon: Icon(
              AppIcons.uploadFileRounded,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
            onPressed: () => _loadDraft(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Basic Info
            Text(
              'Basic Info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 8),
            _buildStep1(context),
            const SizedBox(height: 20),

            // Assignment
            Text(
              'Assignment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 8),
            _buildStep2(context),
            const SizedBox(height: 20),

            // Department
            Text(
              'Department',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 8),
            _buildStep3(context),
            const SizedBox(height: 20),

            // Items & Files
            Text(
              'Items & Files',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 8),
            _buildStep4(context),
            const SizedBox(height: 20),

            // Review
            Text(
              'Review',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 8),
            _buildStep5(context),
          ],
        ),
      ),
    );
  }
}
