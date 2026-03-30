import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_icons.dart';

class HrCategory {
  final String name;
  final IconData icon;
  final List<String> submodules;
  final String? description;

  const HrCategory({
    required this.name,
    required this.icon,
    this.submodules = const [],
    this.description,
  });
}

const List<HrCategory> hrCategories = [
  HrCategory(
    name: 'Leave',
    icon: Icons.beach_access_rounded,
    description: 'Manage time off, holidays and leave requests.',
    submodules: ['Leave Requests', 'Leave Balance', 'Leave Calendar', 'Holiday List'],
  ),
  HrCategory(
    name: 'Employees',
    icon: Icons.people_outline_rounded,
    description: 'View and manage all organization staff members.',
  ),
  HrCategory(
    name: 'Probation',
    icon: Icons.pending_actions_rounded,
    description: 'Track and evaluate employees in probation period.',
  ),
  HrCategory(
    name: 'Payroll',
    icon: Icons.payments_outlined,
    description: 'Process salaries, advances and periodic payments.',
    submodules: [
      'Salary Advance',
      'Manage Payroll',
      'Payslip',
      'Mid Month Salary'
    ],
  ),
  HrCategory(
    name: 'Attendance',
    icon: Icons.access_time_rounded,
    description: 'Monitor daily attendance and biometric logs.',
    submodules: [
      'Bulk Attendance',
      'Attendance',
      'Biometric Logs',
      'Overtime',
      'UnderTime'
    ],
  ),
  HrCategory(
    name: 'Performance',
    icon: Icons.trending_up_rounded,
    description: 'Evaluate staff performance using KPI metrics.',
    submodules: ['KPI Template', 'KPI Form'],
  ),
  HrCategory(
    name: 'Training',
    icon: Icons.model_training_rounded,
    description: 'Schedule and manage employee development programs.',
    submodules: ['Training List', 'Trainer'],
  ),
  HrCategory(
    name: 'Recruitment',
    icon: Icons.person_add_alt_1_outlined,
    description: 'Handle end-to-end hiring and onboarding.',
    submodules: [
      'Jobs',
      'Job Application',
      'Job Candidate',
      'Job On-boarding',
      'Custom Question',
      'Interview schedule',
      'Career portal'
    ],
  ),
  HrCategory(
    name: 'HR Admin',
    icon: Icons.admin_panel_settings_outlined,
    description: 'System administration and miscellaneous records.',
    submodules: [
      'Employment History',
      'Award',
      'Transfer',
      'Resignation',
      'Trip',
      'Promotion',
      'Complaints',
      'Warnings',
      'Termination',
      'Announcement',
      'Holidays'
    ],
  ),
  HrCategory(
    name: 'Events',
    icon: LucideIcons.calendar,
    description: 'Plan and view upcoming company events.',
  ),
  HrCategory(
    name: 'Meetings',
    icon: LucideIcons.users,
    description: 'Schedule and track departmental meetings.',
  ),
  HrCategory(
    name: 'Employees Assets',
    icon: LucideIcons.laptop,
    description: 'Track company property assigned to staff.',
  ),
  HrCategory(
    name: 'Documents',
    icon: LucideIcons.fileText,
    description: 'Centralized repository for HR documents.',
  ),
  HrCategory(
    name: 'Company Policy',
    icon: LucideIcons.shieldCheck,
    description: 'Official company guidelines and documentation.',
  ),
  HrCategory(
    name: 'HR Settings',
    icon: LucideIcons.settings,
    description: 'Configure and customize the HR module.',
  ),
];

class HRPage extends StatefulWidget {
  const HRPage({super.key});

  @override
  State<HRPage> createState() => _HRPageState();
}

class _HRPageState extends State<HRPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: hrCategories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: 'Human Resources',
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.search, size: 20),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(LucideIcons.bell, size: 20),
              onPressed: () {},
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: [
            // Quick Stats / Summary Header
            _buildQuickStats(isDark),
            
            // Tab Selector
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                labelPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                indicatorColor: primaryColor,
                indicatorWeight: 3,
                labelColor: primaryColor,
                unselectedLabelColor: isDark ? Colors.white54 : Colors.grey.shade600,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: hrCategories.map((cat) => Text(cat.name)).toList(),
              ),
            ),

            // Tab View Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: hrCategories.map((cat) {
                  return _buildCategoryTabContent(cat, isDark);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(bool isDark) {
    return Container(
      height: 90.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          _buildStatItem('Total Staff', '248', LucideIcons.users, Colors.blue, isDark),
          _buildStatItem('On Leave', '12', LucideIcons.palmtree, Colors.orange, isDark),
          _buildStatItem('Probation', '08', LucideIcons.timer, Colors.purple, isDark),
          _buildStatItem('New Hires', '05', LucideIcons.userPlus, Colors.green, isDark),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      width: 130.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.02),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.r, color: color),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabContent(HrCategory category, bool isDark) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16.r),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  category.description ?? 'Overview and management.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
        if (category.submodules.isNotEmpty)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final title = category.submodules[index];
                  return _buildSubmoduleCard(title, category.icon, isDark);
                },
                childCount: category.submodules.length,
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16.r),
              padding: EdgeInsets.all(24.r),
              height: 300.h,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151A2E) : Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.03),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category.icon,
                      size: 48.r,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'No submodules yet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'The ${category.name} module is being updated with new features.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    ),
                    child: const Text('Refresh Module'),
                  ),
                ],
              ),
            ),
          ),
        SliverToBoxAdapter(child: SizedBox(height: 40.h)),
      ],
    );
  }

  Widget _buildSubmoduleCard(String title, IconData defaultIcon, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.02),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getSubmoduleIcon(title) ?? defaultIcon,
                    color: Colors.white,
                    size: 24.r,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white.withOpacity(0.9) : const Color(0xFF1A2634),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData? _getSubmoduleIcon(String title) {
    final t = title.toLowerCase();
    
    // Leave
    if (t.contains('request')) return LucideIcons.send;
    if (t.contains('balance')) return LucideIcons.pieChart;
    if (t.contains('calendar')) return LucideIcons.calendar;
    if (t.contains('holiday')) return LucideIcons.sun;

    // Payroll
    if (t.contains('advance')) return LucideIcons.banknote;
    if (t.contains('manage')) return LucideIcons.coins;
    if (t.contains('slip')) return LucideIcons.fileText;
    if (t.contains('mid month')) return LucideIcons.calendarDays;
    
    // Attendance
    if (t.contains('bulk')) return LucideIcons.users;
    if (t.contains('log')) return LucideIcons.fingerprint;
    if (t.contains('overtime')) return LucideIcons.history;
    if (t.contains('undertime')) return LucideIcons.clock;
    if (t == 'attendance') return LucideIcons.checkCircle;

    // Performance
    if (t.contains('template')) return LucideIcons.layoutGrid;
    if (t.contains('form')) return LucideIcons.clipboardSignature;

    // Training
    if (t.contains('list')) return LucideIcons.graduationCap;
    if (t.contains('trainer')) return LucideIcons.userCheck;

    // Recruitment
    if (t.contains('application')) return LucideIcons.filePlus;
    if (t.contains('candidate')) return LucideIcons.user;
    if (t.contains('on-boarding')) return LucideIcons.userPlus;
    if (t.contains('question')) return LucideIcons.helpCircle;
    if (t.contains('schedule')) return LucideIcons.calendarClock;
    if (t.contains('career')) return LucideIcons.briefcase;
    if (t == 'jobs') return LucideIcons.briefcase;

    // HR Admin
    if (t.contains('history')) return LucideIcons.history;
    if (t.contains('award')) return LucideIcons.trophy;
    if (t.contains('transfer')) return LucideIcons.moveHorizontal;
    if (t.contains('resignation')) return LucideIcons.logOut;
    if (t.contains('trip')) return LucideIcons.plane;
    if (t.contains('promotion')) return LucideIcons.trendingUp;
    if (t.contains('complaint')) return LucideIcons.messageSquare;
    if (t.contains('warning')) return LucideIcons.alertTriangle;
    if (t.contains('termination')) return LucideIcons.userMinus;
    if (t.contains('announcement')) return LucideIcons.megaphone;
    if (t.contains('holiday')) return LucideIcons.mapPin;

    return null;
  }
}
