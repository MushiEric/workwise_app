import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:workwise_erp/core/widgets/app_textfields.dart';
import 'package:workwise_erp/core/themes/app_icons.dart';
import 'package:workwise_erp/core/widgets/app_smart_dropdown.dart';

import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/support_create_params.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/support_category.dart';
import '../../domain/entities/support_location.dart';
import '../../domain/entities/support_supervisor.dart';
import '../../domain/entities/support_service.dart';
import '../../domain/entities/support_department.dart';
import '../../domain/entities/status.dart';
import '../../domain/entities/assigned_user.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/domain/entities/customer_contact.dart';
import '../../../auth/domain/entities/user.dart';
import '../providers/support_providers.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/widgets/app_bar.dart';
import '../../../../../core/widgets/app_button.dart';
import 'package:workwise_erp/features/jobcard/presentation/widgets/searchable_dialog.dart';
import '../../../customer/presentation/providers/customer_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class CreateTicketPage extends ConsumerStatefulWidget {
  final SupportTicket? ticket; // null = create, non-null = edit
  const CreateTicketPage({super.key, this.ticket});

  @override
  ConsumerState<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends ConsumerState<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _endDate;
  int? _editId;

  final List<Map<String, dynamic>> _localFiles = [];

  // Lists for dropdown data
  List<Priority> _priorities = [];
  List<SupportCategory> _categories = [];
  List<SupportLocation> _locations = [];
  List<SupportSupervisor> _supervisors = [];
  List<SupportService> _services = [];
  List<SupportDepartment> _departments = [];
  List<SupportStatus> _statuses = [];
  List<Customer> _customers = [];
  List<CustomerContact> _contacts = [];
  List<User> _users = [];

  // Selected IDs
  int? _selectedPriorityId;
  int? _selectedCategoryId;
  int? _selectedServiceId;
  int? _selectedLocationId;
  int? _selectedSupervisorId;
  int? _selectedDepartmentId;
  int? _selectedStatusId;
  int? _selectedCustomerId;

  // Multi-select lists
  final List<int> _selectedAssignees = [];
  final List<int> _selectedContactIds = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill basic fields from existing ticket (edit mode)
    final t = widget.ticket;
    if (t != null) {
      _editId = t.id;
      _subjectController.text = t.subject ?? '';
      _descriptionController.text = t.description ?? '';
      if (t.endDate != null) _endDate = DateTime.tryParse(t.endDate!);
      _selectedPriorityId = t.priority?.id;
      _selectedStatusId = t.status?.id;
      _selectedCustomerId = t.customer?.id;
      if (t.assignUser?.id != null) _selectedAssignees.add(t.assignUser!.id!);
    }
    _loadMetaData();
  }

  Future<void> _loadMetaData() async {
    try {
      // Load priorities
      final getPriorities = ref.read(getSupportPrioritiesUseCaseProvider);
      final pRes = await getPriorities.call();
      pRes.fold((_) => null, (list) => _priorities = list);

      // Load categories
      final getCats = ref.read(getSupportCategoriesUseCaseProvider);
      final cRes = await getCats.call();
      cRes.fold((_) => null, (list) => _categories = list);

      // Load locations
      final getLoc = ref.read(getSupportLocationsUseCaseProvider);
      final lRes = await getLoc.call();
      lRes.fold((_) => null, (list) => _locations = list);

      // Load supervisors
      final getSup = ref.read(getSupportSupervisorsUseCaseProvider);
      final sRes = await getSup.call();
      sRes.fold((_) => null, (list) => _supervisors = list);

      // Load services
      final getServices = ref.read(getSupportServicesUseCaseProvider);
      final svcRes = await getServices.call();
      svcRes.fold((_) => null, (list) => _services = list);

      // Load departments
      final getDepts = ref.read(getSupportDepartmentsUseCaseProvider);
      final dRes = await getDepts.call();
      dRes.fold((_) => null, (list) => _departments = list);

      // Load statuses
      final getStatuses = ref.read(getSupportStatusesUseCaseProvider);
      final stRes = await getStatuses.call();
      stRes.fold((_) => null, (list) => _statuses = list);

      // Load customers
      final getCustomers = ref.read(getCustomersUseCaseProvider);
      final custRes = await getCustomers.call();
      custRes.fold((_) => null, (list) => _customers = list);

      // Load users for assignees
      final getUsers = ref.read(getUsersUseCaseProvider);
      final uRes = await getUsers.call();
      uRes.fold((_) => null, (list) => _users = list);

      if (mounted) {
        // Match name-based fields from existing ticket (edit mode)
        final t = widget.ticket;
        if (t != null) {
          if (t.category != null) {
            final match = _categories
                .where((c) => c.name == t.category)
                .firstOrNull;
            if (match != null) _selectedCategoryId = match.id;
          }
          if (t.location != null) {
            final match = _locations
                .where((l) => l.name == t.location)
                .firstOrNull;
            if (match != null) _selectedLocationId = match.id;
          }
          if (t.department != null) {
            final match = _departments
                .where((d) => d.name == t.department)
                .firstOrNull;
            if (match != null) _selectedDepartmentId = match.id;
          }
          if (t.services != null && t.services!.isNotEmpty) {
            final match = _services
                .where((s) => s.name == t.services!.first)
                .firstOrNull;
            if (match != null) _selectedServiceId = match.id;
          }
          if (t.supervisors != null && t.supervisors!.isNotEmpty) {
            final match = _supervisors
                .where((s) => s.user?.name == t.supervisors!.first)
                .firstOrNull;
            if (match != null) _selectedSupervisorId = match.user?.id;
          }
          if (_selectedCustomerId != null) {
            _loadCustomerContacts(_selectedCustomerId!);
          }
        }
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading metadata: $e');
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    setState(() {
      for (final f in result.files) {
        _localFiles.add({
          'name': f.name,
          'size': _humanFileSize(f.size),
          'path': f.path,
          'bytes': f.bytes,
        });
      }
    });
  }

  Future<void> _loadCustomerContacts(int customerId) async {
    try {
      final getContacts = ref.read(getCustomerContactsUseCaseProvider);
      final res = await getContacts.call(customerId);
      res.fold(
        (_) => setState(() => _contacts = []),
        (list) => setState(() => _contacts = list),
      );
    } catch (e) {
      debugPrint('Error loading contacts: $e');
    }
  }

  String _humanFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final params = SupportCreateParams(
      id: _editId,
      subject: _subjectController.text.trim(),
      priorityId: _selectedPriorityId,
      endDate: _endDate?.toIso8601String().split('T').first,
      description: _descriptionController.text.trim(),
      assignees: _selectedAssignees.isNotEmpty ? _selectedAssignees : null,
      serviceId: _selectedServiceId,
      categoryId: _selectedCategoryId,
      locationId: _selectedLocationId,
      supervisorId: _selectedSupervisorId,
      departmentId: _selectedDepartmentId,
      statusId: _selectedStatusId,
      customerId: _selectedCustomerId,
      customerName: _selectedCustomerId != null
          ? _customers
              .firstWhere(
                (c) => c.id == _selectedCustomerId,
                orElse: () => Customer(id: null, name: null),
              )
              .name
          : null,
      contactIds: _selectedContactIds.isNotEmpty ? _selectedContactIds : null,
      files: _localFiles.isNotEmpty
          ? _localFiles.map((e) => e['path'] as String).toList()
          : null,
      userId: ref
          .read(authNotifierProvider)
          .maybeWhen(authenticated: (u) => u.id, orElse: () => null),
    );

    final createUc = ref.read(createSupportTicketUseCaseProvider);
    final res = await createUc.call(params);

    if (!mounted) return;

    res.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red.shade400,
                  size: 20.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Failed: ${failure.message}',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade50,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.r),
          ),
        );
        setState(() => _isSubmitting = false);
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green.shade400,
                  size: 20.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    _editId != null
                        ? 'Ticket updated successfully'
                        : 'Ticket created successfully',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade50,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.r),
          ),
        );

        Navigator.pop(context, true);
      },
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  Widget _buildAssigneesSection({
    required bool isDark,
    required Color primary,
    required BuildContext context,
  }) {
    final displayText = _selectedAssignees.isEmpty
        ? ''
        : _selectedAssignees.length == 1
        ? _users
                  .firstWhere(
                    (u) => u.id == _selectedAssignees.first,
                    orElse: () => User(name: 'Unknown'),
                  )
                  .name ??
              'Unknown'
        : '${_selectedAssignees.length} selected';

    return AppTextField(
      controller: TextEditingController(text: displayText),
      label: 'Assignees',
      hintText: 'Select assignees',
      isDropdown: true,
      onDropdownTap: () async {
        final initial = _users
            .where((u) => _selectedAssignees.contains(u.id))
            .toList();
        await showDialog(
          context: context,
          builder: (ctx) => SearchableDialog<User>(
            title: 'Select Assignees',
            items: _users,
            itemDisplay: (u) => u.name ?? '',
            multiSelect: true,
            initialMultiValue: initial,
            onMultiSelected: (selected) {
              setState(() {
                _selectedAssignees.clear();
                _selectedAssignees.addAll(
                  selected.map((u) => u.id ?? -1).where((id) => id != -1),
                );
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildContactsSection({
    required bool isDark,
    required Color primary,
    required BuildContext context,
  }) {
    final displayText = _selectedContactIds.isEmpty
        ? ''
        : _selectedContactIds.length == 1
        ? _contacts
                  .firstWhere(
                    (c) => c.id == _selectedContactIds.first,
                    orElse: () => CustomerContact(name: 'Unknown'),
                  )
                  .name ??
              'Unknown'
        : '${_selectedContactIds.length} selected';

    return AppTextField(
      controller: TextEditingController(text: displayText),
      label: 'Contacts',
      hintText: 'Select contacts',
      isDropdown: true,
      onDropdownTap: () async {
        if (_selectedCustomerId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a customer first'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        final initial = _contacts
            .where((c) => _selectedContactIds.contains(c.id))
            .toList();
        await showDialog(
          context: context,
          builder: (ctx) => SearchableDialog<CustomerContact>(
            title: 'Select Contacts',
            items: _contacts,
            itemDisplay: (c) => c.name ?? '',
            multiSelect: true,
            initialMultiValue: initial,
            onMultiSelected: (selected) {
              setState(() {
                _selectedContactIds.clear();
                _selectedContactIds.addAll(
                  selected.map((c) => c.id ?? -1).where((id) => id != -1),
                );
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildEndDateSection({required bool isDark, required Color primary}) {
    final displayDate = _endDate == null ? '' : _endDate!.toLocal().toString().split(' ')[0];
    return AppTextField(
      controller: TextEditingController(text: displayDate),
      label: 'End Date',
      hintText: 'Select date',
      readOnly: true,
      prefixIcon: Icon(AppIcons.eventRounded, size: 18),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _endDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: primary,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() => _endDate = picked);
        }
      },
    );
  }

  Widget _buildAttachmentsSection({
    required bool isDark,
    required Color primary,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attachments',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : const Color(0xFF374151),
                  letterSpacing: 0.3,
                ),
              ),
              if (_localFiles.isNotEmpty)
                Text(
                  '${_localFiles.length} file(s)',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),

        // Items list
        if (_localFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _localFiles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final f = _localFiles[i];
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
                    children: [
                      Icon(_getFileIcon(f['name']), size: 20, color: primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f['name'] ?? 'File',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A2634),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (f['size'] != null)
                              Text(
                                f['size'] ?? '',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey.shade500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _localFiles.removeAt(i)),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: Colors.red.shade400,
                        ),
                        splashRadius: 20,
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
          ),

        // Add Button
        InkWell(
          onTap: _pickFiles,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : AppColors.greyFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.attach_file_rounded,
                  size: 18,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  _localFiles.isEmpty ? 'Add Attachment' : 'Add another file',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                  ),
                ),
                const Spacer(),
                if (_localFiles.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_localFiles.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getFileIcon(String? fileName) {
    if (fileName == null) return Icons.insert_drive_file_rounded;
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image_rounded;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.video_file_rounded;
      case 'mp3':
      case 'wav':
        return Icons.audio_file_rounded;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.archive_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0E21)
          : AppColors.white,
      appBar: CustomAppBar(
        title: _editId != null ? 'Edit Ticket' : 'Create Ticket',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Subject ──────────────────────────────────────────────
              AppTextField(
                controller: _subjectController,
                label: 'Subject',
                
                validator: (v) =>
                    v?.trim().isEmpty == true ? 'Subject is required' : null,
              ),

              SizedBox(height: 8.h),

              // ── Customer ─────────────────────────────────────────────
              AppSmartDropdown<int>(
                value: _selectedCustomerId,
                items: _customers
                    .map((c) => c.id)
                    .whereType<int>()
                    .toList(),
                itemBuilder: (id) {
                  final c = _customers.firstWhere(
                    (c) => c.id == id,
                    orElse: () => Customer(id: id, name: 'Customer $id'),
                  );
                  return c.name ?? 'Customer $id';
                },
                label: 'Customer',
                hintText: 'Select customer',
                enabled: _customers.isNotEmpty,

                borderRadius: 12,
                onChanged: (id) {
                  setState(() {
                    _selectedCustomerId = id;
                    _selectedContactIds.clear();
                  });
                  if (id != null) {
                    _loadCustomerContacts(id);
                  }
                },
              ),

              SizedBox(height: 8.h),

              // ── Contacts ─────────────────────────────────────────────
              _buildContactsSection(
                isDark: isDark,
                primary: primary,
                context: context,
              ),

              SizedBox(height: 8.h),

              // ── Priority ─────────────────────────────────────────────
              AppSmartDropdown<int>(
                value: _selectedPriorityId,
                items: _priorities.map((p) => p.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final p = _priorities.firstWhere(
                    (p) => p.id == id,
                    orElse: () => Priority(id: id, priority: 'Priority $id'),
                  );
                  return p.priority ?? 'Priority $id';
                },
                label: 'Priority',
                hintText: 'Select priority',
                enabled: _priorities.isNotEmpty,

                borderRadius: 12,
                onChanged: (id) => setState(() => _selectedPriorityId = id),
              ),

              SizedBox(height: 8.h),

              // ── Category ─────────────────────────────────────────────
              AppSmartDropdown<int>(
                value: _selectedCategoryId,
                items: _categories.map((c) => c.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final c = _categories.firstWhere(
                    (c) => c.id == id,
                    orElse: () =>
                        SupportCategory(id: id, name: 'Category $id'),
                  );
                  return c.name ?? 'Category $id';
                },
                label: 'Category',
                hintText: 'Select category',
                enabled: _categories.isNotEmpty,

                borderRadius: 12,
                onChanged: (id) => setState(() => _selectedCategoryId = id),
              ),

              SizedBox(height: 8.h),

              // ── Service ──────────────────────────────────────────────
              AppSmartDropdown<int>(
                value: _selectedServiceId,
                items: _services.map((s) => s.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final s = _services.firstWhere(
                    (s) => s.id == id,
                    orElse: () => SupportService(id: id, name: 'Service $id'),
                  );
                  return s.name ?? 'Service $id';
                },
                label: 'Service',
                hintText: 'Select service',
                enabled: _services.isNotEmpty,

                borderRadius: 12,
                onChanged: (id) => setState(() => _selectedServiceId = id),
              ),

              SizedBox(height: 8.h),

              // ── Department ─────────────────────────────────────────────
              AppSmartDropdown<int>(
                value: _selectedDepartmentId,
                items: _departments.map((d) => d.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final d = _departments.firstWhere(
                    (d) => d.id == id,
                    orElse: () => SupportDepartment(id: id, name: 'Department $id'),
                  );
                  return d.name ?? 'Department $id';
                },
                label: 'Department',
                hintText: 'Select department',
                enabled: _departments.isNotEmpty,

                borderRadius: 12,
                onChanged: (id) => setState(() => _selectedDepartmentId = id),
              ),

              SizedBox(height: 8.h),

              // ── Status ─────────────────────────────────────────────
              AppSmartDropdown<int>(
                value: _selectedStatusId,
                items: _statuses.map((s) => s.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final s = _statuses.firstWhere(
                    (s) => s.id == id,
                    orElse: () => SupportStatus(id: id, status: 'Status $id'),
                  );
                  return s.status ?? 'Status $id';
                },
                label: 'Status',
                hintText: 'Select status',
                enabled: _statuses.isNotEmpty,

                borderRadius: 12,
                onChanged: (id) => setState(() => _selectedStatusId = id),
              ),

              SizedBox(height: 8.h),

              // ── Assignees ────────────────────────────────────────────
              _buildAssigneesSection(
                isDark: isDark,
                primary: primary,
                context: context,
              ),

              SizedBox(height: 8.h),

              // ── Supervisor ─────────────────────────────────────────────
              AppSmartDropdown<int>(
                value: _selectedSupervisorId,
                items: _supervisors
                    .map((s) => s.user?.id)
                    .whereType<int>()
                    .toList(),
                itemBuilder: (id) {
                  final s = _supervisors.firstWhere(
                    (s) => s.user?.id == id,
                    orElse: () =>
                        SupportSupervisor(user: AssignedUser(id: id, name: 'Supervisor $id')),
                  );
                  return s.user?.name ?? 'Supervisor $id';
                },
                label: 'Supervisor',
                hintText: 'Select supervisor',
                enabled: _supervisors.isNotEmpty,

                borderRadius: 12,
                onChanged: (id) => setState(() => _selectedSupervisorId = id),
              ),

              SizedBox(height: 8.h),

              // ── Location ─────────────────────────────────────────────
              AppSmartDropdown<int>(
                value: _selectedLocationId,
                items: _locations.map((l) => l.id).whereType<int>().toList(),
                itemBuilder: (id) {
                  final l = _locations.firstWhere(
                    (l) => l.id == id,
                    orElse: () => SupportLocation(id: id, name: 'Location $id'),
                  );
                  return l.name ?? 'Location $id';
                },
                label: 'Location',
                hintText: 'Select location',
                enabled: _locations.isNotEmpty,

                borderRadius: 12,
                onChanged: (id) => setState(() => _selectedLocationId = id),
              ),

              SizedBox(height: 8.h),

              // ── End Date ─────────────────────────────────────────────
              _buildEndDateSection(isDark: isDark, primary: primary),

              SizedBox(height: 8.h),

              AppTextField(
                controller: _descriptionController,
                label: 'Description',
                minLines: 1,
                maxLines: 3,
              ),

              SizedBox(height: 8.h),

              // ── Attachments ──────────────────────────────────────────
              _buildAttachmentsSection(isDark: isDark, primary: primary),

            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: AppButton.primary(
            text: _editId != null ? 'Save Changes' : 'Create Ticket',
            onPressed: _isSubmitting ? null : _submit,
            isLoading: _isSubmitting,
            isSticky: true,
          ),
        ),
      ),
    );
  }
}
