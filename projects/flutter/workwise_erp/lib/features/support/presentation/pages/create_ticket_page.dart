import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';

import '../../domain/entities/support_create_params.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/support_category.dart';
import '../../domain/entities/support_location.dart';
import '../../domain/entities/support_supervisor.dart';
import '../providers/support_providers.dart';
import '../../domain/entities/support_service.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/widgets/app_bar.dart';
import '../../../jobcard/presentation/widgets/searchable_dialog.dart';

class CreateTicketPage extends ConsumerStatefulWidget {
  const CreateTicketPage({super.key});

  @override
  ConsumerState<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends ConsumerState<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _endDate;

  List<Map<String, dynamic>> _localFiles = [];

  List<Priority> _priorities = [];
  List<SupportCategory> _categories = [];
  List<SupportLocation> _locations = [];
  List<SupportSupervisor> _supervisors = [];
  List<SupportService> _services = []; 

  int? _selectedPriorityId;
  int? _selectedCategoryId;
  int? _selectedServiceId;
  int? _selectedLocationId;
  int? _selectedSupervisorId;
  final List<int> _selectedAssignees = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    try {
      final getPriorities = ref.read(getSupportPrioritiesUseCaseProvider);
      final pRes = await getPriorities.call();
      pRes.fold((_) => null, (list) => setState(() => _priorities = list));

      final getCats = ref.read(getSupportCategoriesUseCaseProvider);
      final cRes = await getCats.call();
      cRes.fold((_) => null, (list) => setState(() => _categories = list));

      final getLoc = ref.read(getSupportLocationsUseCaseProvider);
      final lRes = await getLoc.call();
      lRes.fold((_) => null, (list) => setState(() => _locations = list));

      final getSup = ref.read(getSupportSupervisorsUseCaseProvider);
      final sRes = await getSup.call();
      sRes.fold((_) => null, (list) => setState(() => _supervisors = list));

      final getServices = ref.read(getSupportServicesUseCaseProvider);
      final svcRes = await getServices.call();
      svcRes.fold((_) => null, (list) => setState(() => _services = list));
    } catch (_) {}
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() {
      for (final f in result.files) {
        _localFiles.add({
          'name': f.name,
          'size': f.size != null ? _humanFileSize(f.size) : 'Unknown',
          'path': f.path,
        });
      }
    });
  }

  String _humanFileSize(int? bytes) {
    if (bytes == null) return 'Unknown size';
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
      subject: _subjectController.text.trim(),
      priorityId: _selectedPriorityId,
      endDate: _endDate != null ? _endDate!.toIso8601String().split('T').first : null,
      description: _descriptionController.text.trim(),
      assignees: _selectedAssignees.isNotEmpty ? _selectedAssignees : null,
      serviceId: _selectedServiceId,
      categoryId: _selectedCategoryId,
      locationId: _selectedLocationId,
      supervisorId: _selectedSupervisorId,
      attachmentPaths: _localFiles.isNotEmpty ? [_localFiles.first['path'] as String] : null,
      files: _localFiles.length > 1 ? _localFiles.skip(1).map((e) => e['path'] as String).toList() : null,
    );

    final createUc = ref.read(createSupportTicketUseCaseProvider);
    final res = await createUc.call(params);

    res.fold((failure) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text('Failed: ${failure.message}')),
            ],
          ),
          backgroundColor: Colors.red.shade50,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      setState(() => _isSubmitting = false);
    }, (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green.shade400, size: 20),
              const SizedBox(width: 12),
              const Expanded(child: Text('Ticket created successfully')),
            ],
          ),
          backgroundColor: Colors.green.shade50,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      // refresh list
      try {
        ref.read(supportNotifierProvider.notifier).loadTickets();
      } catch (_) {}
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
      appBar: CustomAppBar(
        title: 'Create Ticket',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject field
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AppTextField(
                  controller: _subjectController,
                  labelText: 'Subject',
                  prefixIcon: Icon(Icons.subject_rounded, size: 20, color: primary),
                  validator: (v) => v?.trim().isEmpty == true ? 'Subject required' : null,
                ),
              ),
              
              const SizedBox(height: 16),

              // Priority (searchable dialog)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: _priorities.isEmpty
                      ? null
                      : () async {
                          final init = _priorities.where((p) => p.id == _selectedPriorityId).isNotEmpty
                              ? _priorities.firstWhere((p) => p.id == _selectedPriorityId)
                              : null;
                          await showDialog<Priority?>(
                            context: context,
                            builder: (ctx) => SearchableDialog<Priority>(
                              title: 'Select Priority',
                              items: _priorities,
                              itemDisplay: (p) => p.priority ?? '',
                              initialValue: init,
                              onSelected: (p) => setState(() => _selectedPriorityId = p?.id),
                            ),
                          );
                        },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600),
                      prefixIcon: Icon(Icons.priority_high_rounded, size: 20, color: primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedPriorityId == null
                                ? 'Select priority'
                                : (_priorities.firstWhere((p) => p.id == _selectedPriorityId, orElse: () => Priority(id: null, priority: 'Unknown')).priority ?? 'Unknown'),
                            style: TextStyle(color: _selectedPriorityId == null ? (isDark ? Colors.white38 : Colors.grey.shade600) : (isDark ? Colors.white : const Color(0xFF1A2634))),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, color: isDark ? Colors.white54 : Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Category (searchable)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: _categories.isEmpty
                      ? null
                      : () async {
                          final init = _categories.where((c) => c.id == _selectedCategoryId).isNotEmpty
                              ? _categories.firstWhere((c) => c.id == _selectedCategoryId)
                              : null;
                          await showDialog<SupportCategory?>(
                            context: context,
                            builder: (ctx) => SearchableDialog<SupportCategory>(
                              title: 'Select Category',
                              items: _categories,
                              itemDisplay: (c) => c.name ?? '',
                              initialValue: init,
                              onSelected: (c) => setState(() => _selectedCategoryId = c?.id),
                            ),
                          );
                        },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600),
                      prefixIcon: Icon(Icons.category_rounded, size: 20, color: primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedCategoryId == null
                                ? 'Select category'
                                : (_categories.firstWhere((c) => c.id == _selectedCategoryId, orElse: () => SupportCategory(id: null, name: 'Unknown')).name ?? 'Unknown'),
                            style: TextStyle(color: _selectedCategoryId == null ? (isDark ? Colors.white38 : Colors.grey.shade600) : (isDark ? Colors.white : const Color(0xFF1A2634))),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, color: isDark ? Colors.white54 : Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Service (server-driven selector)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: _services.isEmpty
                      ? null
                      : () async {
                          final init = _services.where((s) => s.id == _selectedServiceId).isNotEmpty
                              ? _services.firstWhere((s) => s.id == _selectedServiceId)
                              : null;
                          await showDialog<SupportService?>(
                            context: context,
                            builder: (ctx) => SearchableDialog<SupportService>(
                              title: 'Select Service',
                              items: _services,
                              itemDisplay: (s) => s.name ?? '',
                              initialValue: init,
                              onSelected: (s) => setState(() => _selectedServiceId = s?.id),
                            ),
                          );
                        },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Service',
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600),
                      prefixIcon: Icon(Icons.build_rounded, size: 20, color: primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedServiceId == null
                                ? 'Select service'
                                : (_services.firstWhere((s) => s.id == _selectedServiceId, orElse: () => SupportService(id: null, name: 'Unknown')).name ?? 'Unknown'),
                            style: TextStyle(color: _selectedServiceId == null ? (isDark ? Colors.white38 : Colors.grey.shade600) : (isDark ? Colors.white : const Color(0xFF1A2634))),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, color: isDark ? Colors.white54 : Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Assignees section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people_rounded, size: 20, color: primary),
                        const SizedBox(width: 8),
                        Text(
                          'Assignees',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isDark ? Colors.white : const Color(0xFF1A2634),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _supervisors.map((s) {
                        final user = s.user;
                        if (user == null) return const SizedBox.shrink();
                        final id = user.id ?? -1;
                        final selected = _selectedAssignees.contains(id);
                        return FilterChip(
                          label: Text(user.name ?? 'User'),
                          selected: selected,
                          onSelected: (v) {
                            setState(() {
                              if (v) _selectedAssignees.add(id); else _selectedAssignees.remove(id);
                            });
                          },
                          backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                          selectedColor: primary.withOpacity(0.2),
                          checkmarkColor: primary,
                          labelStyle: TextStyle(
                            color: selected ? primary : (isDark ? Colors.white70 : Colors.grey.shade700),
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: selected ? primary : (isDark ? Colors.white10 : Colors.grey.shade300),
                              width: 1,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Location dropdown
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: _locations.isEmpty
                      ? null
                      : () async {
                          final init = _locations.where((l) => l.id == _selectedLocationId).isNotEmpty
                              ? _locations.firstWhere((l) => l.id == _selectedLocationId)
                              : null;
                          await showDialog<SupportLocation?>(
                            context: context,
                            builder: (ctx) => SearchableDialog<SupportLocation>(
                              title: 'Select Location',
                              items: _locations,
                              itemDisplay: (l) => l.name ?? '',
                              initialValue: init,
                              onSelected: (l) => setState(() => _selectedLocationId = l?.id),
                            ),
                          );
                        },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600),
                      prefixIcon: Icon(Icons.location_on_rounded, size: 20, color: primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedLocationId == null
                                ? 'Select location'
                                : (_locations.firstWhere((l) => l.id == _selectedLocationId, orElse: () => SupportLocation(id: null, name: 'Unknown')).name ?? 'Unknown'),
                            style: TextStyle(color: _selectedLocationId == null ? (isDark ? Colors.white38 : Colors.grey.shade600) : (isDark ? Colors.white : const Color(0xFF1A2634))),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, color: isDark ? Colors.white54 : Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // End date picker
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.event_rounded, size: 20, color: primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _endDate == null ? 'Not set' : _endDate!.toLocal().toString().split(' ')[0],
                            style: TextStyle(
                              fontSize: 16,
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
                        if (picked != null) setState(() => _endDate = picked);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: primary,
                        backgroundColor: primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(_endDate == null ? 'Set Date' : 'Change'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Description field
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AppTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_rounded, size: 20, color: primary),
                  minLines: 3,
                  maxLines: 6,
                ),
              ),

              const SizedBox(height: 16),

              // Attachments section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_file_rounded, size: 20, color: primary),
                        const SizedBox(width: 8),
                        Text(
                          'Attachments',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isDark ? Colors.white : const Color(0xFF1A2634),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_localFiles.length} file(s)',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Upload button
                    InkWell(
                      onTap: _pickFiles,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primary.withOpacity(0.3),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: primary.withOpacity(0.02),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.cloud_upload_rounded, color: primary, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'Click to browse files',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white70 : Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Supports multiple files',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white38 : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // File list
                    if (_localFiles.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ..._localFiles.map((f) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white10 : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getFileIcon(f['name']),
                                size: 16,
                                color: primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    f['name'] ?? 'File',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    f['size'] ?? '',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close_rounded, size: 18, color: Colors.red.shade300),
                              onPressed: () => setState(() => _localFiles.remove(f)),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      )),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit button
              Container(
                width: double.infinity,
                height: 54,
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Create Ticket',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
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
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }
}