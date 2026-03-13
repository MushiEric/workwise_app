import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';

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

  /// Shared card decoration
  BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
    color: isDark ? const Color(0xFF151A2E) : Colors.white,
    borderRadius: BorderRadius.circular(16.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  /// Shared selector decoration
  InputDecoration _selectorDecoration({
    required String label,
    required IconData icon,
    required Color primary,
    required bool isDark,
  }) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: isDark ? Colors.white70 : Colors.grey.shade600,
      fontSize: 14.sp,
    ),
    prefixIcon: Icon(icon, size: 20.r, color: primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
  );

  Widget _selectorArrow(bool isDark) => Icon(
    Icons.keyboard_arrow_down_rounded,
    color: isDark ? Colors.white54 : Colors.grey.shade600,
    size: 20.r,
  );

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color primary,
    required bool isDark,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.r, color: primary),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: isDark ? Colors.white : const Color(0xFF1A2634),
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing],
      ],
    );
  }

  /// Reusable searchable-selector card
  Widget _buildSelectorCard({
    required BuildContext context,
    required bool isDark,
    required Color primary,
    required String label,
    required IconData icon,
    required String displayText,
    required bool hasValue,
    required bool isDisabled,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: _cardDecoration(isDark),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: InputDecorator(
          decoration: _selectorDecoration(
            label: label,
            icon: icon,
            primary: primary,
            isDark: isDark,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: !hasValue
                        ? (isDark ? Colors.white38 : Colors.grey.shade600)
                        : (isDark ? Colors.white : const Color(0xFF1A2634)),
                    fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _selectorArrow(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssigneesSection({
    required bool isDark,
    required Color primary,
    required BuildContext context,
  }) {
    final displayText = _selectedAssignees.isEmpty
        ? 'Select assignees'
        : _selectedAssignees.length == 1
        ? _users
                  .firstWhere(
                    (u) => u.id == _selectedAssignees.first,
                    orElse: () => User(name: 'Unknown'),
                  )
                  .name ??
              'Unknown'
        : '${_selectedAssignees.length} selected';

    return _buildSelectorCard(
      context: context,
      isDark: isDark,
      primary: primary,
      label: 'Assignees',
      icon: Icons.people_rounded,
      displayText: displayText,
      hasValue: _selectedAssignees.isNotEmpty,
      isDisabled: _users.isEmpty,
      onTap: () async {
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
        ? 'Select contacts'
        : _selectedContactIds.length == 1
        ? _contacts
                  .firstWhere(
                    (c) => c.id == _selectedContactIds.first,
                    orElse: () => CustomerContact(name: 'Unknown'),
                  )
                  .name ??
              'Unknown'
        : '${_selectedContactIds.length} selected';

    return _buildSelectorCard(
      context: context,
      isDark: isDark,
      primary: primary,
      label: 'Contacts',
      icon: Icons.contact_phone_rounded,
      displayText: displayText,
      hasValue: _selectedContactIds.isNotEmpty,
      isDisabled: _contacts.isEmpty && _selectedCustomerId == null,
      onTap: () async {
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
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration(isDark),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.event_rounded, size: 20.r, color: primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'End Date',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _endDate == null
                      ? 'Not set'
                      : _endDate!.toLocal().toString().split(' ')[0],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: _endDate == null
                        ? (isDark ? Colors.white38 : Colors.grey.shade500)
                        : (isDark ? Colors.white : const Color(0xFF1A2634)),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
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
            style: TextButton.styleFrom(
              foregroundColor: primary,
              backgroundColor: primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              minimumSize: Size(80.w, 36.h),
            ),
            child: Text(
              _endDate == null ? 'Set Date' : 'Change',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection({
    required bool isDark,
    required Color primary,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: 'Attachments',
            icon: Icons.attach_file_rounded,
            primary: primary,
            isDark: isDark,
            trailing: Text(
              '${_localFiles.length} file(s)',
              style: TextStyle(
                fontSize: 11.sp,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Compact Upload area
          InkWell(
            onTap: _pickFiles,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: primary.withOpacity(0.3),
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12.r),
                color: primary.withOpacity(0.02),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_rounded, color: primary, size: 24.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tap to add files',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                            color: isDark
                                ? Colors.white70
                                : Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          'Selected files will be uploaded',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // File list
          if (_localFiles.isNotEmpty) ...[
            SizedBox(height: 16.h),
            ..._localFiles.map(
              (f) => Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.03)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        _getFileIcon(f['name']),
                        size: 16.r,
                        color: primary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f['name'] ?? 'File',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2634),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            f['size'] ?? '',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 18.r,
                        color: Colors.red.shade300,
                      ),
                      onPressed: () => setState(() => _localFiles.remove(f)),
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
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
          : const Color(0xFFF8F9FC),
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
                labelText: 'Subject',
                prefixIcon: Icon(
                  Icons.subject_rounded,
                  size: 20.r,
                  color: primary,
                ),
                validator: (v) =>
                    v?.trim().isEmpty == true ? 'Subject is required' : null,
              ),

              SizedBox(height: 16.h),

              // ── Customer ─────────────────────────────────────────────
              _buildSelectorCard(
                context: context,
                isDark: isDark,
                primary: primary,
                label: 'Customer',
                icon: Icons.person_rounded,
                displayText: _selectedCustomerId == null
                    ? 'Select customer'
                    : (_customers
                              .firstWhere(
                                (c) => c.id == _selectedCustomerId,
                                orElse: () =>
                                    Customer(id: null, name: 'Unknown'),
                              )
                              .name ??
                          'Unknown'),
                hasValue: _selectedCustomerId != null,
                isDisabled: _customers.isEmpty,
                onTap: () async {
                  final init =
                      _customers
                          .where((c) => c.id == _selectedCustomerId)
                          .isNotEmpty
                      ? _customers.firstWhere(
                          (c) => c.id == _selectedCustomerId,
                        )
                      : null;
                  final selected = await showDialog<Customer?>(
                    context: context,
                    builder: (ctx) => SearchableDialog<Customer>(
                      title: 'Select Customer',
                      items: _customers,
                      itemDisplay: (c) => c.name ?? '',
                      initialValue: init,
                      onSelected: (c) => c,
                    ),
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedCustomerId = selected.id;
                      _selectedContactIds
                          .clear(); // Reset contacts when customer changes
                    });
                    if (selected.id != null) {
                      _loadCustomerContacts(selected.id!);
                    }
                  }
                },
              ),

              SizedBox(height: 16.h),

              // ── Contacts ─────────────────────────────────────────────
              _buildContactsSection(
                isDark: isDark,
                primary: primary,
                context: context,
              ),

              SizedBox(height: 16.h),

              // ── Priority ─────────────────────────────────────────────
              _buildSelectorCard(
                context: context,
                isDark: isDark,
                primary: primary,
                label: 'Priority',
                icon: Icons.priority_high_rounded,
                displayText: _selectedPriorityId == null
                    ? 'Select priority'
                    : (_priorities
                              .firstWhere(
                                (p) => p.id == _selectedPriorityId,
                                orElse: () =>
                                    Priority(id: null, priority: 'Unknown'),
                              )
                              .priority ??
                          'Unknown'),
                hasValue: _selectedPriorityId != null,
                isDisabled: _priorities.isEmpty,
                onTap: () async {
                  final init =
                      _priorities
                          .where((p) => p.id == _selectedPriorityId)
                          .isNotEmpty
                      ? _priorities.firstWhere(
                          (p) => p.id == _selectedPriorityId,
                        )
                      : null;
                  final selected = await showDialog<Priority?>(
                    context: context,
                    builder: (ctx) => SearchableDialog<Priority>(
                      title: 'Select Priority',
                      items: _priorities,
                      itemDisplay: (p) => p.priority ?? '',
                      initialValue: init,
                      onSelected: (p) => p,
                    ),
                  );
                  if (selected != null) {
                    setState(() => _selectedPriorityId = selected.id);
                  }
                },
              ),

              SizedBox(height: 16.h),

              // ── Category ─────────────────────────────────────────────
              _buildSelectorCard(
                context: context,
                isDark: isDark,
                primary: primary,
                label: 'Category',
                icon: Icons.category_rounded,
                displayText: _selectedCategoryId == null
                    ? 'Select category'
                    : (_categories
                              .firstWhere(
                                (c) => c.id == _selectedCategoryId,
                                orElse: () =>
                                    SupportCategory(id: null, name: 'Unknown'),
                              )
                              .name ??
                          'Unknown'),
                hasValue: _selectedCategoryId != null,
                isDisabled: _categories.isEmpty,
                onTap: () async {
                  final init =
                      _categories
                          .where((c) => c.id == _selectedCategoryId)
                          .isNotEmpty
                      ? _categories.firstWhere(
                          (c) => c.id == _selectedCategoryId,
                        )
                      : null;
                  final selected = await showDialog<SupportCategory?>(
                    context: context,
                    builder: (ctx) => SearchableDialog<SupportCategory>(
                      title: 'Select Category',
                      items: _categories,
                      itemDisplay: (c) => c.name ?? '',
                      initialValue: init,
                      onSelected: (c) => c,
                    ),
                  );
                  if (selected != null) {
                    setState(() => _selectedCategoryId = selected.id);
                  }
                },
              ),

              SizedBox(height: 16.h),

              // ── Service ──────────────────────────────────────────────
              _buildSelectorCard(
                context: context,
                isDark: isDark,
                primary: primary,
                label: 'Service',
                icon: Icons.build_rounded,
                displayText: _selectedServiceId == null
                    ? 'Select service'
                    : (_services
                              .firstWhere(
                                (s) => s.id == _selectedServiceId,
                                orElse: () =>
                                    SupportService(id: null, name: 'Unknown'),
                              )
                              .name ??
                          'Unknown'),
                hasValue: _selectedServiceId != null,
                isDisabled: _services.isEmpty,
                onTap: () async {
                  final init =
                      _services
                          .where((s) => s.id == _selectedServiceId)
                          .isNotEmpty
                      ? _services.firstWhere((s) => s.id == _selectedServiceId)
                      : null;
                  final selected = await showDialog<SupportService?>(
                    context: context,
                    builder: (ctx) => SearchableDialog<SupportService>(
                      title: 'Select Service',
                      items: _services,
                      itemDisplay: (s) => s.name ?? '',
                      initialValue: init,
                      onSelected: (s) => s,
                    ),
                  );
                  if (selected != null) {
                    setState(() => _selectedServiceId = selected.id);
                  }
                },
              ),

              SizedBox(height: 16.h),

              // ── Department ─────────────────────────────────────────────
              _buildSelectorCard(
                context: context,
                isDark: isDark,
                primary: primary,
                label: 'Department',
                icon: Icons.business_rounded,
                displayText: _selectedDepartmentId == null
                    ? 'Select department'
                    : (_departments
                              .firstWhere(
                                (d) => d.id == _selectedDepartmentId,
                                orElse: () => const SupportDepartment(
                                  id: null,
                                  name: 'Unknown',
                                ),
                              )
                              .name ??
                          'Unknown'),
                hasValue: _selectedDepartmentId != null,
                isDisabled: _departments.isEmpty,
                onTap: () async {
                  final init =
                      _departments
                          .where((d) => d.id == _selectedDepartmentId)
                          .isNotEmpty
                      ? _departments.firstWhere(
                          (d) => d.id == _selectedDepartmentId,
                        )
                      : null;
                  final selected = await showDialog<SupportDepartment?>(
                    context: context,
                    builder: (ctx) => SearchableDialog<SupportDepartment>(
                      title: 'Select Department',
                      items: _departments,
                      itemDisplay: (d) => d.name ?? '',
                      initialValue: init,
                      onSelected: (d) => d,
                    ),
                  );
                  if (selected != null) {
                    setState(() => _selectedDepartmentId = selected.id);
                  }
                },
              ),

              SizedBox(height: 16.h),

              // ── Status ─────────────────────────────────────────────
              _buildSelectorCard(
                context: context,
                isDark: isDark,
                primary: primary,
                label: 'Status',
                icon: Icons.flag_rounded,
                displayText: _selectedStatusId == null
                    ? 'Select status'
                    : (_statuses
                              .firstWhere(
                                (s) => s.id == _selectedStatusId,
                                orElse: () => const SupportStatus(
                                  id: null,
                                  status: 'Unknown',
                                ),
                              )
                              .status ??
                          'Unknown'),
                hasValue: _selectedStatusId != null,
                isDisabled: _statuses.isEmpty,
                onTap: () async {
                  final init =
                      _statuses
                          .where((s) => s.id == _selectedStatusId)
                          .isNotEmpty
                      ? _statuses.firstWhere((s) => s.id == _selectedStatusId)
                      : null;
                  final selected = await showDialog<SupportStatus?>(
                    context: context,
                    builder: (ctx) => SearchableDialog<SupportStatus>(
                      title: 'Select Status',
                      items: _statuses,
                      itemDisplay: (s) => s.status ?? '',
                      initialValue: init,
                      onSelected: (s) => s,
                    ),
                  );
                  if (selected != null) {
                    setState(() => _selectedStatusId = selected.id);
                  }
                },
              ),

              SizedBox(height: 16.h),

              // ── Assignees ────────────────────────────────────────────
              _buildAssigneesSection(
                isDark: isDark,
                primary: primary,
                context: context,
              ),

              SizedBox(height: 16.h),

              // ── Supervisor ─────────────────────────────────────────────
              _buildSelectorCard(
                context: context,
                isDark: isDark,
                primary: primary,
                label: 'Supervisor',
                icon: Icons.supervisor_account_rounded,
                displayText: _selectedSupervisorId == null
                    ? 'Select supervisor'
                    : (_supervisors
                              .firstWhere(
                                (s) => s.user?.id == _selectedSupervisorId,
                                orElse: () => SupportSupervisor(
                                  user: AssignedUser(id: null, name: 'Unknown'),
                                ),
                              )
                              .user
                              ?.name ??
                          'Unknown'),
                hasValue: _selectedSupervisorId != null,
                isDisabled: _supervisors.isEmpty,
                onTap: () async {
                  final init =
                      _supervisors
                          .where((s) => s.user?.id == _selectedSupervisorId)
                          .isNotEmpty
                      ? _supervisors.firstWhere(
                          (s) => s.user?.id == _selectedSupervisorId,
                        )
                      : null;
                  final selected = await showDialog<SupportSupervisor?>(
                    context: context,
                    builder: (ctx) => SearchableDialog<SupportSupervisor>(
                      title: 'Select Supervisor',
                      items: _supervisors,
                      itemDisplay: (s) => s.user?.name ?? '',
                      initialValue: init,
                      onSelected: (s) => s,
                    ),
                  );
                  if (selected != null) {
                    setState(() => _selectedSupervisorId = selected.user?.id);
                  }
                },
              ),

              SizedBox(height: 16.h),

              // ── Location ─────────────────────────────────────────────
              _buildSelectorCard(
                context: context,
                isDark: isDark,
                primary: primary,
                label: 'Location',
                icon: Icons.location_on_rounded,
                displayText: _selectedLocationId == null
                    ? 'Select location'
                    : (_locations
                              .firstWhere(
                                (l) => l.id == _selectedLocationId,
                                orElse: () =>
                                    SupportLocation(id: null, name: 'Unknown'),
                              )
                              .name ??
                          'Unknown'),
                hasValue: _selectedLocationId != null,
                isDisabled: _locations.isEmpty,
                onTap: () async {
                  final init =
                      _locations
                          .where((l) => l.id == _selectedLocationId)
                          .isNotEmpty
                      ? _locations.firstWhere(
                          (l) => l.id == _selectedLocationId,
                        )
                      : null;
                  final selected = await showDialog<SupportLocation?>(
                    context: context,
                    builder: (ctx) => SearchableDialog<SupportLocation>(
                      title: 'Select Location',
                      items: _locations,
                      itemDisplay: (l) => l.name ?? '',
                      initialValue: init,
                      onSelected: (l) => l,
                    ),
                  );
                  if (selected != null) {
                    setState(() => _selectedLocationId = selected.id);
                  }
                },
              ),

              SizedBox(height: 16.h),

              // ── End Date ─────────────────────────────────────────────
              _buildEndDateSection(isDark: isDark, primary: primary),

              SizedBox(height: 16.h),

              // ── Description ──────────────────────────────────────────
              AppTextField(
                controller: _descriptionController,
                labelText: 'Description',
                prefixIcon: Icon(
                  Icons.description_rounded,
                  size: 20.r,
                  color: primary,
                ),
                maxLines: 6,
              ),

              SizedBox(height: 16.h),

              // ── Attachments ──────────────────────────────────────────
              _buildAttachmentsSection(isDark: isDark, primary: primary),

              SizedBox(height: 24.h),

              SizedBox(height: 20.h),
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
