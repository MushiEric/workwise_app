import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../notifier/jobcard_notifier.dart';
import '../providers/jobcard_providers.dart';
import '../widgets/jobcard_tile.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../domain/entities/jobcard.dart';

class JobcardListPage extends ConsumerStatefulWidget {
  const JobcardListPage({super.key});

  @override
  ConsumerState<JobcardListPage> createState() => _JobcardListPageState();
}

class _JobcardListPageState extends ConsumerState<JobcardListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobcardNotifierProvider.notifier).loadJobcards();
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
    final state = ref.watch(jobcardNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    // Show/hide global loading dialog on state transition
    ref.listen<JobcardState>(jobcardNotifierProvider, (prev, next) {
      final prevLoading = prev?.loading ?? false;
      final nextLoading = next.loading;

      if (prevLoading == nextLoading) return;

      if (nextLoading) {
        showAppLoadingDialog(context, message: 'Fetching jobcards...');
      } else {
        hideAppLoadingDialog(context);
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: 'Jobcards',
          actions: [
            if (!_isSearching)
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
                onPressed: () {
                  setState(() => _isSearching = true);
                },
              ),

            // Settings icon for Jobcard settings
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.settings_rounded,
                  size: 20,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/jobcards/settings'),
            ),

            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.filter_list_rounded,
                  size: 20,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
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
                        hintText: 'Search jobcards...',
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
                            color: isDark ? Colors.white54 : Colors.grey.shade600,
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
                      'Total',
                      _getJobcardCount(state),
                      Icons.assignment_rounded,
                      primaryColor,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Pending',
                      _getPendingCount(state),
                      Icons.pending_actions_rounded,
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
            Expanded(
              child: _buildBody(state, isDark),
            ),
          ],
        ),

        // Quick Create FAB
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed('/jobcards/create');
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Jobcard'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(JobcardState state, bool isDark) {
    if (state.loading) {
      return const Center(
        // child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
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
                'Failed to load jobcards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Retry',
                icon: Icons.refresh_rounded,
                onPressed: () => ref.read(jobcardNotifierProvider.notifier).loadJobcards(),
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
        ),
      );
    }

    final jobcards = state.items.cast<Jobcard>();
    
    // Filter jobcards based on search
    final filteredJobcards = _searchController.text.isEmpty
        ? jobcards
        : jobcards.where((jobcard) {
            final searchTerm = _searchController.text.toLowerCase();
            return (jobcard.jobcardNumber?.toLowerCase().contains(searchTerm) ?? false) ||
                   (jobcard.service?.toLowerCase().contains(searchTerm) ?? false);
          }).toList();

    if (filteredJobcards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isEmpty
                  ? Icons.assignment_outlined
                  : Icons.search_off_rounded,
              size: 80,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No jobcards found'
                  : 'No matching jobcards',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isEmpty
                  ? 'Create your first jobcard'
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
      onRefresh: () => ref.read(jobcardNotifierProvider.notifier).loadJobcards(),
      color: AppColors.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: filteredJobcards.length,
        itemBuilder: (context, idx) {
          final jobcard = filteredJobcards[idx];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: JobcardTile(
              jobcard: jobcard,
              onTap: () => Navigator.of(context).pushNamed('/jobcards/detail', arguments: jobcard.id),
              onDelete: () => _confirmDelete(jobcard),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, int count, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
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

  int _getJobcardCount(JobcardState state) {
    if (state.loading || state.error != null) return 0;
    return state.items.length;
  }

  int _getPendingCount(JobcardState state) {
    if (state.loading || state.error != null) return 0;
    return state.items.cast<Jobcard>().where((j) {
      final status = j.statusRow?['name']?.toString().toLowerCase() ?? j.status?.toLowerCase() ?? '';
      return status.contains('pending') || status == '2' || status == '3';
    }).length;
  }

  int _getCompletedCount(JobcardState state) {
    if (state.loading || state.error != null) return 0;
    return state.items.cast<Jobcard>().where((j) {
      final status = j.statusRow?['name']?.toString().toLowerCase() ?? j.status?.toLowerCase() ?? '';
      return status.contains('completed') || status.contains('done') || status == '1' || status == '4';
    }).length;
  }

  Future<void> _confirmDelete(Jobcard jobcard) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: 'Delete Jobcard',
      message: 'Are you sure you want to delete this jobcard? This action cannot be undone.',
      messageColor:AppColors.black,
      confirmText: 'Delete',
      confirmColor: AppColors.error,
    );
    if (confirmed != true || jobcard.id == null) return;

    final deleteUc = ref.read(deleteJobcardUseCaseProvider);
    showAppLoadingDialog(context, message: 'Deleting jobcard...');
    final res = await deleteUc.call(id: jobcard.id!);
    hideAppLoadingDialog(context);
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete jobcard: ${l is Exception ? l.toString() : '$l'}'))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jobcard deleted')));
        ref.read(jobcardNotifierProvider.notifier).loadJobcards();
      },
    );
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
                'Filter Jobcards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('Status', 'All', Icons.flag_rounded),
              _buildFilterOption('Date Range', 'Last 30 days', Icons.date_range_rounded),
              _buildFilterOption('Service', 'All services', Icons.build_rounded),
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
          color: AppColors.primary.withOpacity(0.1),
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
