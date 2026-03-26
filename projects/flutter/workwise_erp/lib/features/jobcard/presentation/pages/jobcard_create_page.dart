import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workwise_erp/core/provider/permission_provider.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';
import 'package:workwise_erp/core/widgets/app_textfields.dart';
import 'package:workwise_erp/core/widgets/app_smart_dropdown.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../../domain/entities/jobcard_create_params.dart';
import '../../domain/entities/jobcard_detail.dart';
import '../providers/jobcard_providers.dart';
import '../../../support/presentation/providers/support_providers.dart';
import '../../../support/domain/entities/support_ticket.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/technician_selector.dart';
import '../widgets/items_list.dart';
import '../../../../core/themes/app_icons.dart';

class JobcardCreatePage extends ConsumerStatefulWidget {
  /// When provided the page operates in edit mode, pre-filling all fields
  /// from the existing jobcard.
  final JobcardDetail? existingJobcard;

  /// When provided, the page opens in "create from ticket" mode, pre-filling
  /// subject, customer and support ticket ID from the given ticket.
  final SupportTicket? fromTicket;

  const JobcardCreatePage({super.key, this.existingJobcard, this.fromTicket});

  @override
  ConsumerState<JobcardCreatePage> createState() => _JobcardCreatePageState();
}

class _JobcardCreatePageState extends ConsumerState<JobcardCreatePage>
    with SingleTickerProviderStateMixin {
  final _subjectCtl = TextEditingController();
  final _jobcardNumberCtl = TextEditingController();
  final _reportedDateCtl = TextEditingController();
  final _dispatchedDateCtl = TextEditingController();

  // Edit mode — set when widget.existingJobcard is non-null
  int? _editId;

  String? _relatedTo = 'Customer';
  int? _vehicleId;
  List<int> _technicianIds = [];
  int? _receiverId;
  String? _receiverType;
  String? _receiverName; // manual "Other" or explicit receiver name
  int? _statusId;
  int? _supervisorId;
  int? _locationId;
  int? _departmentId;
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

  // Cached futures for FutureBuilder dropdowns (prevents re-firing on rebuild)
  Future<dynamic>? _supervisorFuture;
  Future<dynamic>? _departmentFuture;
  Future<dynamic>? _locationFuture;

  bool _submitting = false;
  bool _showMoreOptional = false;
  bool _generatingNumber = false;
  final _descriptionCtl = TextEditingController(); // Summary of Tasks

  // Field-level validation errors (shown inline, not via snackbar)
  String? _numError;
  String? _subjectError;
  String? _dateError;
  String? _statusError;
  String? _staffError;

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

    // Pre-fill today's date as Starting On
    _reportedDateCtl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Cache futures for FutureBuilder dropdowns so they don't re-fire on every rebuild
    _supervisorFuture = ref.read(getSupportSupervisorsUseCaseProvider).call();
    _departmentFuture = ref.read(getSupportDepartmentsUseCaseProvider).call();
    _locationFuture = ref.read(getSupportLocationsUseCaseProvider).call();

    // Pre-fill from existing jobcard (edit mode)
    final existing = widget.existingJobcard;
    if (existing != null) {
      _editId = existing.id;
      _jobcardNumberCtl.text = existing.jobcardNumber ?? '';
      _subjectCtl.text = existing.service ?? '';
      _reportedDateCtl.text = existing.reportedDate ?? '';
      _dispatchedDateCtl.text = existing.dispatchedDate ?? '';
      _relatedTo = existing.relatedTo?.isNotEmpty == true
          ? existing.relatedTo
          : 'Customer';
      _descriptionCtl.text = existing.description ?? '';
      _notesCtl.text = existing.notes ?? '';
      _items = List<Map<String, dynamic>>.from(existing.items ?? []);
      _grandTotal = num.tryParse(existing.grandTotal?.toString() ?? '') ?? 0;

      // Parse technician IDs from stringified JSON array
      final rawTech = existing.technicianId ?? '[]';
      final cleanTech = rawTech.replaceAll(RegExp(r'[\[\]"\\]'), '').trim();
      if (cleanTech.isNotEmpty && cleanTech != 'null') {
        _technicianIds = cleanTech
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .whereType<int>()
            .toList();
      }
      // Parse department ID(s)
      final rawDepts = existing.departments ?? '[]';
      final cleanDepts = rawDepts.replaceAll(RegExp(r'[\[\]" ]'), '').trim();
      if (cleanDepts.isNotEmpty && cleanDepts != 'null') {
        final ids = cleanDepts
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .whereType<int>()
            .toList();
        if (ids.isNotEmpty) _departmentId = ids.first;
      }
      // Receiver / Vehicle
      final receiver = int.tryParse(existing.receiver?.toString() ?? '');
      if (_relatedTo == 'Vehicle') {
        _vehicleId = receiver;
      } else {
        _receiverId = receiver;
      }
      // Status
      final sr = existing.statusRow;
      if (sr != null) {
        _statusId = int.tryParse(sr['id']?.toString() ?? '');
      } else {
        _statusId = int.tryParse(existing.status?.toString() ?? '');
      }
      // Location / supervisor
      _locationId = int.tryParse(existing.location?.toString() ?? '');
      _supervisorId = int.tryParse(existing.supervisor?.toString() ?? '');
    }

    // Pre-fill from ticket (create-from-ticket mode)
    final ticket = widget.fromTicket;
    if (ticket != null) {
      _subjectCtl.text = ticket.subject ?? '';
      _relatedTo = 'Customer';
      _receiverId = ticket.customer?.id;
      _receiverName = ticket.customer?.name;
      _receiverType = 'customer';
      _supportTicketId = ticket.id;
    }

    _loadAuxData();
    // In edit mode or ticket mode, skip draft restore/number generation
    if (_editId == null && ticket == null) {
      _loadDraft().then((restored) {
        if (!restored) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _generateNumber(),
          );
        }
      });
    } else if (ticket != null) {
      // Generate a fresh jobcard number for the new jobcard
      WidgetsBinding.instance.addPostFrameCallback((_) => _generateNumber());
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _relatedOtherCtl.dispose();
    _notesCtl.dispose();
    _descriptionCtl.dispose();
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

    // auto-select "Open" status if none was pre-selected (e.g. from draft)
    if (_statusId == null && _supportStatuses.isNotEmpty) {
      final openStatus = _supportStatuses.firstWhere(
        (s) => (s['name'] ?? '').toString().toLowerCase() == 'open',
        orElse: () => _supportStatuses.first,
      );
      _statusId = int.tryParse(openStatus['id']?.toString() ?? '');
    }

    // support tickets (for Support Ticket dropdown)
    try {
      final tRes = await ref.read(getSupportTicketsUseCaseProvider).call();
      tRes.fold((_) => _tickets = [], (list) {
        _tickets = list.map((t) {
          final code = (t.ticketCode ?? '').trim();
          final subject = (t.subject ?? '').trim();
          final display = (code.isNotEmpty)
              ? '$code - ${subject.isNotEmpty ? subject : 'Ticket ${t.id}'}'
              : (subject.isNotEmpty ? subject : 'Ticket ${t.id}');
          return {'id': t.id, 'name': display};
        }).toList();
      });
    } catch (_) {
      _tickets = [];
    }

    // Pre-load receivers for the default relatedTo so the dropdown is ready on first render
    const receiverTypeMap = {
      'Customer': 'customer',
      'Vendor': 'vendor',
      'Users': 'user',
      'User': 'user',
      'Employee': 'user',
    };
    final defaultReceiverType = receiverTypeMap[_relatedTo];
    if (defaultReceiverType != null) {
      // When launched from a ticket the receiver ID is already set — preserve it.
      await _loadReceiversByType(
        defaultReceiverType,
        preserveReceiverId: widget.fromTicket != null,
      );
    }

    setState(() {});
  }

  /// Load receiver names for a given receiver `type` (customer, vendor, user, employee)
  /// Pass [preserveReceiverId] = true to keep the current [_receiverId] after loading.
  Future<void> _loadReceiversByType(
    String type, {
    bool preserveReceiverId = false,
  }) async {
    final previousReceiverId = _receiverId;
    setState(() {
      _receiverType = type;
      if (!preserveReceiverId) _receiverId = null;
      _receivers = [];
    });

    final result = await ref.read(getReceiversByTypeUseCaseProvider).call(type);
    result.fold(
      (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Failed to load receivers'),
            ),
          );
        }
      },
      (list) {
        if (mounted) {
          setState(() {
            _receivers = list;
            // Restore the pre-filled ID if it exists in the loaded list
            if (preserveReceiverId && previousReceiverId != null) {
              final found = list.any(
                (r) =>
                    int.tryParse(r['id']?.toString() ?? '') ==
                    previousReceiverId,
              );
              _receiverId = found ? previousReceiverId : null;
            }
          });
        }
      },
    );
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
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Failed to generate jobcard number'),
            ),
          );
        },
        (r) {
          _jobcardNumberCtl.text = r;
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Error generating jobcard number'),
          ),
        );
      }
    } finally {
      // Stop animation
      _rotationController.stop();
      if (mounted) setState(() => _generatingNumber = false);
    }
  }

  void _recalcTotal() {
    // Price is no longer collected at item entry; grand total is not tracked
    _grandTotal = 0;
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
        _departmentId = data['department_id'] != null
            ? int.tryParse(data['department_id'].toString())
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
      });
      if (!mounted) return true;
      // if draft contained receiver type we should load its options so UI can show selection
      if (_receiverType != null &&
          (_receiverType == 'user' ||
              _receiverType == 'customer' ||
              _receiverType == 'vendor' ||
              _receiverType == 'employee')) {
        // ignore: unawaited_futures
        _loadReceiversByType(_receiverType!, preserveReceiverId: true);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Draft loaded'),
        ),
      );
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
    // Validate required fields inline — highlight the field, no snackbar
    setState(() {
      _numError = _jobcardNumberCtl.text.trim().isEmpty
          ? 'Jobcard number is required'
          : null;
      _subjectError = _subjectCtl.text.trim().isEmpty
          ? 'Subject is required'
          : null;
      _dateError = _reportedDateCtl.text.trim().isEmpty
          ? 'Starting date is required'
          : null;
      _staffError = _technicianIds.isEmpty
          ? 'At least one staff member is required'
          : null;
      _statusError = _statusId == null ? 'Status is required' : null;
    });
    if (_staffError != null) {
      setState(() => _showMoreOptional = true);
    }
    if (_numError != null ||
        _subjectError != null ||
        _dateError != null ||
        _staffError != null ||
        _statusError != null) {
      return;
    }

    // validate receiver/related fields depending on `Related To`
    if (_relatedTo == 'Other') {
      if ((_receiverName ?? _relatedOtherCtl.text).trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Please enter a value for "Other"'),
          ),
        );
        return;
      }
    } else if (_relatedTo == 'Customer' ||
        _relatedTo == 'Vendor' ||
        _relatedTo == 'Users' ||
        _relatedTo == 'Employee' ||
        _relatedTo == 'User') {
      if (_receiverId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Receiver is required'),
          ),
        );
        return;
      }
    } else if (_relatedTo == 'Vehicle') {
      if (_vehicleId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Vehicle is required'),
          ),
        );
        return;
      }
    }

    final params = JobcardCreateParams(
      id: _editId,
      jobcardNumber: _jobcardNumberCtl.text.trim(),
      subject: _subjectCtl.text.trim(),
      reportedDate: _reportedDateCtl.text.trim(),
      dispatchedDate: _dispatchedDateCtl.text.trim().isEmpty
          ? null
          : _dispatchedDateCtl.text.trim(),
      vehicleId: _vehicleId,
      technicianIds: _technicianIds,
      departmentIds: _departmentId != null ? [_departmentId!] : null,
      service: _subjectCtl.text.trim().isNotEmpty
          ? _subjectCtl.text.trim()
          : null,
      description: _descriptionCtl.text.trim().isNotEmpty
          ? _descriptionCtl.text.trim()
          : null,
      notes: _notesCtl.text.trim().isNotEmpty ? _notesCtl.text.trim() : null,
      relatedTo: _relatedTo,
      receiverId: _relatedTo == 'Vehicle' ? _vehicleId : _receiverId,
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
      (l) async {
        final msg = l.toString();
        // If the backend returned status 200 but no ID, we treat it as a success.
        // The backend message is shown to the user (e.g. "Job Card entry saved successfully").
        if (msg.toLowerCase().contains('status: 200') ||
            msg.toLowerCase().contains('saved') ||
            msg.toLowerCase().contains('successfully')) {
          try {
            ref
                .read(jobcardNotifierProvider.notifier)
                .loadJobcards(force: true);
          } catch (_) {}
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(behavior: SnackBarBehavior.floating, content: Text(msg)),
          );
          Navigator.pushReplacementNamed(context, '/jobcards');
          return;
        }

        // For other errors (including duplicate number), show the backend message.
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(behavior: SnackBarBehavior.floating, content: Text(msg)),
        );
      },
      (resp) async {
        // clear saved draft
        await _clearDraft();

        // If we have an ID, navigate to detail; otherwise fallback to list.
        if (!mounted) return;

        if (resp.id != null && resp.id! > 0) {
          Navigator.of(
            context,
          ).pushReplacementNamed('/jobcards/detail', arguments: resp.id);
        } else {
          // no ID returned, just refresh list and show message if present
          try {
            ref
                .read(jobcardNotifierProvider.notifier)
                .loadJobcards(force: true);
          } catch (_) {}
          if (resp.message != null && resp.message!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(resp.message!),
              ),
            );
          }
          Navigator.pushReplacementNamed(context, '/jobcards');
        }
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

  /// Required fields — always visible at the top.
  Widget _buildCoreRequired(bool isDark) {
    // const darkBg = Color(0xFF151A2E);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Jobcard Number *
        AppTextField(
          controller: _jobcardNumberCtl,
          label: 'Jobcard Number *',
          readOnly: true,
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
        if (_numError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _numError!,
              style: TextStyle(color: Colors.red.shade400, fontSize: 12),
            ),
          ),
        // Subject *
        AppTextField(
          controller: _subjectCtl,
          label: 'Subject',
          isRequired: true,
          hintText: 'Enter subject',
          onChanged: (_) => setState(() => _subjectError = null),
        ),
        const SizedBox(height: 8),
        if (_subjectError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _subjectError!,
              style: TextStyle(color: Colors.red.shade400, fontSize: 12),
            ),
          ),
        // Starting On *
        AppTextField(
          controller: _reportedDateCtl,
          label: 'Starting On *',
          hintText: 'Select date',
          readOnly: true,
          onTap: () async {
            await _selectDate(_reportedDateCtl);
            if (_reportedDateCtl.text.isNotEmpty) {
              setState(() => _dateError = null);
            }
          },
          prefixIcon: Icon(AppIcons.eventRounded, size: 18),
        ),
        if (_dateError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _dateError!,
              style: TextStyle(color: Colors.red.shade400, fontSize: 12),
            ),
          ),
        const SizedBox(height: 8),
        AppSmartDropdown<int>(
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
          label: 'Status *',
          errorText: _statusError,

          borderRadius: 12,
          onChanged: (v) => setState(() {
            _statusId = v;
            _statusError = null;
          }),
        ),
        const SizedBox(height: 8),
        // Assigned Staff *
        TechnicianSelector(
          selectedIds: _technicianIds,
          users: _users,
          errorText: _staffError,
          onChanged: (ids) => setState(() {
            _technicianIds = ids;
            _staffError = null;
          }),
        ),
        const SizedBox(height: 8),
        // Related To *
        AppSmartDropdown<String>(
          value: _relatedTo,
          items: const [
            'Customer',
            'Vehicle',
            'Vendor',
            'Employee',
            'Users',
            'Other',
          ],
          itemBuilder: (item) => item,
          label: 'Related To *',

          borderRadius: 12,
          onChanged: (v) async {
            if (v == null) return;
            setState(() {
              _relatedTo = v;
              _receiverId = null;
              _receiverType = null;
              _receiverName = null;
            });
            if (v == 'Customer' ||
                v == 'Vendor' ||
                v == 'Users' ||
                v == 'Employee') {
              final map = {
                'Customer': 'customer',
                'Vendor': 'vendor',
                'Users': 'user',
                'Employee': 'user',
              };
              await _loadReceiversByType(map[v] ?? v.toLowerCase());
            }
          },
        ),
        const SizedBox(height: 8),
        // Receiver / Vehicle / Other *
        if (_relatedTo == 'Vehicle' && _vehicles.isNotEmpty) ...[
          AppSmartDropdown<int>(
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
            label: 'Select Vehicle *',
            borderRadius: 12,
            onChanged: (v) => setState(() => _vehicleId = v),
          ),
        ] else if (_relatedTo == 'Other') ...[
          AppTextField(
            controller: _relatedOtherCtl,
            onChanged: (v) => _receiverName = v,
            label: 'Specify (Other) *',
            hintText: 'Enter related value',
          ),
        ] else ...[
          AppSmartDropdown<int>(
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
            label: 'Select ${_relatedTo ?? 'Receiver'} *',
            enabled: _receivers.isNotEmpty,

            borderRadius: 12,
            onChanged: (v) => setState(() => _receiverId = v),
          ),
        ],
        const SizedBox(height: 16),
        // Material / Service items
        _buildStep4(context),
      ],
    );
  }

  /// Optional fields — revealed by the "Show more" button.
  Widget _buildOptionalFields(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 4),
        // Supervisor
        FutureBuilder(
          future: _supervisorFuture,
          builder: (ctx, snap) {
            if (!snap.hasData) return const SizedBox.shrink();
            return snap.data!.fold(
              (l) => const SizedBox.shrink(),
              (list) => AppSmartDropdown<int>(
                value: _supervisorId,
                items: list.map((s) => s.user?.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final s = list.firstWhere((e) => e.user?.id == id);
                  return s.user?.name ?? 'Supervisor $id';
                },
                label: 'Supervisor',

                borderRadius: 12,
                onChanged: (v) => setState(() => _supervisorId = v),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        // Department
        FutureBuilder(
          future: _departmentFuture,
          builder: (ctx, snap) {
            if (!snap.hasData) return const SizedBox.shrink();
            return snap.data!.fold(
              (l) => const SizedBox.shrink(),
              (list) => AppSmartDropdown<int>(
                value: _departmentId,
                items: list.map((d) => d.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final d = list.firstWhere((e) => e.id == id);
                  return d.name ?? 'Department $id';
                },
                label: 'Department',

                borderRadius: 12,
                onChanged: (v) => setState(() => _departmentId = v),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        // Location
        FutureBuilder(
          future: _locationFuture,
          builder: (ctx, snap) {
            if (!snap.hasData) return const SizedBox.shrink();
            return snap.data!.fold(
              (l) => const SizedBox.shrink(),
              (list) => AppSmartDropdown<int>(
                value: _locationId,
                items: list.map((d) => d.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final d = list.firstWhere((e) => e.id == id);
                  return d.name ?? 'Location $id';
                },
                label: 'Location',

                borderRadius: 12,
                onChanged: (v) => setState(() => _locationId = v),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        // Support Ticket
        AppSmartDropdown<int>(
          value: _supportTicketId,
          items: _tickets
              .map((t) => int.tryParse(t['id']?.toString() ?? '') ?? 0)
              .where((id) => id > 0)
              .toList(),
          itemBuilder: (id) {
            final t = _tickets.firstWhere(
              (e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == id,
              orElse: () => {},
            );
            return t.isNotEmpty ? (t['name'] ?? 'Ticket $id') : 'Ticket $id';
          },
          itemWidgetBuilder: (id) {
            final t = _tickets.firstWhere(
              (e) => (int.tryParse(e['id']?.toString() ?? '') ?? 0) == id,
              orElse: () => {},
            );
            if (!t.isNotEmpty) return Text('Ticket $id');

            final full = t['name']?.toString() ?? 'Ticket $id';
            final parts = full.split(' - ');
            if (parts.length < 2) return Text(full);

            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: parts[0],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' - ${parts.sublist(1).join(' - ')}'),
                ],
              ),
            );
          },
          label: 'Support Ticket',

          borderRadius: 12,
          onChanged: (v) => setState(() => _supportTicketId = v),
        ),
        const SizedBox(height: 8),
        // Completed On (dispatched date)
        AppTextField(
          controller: _dispatchedDateCtl,
          label: 'Completed On',
          hintText: 'Optional',
          readOnly: true,
          onTap: () => _selectDate(_dispatchedDateCtl),
          prefixIcon: Icon(AppIcons.eventRounded, size: 18),
        ),
        const SizedBox(height: 8),
        // Summary of Tasks (maps to `description` in params)
        AppTextField(
          controller: _descriptionCtl,
          label: 'Summary of Tasks',
          hintText: 'Optional',
          maxLines: 3,
        ),
        // Recommendation (maps to `notes` in params)
        AppTextField(
          controller: _notesCtl,
          label: 'Recommendation',
          hintText: 'Optional',
          maxLines: 3,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final checker = ref.watch(permissionCheckerProvider);
    // In create mode, the user must have the 'create job_card' permission.
    // Edit mode uses a different permission scope, so it's always allowed here.
    final canCreate =
        _editId != null || checker.hasPermission('create job_card');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : Colors.white,
      appBar: CustomAppBar(
        title: _editId != null ? 'Edit Jobcard' : 'Create Jobcard',
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Required fields (always visible) ─────────────────────
            _buildCoreRequired(isDark),
            const SizedBox(height: 4),

            // ── "Show more / fewer" toggle ────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    setState(() => _showMoreOptional = !_showMoreOptional),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_showMoreOptional ? 'Hide' : 'Show more'),
                    const SizedBox(width: 4),
                    Icon(
                      _showMoreOptional
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),

            // ── Optional fields (animated expand/collapse) ────────────
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _showMoreOptional
                  ? _buildOptionalFields(isDark)
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!canCreate)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 14,
                        color: isDark
                            ? Colors.red.shade300
                            : Colors.red.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'You don\'t have permission to create a jobcard.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.red.shade300
                              : Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              AppButton.primary(
                text: _editId != null
                    ? (_submitting ? 'Saving...' : 'Save Changes')
                    : (_submitting ? 'Creating...' : 'Create Jobcard'),
                onPressed: (_submitting || !canCreate) ? null : _submit,
                isLoading: _submitting,
                isSticky: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
