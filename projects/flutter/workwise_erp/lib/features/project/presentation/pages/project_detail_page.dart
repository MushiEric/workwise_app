import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/widgets/app_tab_bar.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../providers/project_providers.dart';
import '../widgets/project_task_tile.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../domain/entities/project.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  const ProjectDetailPage({super.key});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? _projectId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Project) {
      _projectId = arg.id;
      // set the notifier detail from the provided list object (no network call)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted)
          ref
              .read(projectNotifierProvider.notifier)
              .setProjectDetailFromList(arg);
      });
    } else if (arg is int) {
      _projectId = arg;
      // defer loading to avoid modifying providers during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _projectId != null) {
          ref
              .read(projectNotifierProvider.notifier)
              .loadProjectDetail(_projectId!);
        }
      });
    }
    _tabController ??= TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          title: state.maybeWhen(
            detail: (p) => 'Project #${p.code ?? p.id ?? 'N/A'}',
            orElse: () => 'View Project',
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.share_rounded,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Share project — not implemented'),
                  ),
                );
              },
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
              onSelected: (v) {
                switch (v) {
                  case 'edit':
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('Edit project — not implemented'),
                      ),
                    );
                    break;
                  case 'more':
                  default:
                    _showMoreOptions(context);
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit Project')),
                const PopupMenuDivider(),
                const PopupMenuItem(value: 'more', child: Text('More...')),
              ],
            ),
          ],
        ),
        body: state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (_) => const SizedBox.shrink(),
          detail: (p) => _buildProjectDetailContent(context, p),
          error: (m) => _buildErrorState(context, m, isDark),
        ),
      ),
    );
  }

  Widget _buildProjectDetailContent(BuildContext context, Project project) {
    return Column(
      children: [
        // Tab Bar
        AppTabBar(
          controller: _tabController!,
          tabs: const ['Overview', 'Sprints', 'Tasks', 'Milestones', 'Members'],
        ),
        const SizedBox(height: 12),

        Expanded(
          child: TabBarView(
            controller: _tabController!,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildOverviewTab(context, project),
              _buildSprintsTab(context, project),
              _buildTasksTab(project),
              _buildMilestonesTab(context, project),
              _buildMembersTab(context, project),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(BuildContext context, Project project) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final progress = (project.progress ?? 0).clamp(0, 100);
    final statusColor = _getStatusColor(project.status);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Name and Code Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withOpacity(0.15),
                            primaryColor.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.folder_rounded,
                        color: primaryColor,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2634),
                            ),
                          ),
                          if (project.code != null) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                project.code!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
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
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          size: 18,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Progress',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1A2634),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$progress%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress / 100.0,
                    minHeight: 10,
                    backgroundColor: isDark
                        ? Colors.white10
                        : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Stats Cards Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Tasks',
                  '${project.tasksCount ?? 0}',
                  Icons.assignment_rounded,
                  Colors.blue,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Sprints',
                  '${project.sprintsCount ?? 0}',
                  Icons.timeline_rounded,
                  Colors.orange,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Members',
                  '${project.membersCount ?? 0}',
                  Icons.people_rounded,
                  Colors.green,
                  isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Project Information Card
          _buildInfoCard(
            context,
            title: 'Project Information',
            icon: Icons.info_rounded,
            children: [
              _infoRow('Start Date', project.startDate ?? '-'),
              _infoRow('End Date', project.endDate ?? '-'),
              if (project.owner != null && project.owner!['name'] != null)
                _infoRow('Owner', project.owner!['name'] ?? '-'),
            ],
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A2634),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSprintsTab(BuildContext context, Project project) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline_rounded,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Sprints',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sprint management coming soon',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab(Project project) {
    final projectId = project.id;
    if (projectId == null) {
      return const Center(child: Text('Missing project id'));
    }

    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(projectTasksNotifierProvider.notifier);
        final state = ref.watch(projectTasksNotifierProvider);
        final isDark = Theme.of(context).brightness == Brightness.dark;

        // Load once when entering tab and project changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          state.maybeWhen(
            initial: () {
              notifier.loadTasks(projectId);
              return null;
            },
            orElse: () => null,
          );
        });

        return state.when(
          initial: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Preparing tasks...',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading tasks...',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          loaded: (tasks) {
            if (tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first task for this project',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final t = tasks[i];
                final map = {
                  'title': t.title,
                  'assignee': t.assignee,
                  'status': t.status,
                  'progress': t.progress,
                };
                return projectTaskTile(context, map);
              },
            );
          },
          error: (m) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    m,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Retry',
                    icon: Icons.refresh_rounded,
                    onPressed: () => notifier.loadTasks(projectId),
                    variant: AppButtonVariant.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMilestonesTab(BuildContext context, Project project) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag_rounded,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Milestones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Milestone tracking coming soon',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTab(BuildContext context, Project project) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Team Members',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Member management coming soon',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isDark) {
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
              'Failed to load project',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Retry',
              icon: Icons.refresh_rounded,
              onPressed: () {
                if (_projectId != null) {
                  ref
                      .read(projectNotifierProvider.notifier)
                      .loadProjectDetail(_projectId!);
                }
              },
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
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

  void _showMoreOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
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
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.edit_rounded, color: Colors.blue),
                ),
                title: const Text('Edit Project'),
                onTap: () => Navigator.pop(sheetCtx),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: Colors.green,
                  ),
                ),
                title: const Text('Add Member'),
                onTap: () => Navigator.pop(sheetCtx),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.print_rounded, color: Colors.orange),
                ),
                title: const Text('Print Project'),
                onTap: () => Navigator.pop(sheetCtx),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.red),
                ),
                title: const Text('Delete Project'),
                onTap: () => Navigator.pop(sheetCtx),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
