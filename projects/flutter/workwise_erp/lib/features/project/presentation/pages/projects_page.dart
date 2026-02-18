import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';
import '../providers/project_providers.dart';
import '../state/project_state.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../domain/entities/project.dart';
import 'package:lucide_icons/lucide_icons.dart';
  
class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;

  // Track whether the loading dialog is currently visible to avoid duplicate dialogs
  bool _isLoadingDialogVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(projectNotifierProvider.notifier).loadProjects();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0A0E21)
            : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: 'Projects',
          actions: [
            if (!_isSearching)
              IconButton(
                icon: Icon(
                  LucideIcons.search,
                  size: 20,
                  color: isDark ? Colors.white70 : AppColors.white
                ),
                onPressed: () {
                  setState(() => _isSearching = true);
                },
              ),
            IconButton(
              icon: Icon(
                LucideIcons.slidersHorizontal,
                size: 20,
                color: isDark ? Colors.white70 : AppColors.white,
              ),
              onPressed: _showFilterOptions,
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar (when active)
            if (_isSearching)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search projects...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade600,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _isSearching = false;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ),
              ),

            // Stats Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Projects',
                      _getProjectCount(state),
                      Icons.folder_rounded,
                      primaryColor,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Active',
                      _getActiveCount(state),
                      Icons.play_circle_rounded,
                      Colors.orange,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Completed',
                      _getCompletedCount(state),
                      Icons.check_circle_rounded,
                      Colors.green,
                      isDark,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(child: _buildBody(state, isDark)),
          ],
        ),

        // Quick Create FAB
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to create project
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Project'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ProjectState state, bool isDark) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () {
        // show global loading dialog instead of inline spinner
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isLoadingDialogVisible) {
            showAppLoadingDialog(context, message: 'Loading projects...');
            _isLoadingDialogVisible = true;
          }
        });
        return const SizedBox.shrink();
      },
      error: (msg) {
        // ensure any loading dialog is dismissed when we reach error state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isLoadingDialogVisible) {
            hideAppLoadingDialog(context);
            _isLoadingDialogVisible = false;
          }
        });

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Colors.red.shade300,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Failed to load projects',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Retry',
                  icon: Icons.refresh_rounded,
                  onPressed: () =>
                      ref.read(projectNotifierProvider.notifier).loadProjects(),
                  variant: AppButtonVariant.primary,
                ),
              ],
            ),
          ),
        );
      },
      loaded: (projects) {
        // ensure loading dialog is dismissed when data arrives
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isLoadingDialogVisible) {
            hideAppLoadingDialog(context);
            _isLoadingDialogVisible = false;
          }
        });

        // Filter projects based on search
        final filteredProjects = _searchController.text.isEmpty
            ? projects
            : projects.where((project) {
                final searchTerm = _searchController.text.toLowerCase();
                return (project.name?.toLowerCase().contains(searchTerm) ??
                        false) ||
                    (project.code?.toLowerCase().contains(searchTerm) ?? false);
              }).toList();

        if (filteredProjects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _searchController.text.isEmpty
                      ? Icons.folder_outlined
                      : Icons.search_off_rounded,
                  size: 80,
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchController.text.isEmpty
                      ? 'No projects found'
                      : 'No matching projects',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _searchController.text.isEmpty
                      ? 'Create your first project'
                      : 'Try adjusting your search',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                if (_searchController.text.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Clear Search',
                    icon: Icons.clear_rounded,
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _isSearching = false;
                      });
                    },
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.small,
                  ),
                ],
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(projectNotifierProvider.notifier).loadProjects(),
          color: AppColors.primary,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: filteredProjects.length,
            itemBuilder: (context, idx) {
              final project = filteredProjects[idx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildProjectCard(context, project),
              );
            },
          ),
        );
      },
      detail: (_) => const SizedBox.shrink(),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (project.progress ?? 0).clamp(0, 100);
    final statusColor = _getStatusColor(project.status);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      color: isDark ? const Color(0xFF151A2E) : Colors.white,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          '/projects/detail',
          arguments: project,
        ),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Project Code and Status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withOpacity(0.15),
                          AppColors.primary.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name ?? 'Unnamed Project',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1A2634),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (project.code != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            project.code!,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (project.status != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        project.status!,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              if (project.description != null &&
                  project.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  project.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 16),

              // Progress Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '$progress%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress / 100.0,
                      minHeight: 8,
                      backgroundColor: isDark
                          ? Colors.white10
                          : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Footer with Owner and Stats
              Row(
                children: [
                  if (project.owner != null &&
                      project.owner!['name'] != null) ...[
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      backgroundImage: imageProviderFromUrl(
                        project.owner!['avatar'],
                      ),
                      child: project.owner!['avatar'] == null
                          ? Text(
                              (project.owner!['name'] ?? '?')[0].toUpperCase(),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        project.owner!['name'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  const Spacer(),
                  _buildStatChip(
                    Icons.assignment_rounded,
                    '${project.tasksCount ?? 0}',
                    isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildStatChip(
                    Icons.timeline_rounded,
                    '${project.sprintsCount ?? 0}',
                    isDark,
                  ),
                  if (project.membersCount != null &&
                      project.membersCount! > 0) ...[
                    const SizedBox(width: 12),
                    _buildStatChip(
                      Icons.people_rounded,
                      '${project.membersCount}',
                      isDark,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    int count,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      height:
          96, // fixed height so Column(spaceBetween) has bounded constraints
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0E21) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text block (label on top, number at bottom)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),

                // number placed visually at the bottom of the text column
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // faint icon on the right
          Opacity(opacity: 0.12, child: Icon(icon, size: 40, color: color)),
        ],
      ),
    );
  }

  int _getProjectCount(ProjectState state) {
    return state.maybeWhen(
      loaded: (projects) => projects.length,
      orElse: () => 0,
    );
  }

  int _getActiveCount(ProjectState state) {
    return state.maybeWhen(
      loaded: (projects) => projects.where((p) {
        final status = p.status?.toLowerCase() ?? '';
        return status == 'active' ||
            status == 'in progress' ||
            status == 'ongoing';
      }).length,
      orElse: () => 0,
    );
  }

  int _getCompletedCount(ProjectState state) {
    return state.maybeWhen(
      loaded: (projects) => projects.where((p) {
        final status = p.status?.toLowerCase() ?? '';
        return status == 'completed' ||
            status == 'done' ||
            status == 'finished';
      }).length,
      orElse: () => 0,
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return AppColors.primary;

    switch (status.toLowerCase()) {
      case 'active':
      case 'in progress':
      case 'ongoing':
        return Colors.orange;
      case 'completed':
      case 'done':
      case 'finished':
        return Colors.green;
      case 'on hold':
      case 'paused':
        return Colors.grey;
      case 'cancelled':
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  void _showFilterOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Filter Projects',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('Status', 'All', Icons.flag_rounded),
              _buildFilterOption(
                'Date Range',
                'Last 30 days',
                Icons.date_range_rounded,
              ),
              _buildFilterOption('Owner', 'All owners', Icons.person_rounded),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Reset',
                        onPressed: () => Navigator.pop(context),
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.medium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: 'Apply',
                        onPressed: () => Navigator.pop(context),
                        variant: AppButtonVariant.primary,
                        size: AppButtonSize.medium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.muted.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF1A2634),
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white54 : Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDark ? Colors.white38 : Colors.grey.shade400,
      ),
      onTap: () {},
    );
  }
}
