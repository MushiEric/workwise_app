import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../../domain/entities/jobcard_status.dart';
import '../providers/jobcard_providers.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/utils/color_utils.dart';

class JobcardSettingsPage extends ConsumerStatefulWidget {
  const JobcardSettingsPage({super.key});

  @override
  ConsumerState<JobcardSettingsPage> createState() => _JobcardSettingsPageState();
}

class _JobcardSettingsPageState extends ConsumerState<JobcardSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final getSettings = ref.read(getJobcardSettingsUseCaseProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: 'Jobcard Settings',
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 20,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
              onPressed: () {
                // Navigate to create setting
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: getSettings.call(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
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
                        'Failed to load settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1A2634),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error?.toString() ?? 'Unknown error',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'Retry',
                        icon: Icons.refresh_rounded,
                        onPressed: () => setState(() {}),
                        variant: AppButtonVariant.primary,
                      ),
                    ],
                  ),
                ),
              );
            }

            final either = snapshot.data;
            if (either == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 64,
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Either<Failure, List<JobcardStatus>>
            return either.fold<Widget>(
              (failure) {
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
                          'Failed to load settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1A2634),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          failure.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'Retry',
                          icon: Icons.refresh_rounded,
                          onPressed: () => setState(() {}),
                          variant: AppButtonVariant.primary,
                        ),
                      ],
                    ),
                  ),
                );
              },
              (List<JobcardStatus> list) {
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          size: 64,
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first jobcard setting',
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, idx) {
                      final s = list[idx];
                      Color color = AppColors.primary;
                      if (s.color != null && s.color!.isNotEmpty) {
                        color = hexToColor(s.color!, fallback: color);
                      }
                      return _buildSettingCard(context, s, color, isDark);
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to create setting
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Setting'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, JobcardStatus status, Color color, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.flag_rounded,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          status.name ?? 'Unnamed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : const Color(0xFF1A2634),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ID: ${status.id ?? '-'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
              ),
              if (status.color != null && status.color!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.edit_rounded,
              size: 18,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          onPressed: () {
            // Edit setting
          },
        ),
      ),
    );
  }
}
