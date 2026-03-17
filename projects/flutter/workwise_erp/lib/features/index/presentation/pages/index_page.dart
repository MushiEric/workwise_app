import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/menu/menus.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/provider/permission_provider.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/extensions/l10n_extension.dart';

import '../../../../core/widgets/app_bar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../notification/presentation/providers/notification_providers.dart';

class IndexPage extends ConsumerStatefulWidget {
  const IndexPage({super.key});

  @override
  ConsumerState<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends ConsumerState<IndexPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;

  // Coach mark targets
  final _moduleKey = GlobalKey();
  final _notificationKey = GlobalKey();
  final _profileKey = GlobalKey();
  final _firstModuleKey = GlobalKey();

  // Tutorial retry state (keys may not be available immediately on first build)
  bool _tutorialShown = false;
  int _tutorialRetryCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );

    _animationController.forward();

    // load notifications on index page open (keeps unread badge up-to-date)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsNotifierProvider.notifier).loadNotifications();
      _maybeShowTutorial();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _maybeShowTutorial() async {
    final seen = await TutorialService.hasSeenTutorial();
    if (seen) return;

    // Wait a tick so the UI is fully laid out.
    await Future<void>.delayed(const Duration(milliseconds: 150));

    _attemptShowTutorial();
  }

  void _attemptShowTutorial() {
    if (!mounted || _tutorialShown) return;

    final targets = _buildTutorialTargets();
    if (targets.isEmpty) {
      // Keys may not have mounted yet (especially the module grid).
      // Retry a few times before giving up.
      if (_tutorialRetryCount < 10) {
        _tutorialRetryCount += 1;
        Future<void>.delayed(
          const Duration(milliseconds: 250),
          _attemptShowTutorial,
        );
      } else {
        // Give up and avoid retrying forever.
        TutorialService.markTutorialSeen();
      }
      return;
    }

    _tutorialShown = true;
    _showTutorial(targets);
  }

  List<TargetFocus> _buildTutorialTargets() {
    final targets = <TargetFocus>[];

    if (_firstModuleKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "module",
          keyTarget: _firstModuleKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select a Module',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap a module card to access features like jobcards, notifications, and more.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_notificationKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "notifications",
          keyTarget: _notificationKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.left,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap here to view notifications. Swipe left on an item to dismiss.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_profileKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "profile",
          keyTarget: _profileKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.left,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Profile & Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap here to view your profile and access settings like language & tutorial replay.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return targets;
  }

  void _showTutorial(List<TargetFocus> targets) {
    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.8),
      textSkip: 'Skip',
      onFinish: () => TutorialService.markTutorialSeen(),
      onSkip: () {
        TutorialService.markTutorialSeen();
        return true;
      },
      onClickTarget: (target) {},
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final checker = ref.watch(permissionCheckerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    // Filter menus based on permissions
    final visibleMenus = appMenus.where((m) {
      if (m.requiredPermissions != null && m.requiredPermissions!.isNotEmpty) {
        return checker.hasAnyPermission(m.requiredPermissions!);
      }
      return true;
    }).toList();

    // Filter based on search
    final filteredMenus = _searchController.text.isEmpty
        ? visibleMenus
        : visibleMenus
              .where(
                (m) => m.title.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
              )
              .toList();

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
          title: '',
          centerTitle: false,
          leading: Builder(
            builder: (ctx) => IconButton(
              key: _moduleKey,
              icon: Icon(
                LucideIcons.menu,
                color: isDark ? Colors.white : AppColors.white,
              ),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          // show logo as the titleWidget so it sits to the right of the menu icon without overflow
          titleWidget: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Image.asset(
              'assets/images/logo2.png',
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            // Search Button
            if (!_isSearching)
              IconButton(
                icon: Icon(
                  LucideIcons.search,
                  color: isDark ? Colors.white70 : AppColors.white,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _isSearching = true);
                },
              ),

            // Notification Button
            IconButton(
              key: _notificationKey,
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    LucideIcons.bell,
                    color: isDark ? Colors.white70 : AppColors.white,
                    size: 20,
                  ),
                  // unread badge (uses provider)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Consumer(
                      builder: (ctx, ref2, _) {
                        final count = ref2.watch(
                          unreadNotificationsCountProvider,
                        );
                        if (count <= 0) return const SizedBox.shrink();
                        // show exact unread count (do not abbreviate to "9+")
                        final text = '$count';
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            IconButton(
              key: _profileKey,
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              icon: Icon(
                LucideIcons.user,
                color: isDark ? Colors.white : AppColors.white,
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(),
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
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: context.l10n.searchModulesHint,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            LucideIcons.x,
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
            SizedBox(height: 16),

            // Greeting banner (replaces stats cards)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Builder(
                builder: (context) {
                  final authState = ref.watch(authNotifierProvider);
                  final username = authState.maybeWhen(
                    authenticated: (u) => u.name ?? 'User',
                    orElse: () => 'User',
                  );
                  final firstName = (username.split(' ').isNotEmpty)
                      ? username.split(' ').first
                      : username;
                  final hour = DateTime.now().toLocal().hour;
                  final l10n = context.l10n;
                  final greeting = hour < 5
                      ? l10n.goodNight
                      : (hour < 12
                            ? l10n.goodMorning
                            : (hour < 17
                                  ? l10n.goodAfternoon
                                  : (hour < 21
                                        ? l10n.goodEvening
                                        : l10n.goodNight)));

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.purple],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$greeting, $firstName',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                context.l10n.welcomeToApp(context.l10n.appName),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white24,
                          child: Text(
                            firstName.isNotEmpty
                                ? firstName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${context.l10n.apps}${filteredMenus.isEmpty ? '' : ' (${filteredMenus.length})'}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Module Grid
            Expanded(
              child: filteredMenus.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.search,
                            size: 64,
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.noModulesFound,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.tryAdjustingSearch,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _isSearching = false;
                              });
                            },
                            icon: const Icon(LucideIcons.x),
                            label: Text(context.l10n.clearSearch),
                            style: TextButton.styleFrom(
                              foregroundColor: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 170,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              // square cards (equal width + height)
                              childAspectRatio: 1.0,
                            ),
                        itemCount: filteredMenus.length,
                        itemBuilder: (context, idx) {
                          return _ModuleTile(
                            key: idx == 0 ? _firstModuleKey : null,
                            menu: filteredMenus[idx],
                            index: idx,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatefulWidget {
  final dynamic menu;
  final int index;

  const _ModuleTile({Key? key, required this.menu, required this.index})
    : super(key: key);

  @override
  State<_ModuleTile> createState() => _ModuleTileState();
}

class _ModuleTileState extends State<_ModuleTile>
    with SingleTickerProviderStateMixin {
  final bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  // Accent palette used for the small icon block on each module card.
  final List<Color> _accentColors = [
    Color(0xFF6C5CE7), // purple
    Color(0xFF00B894), // green
    Color(0xFFFF9F43), // orange
    Color(0xFFFF7675), // red/pink
    Color(0xFF00A8FF), // blue
    Color(0xFFFD79A8), // pink
  ];

  Color _accentForIndex(int idx) => _accentColors[idx % _accentColors.length];

  String? _svgAssetForMenuId(String id) {
    switch (id) {
      case 'support':
        return 'assets/icons/support.svg';
      case 'jobcard':
        return 'assets/icons/jobcard.svg';
      case 'logistic':
        return 'assets/icons/service.svg';
      case 'customer':
        return 'assets/icons/customer.svg';
      case 'project':
        return 'assets/icons/project.svg';
      case 'documents':
        return 'assets/icons/documents.svg';    
      default:
        return null;
    }
  }

  Widget _buildMenuIcon(String menuId, Color color, {double size = 48}) {
    final asset = _svgAssetForMenuId(menuId);
    if (asset != null) {
      return SvgPicture.asset(
        asset,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return Icon(widget.menu.icon, color: color, size: size);
  }

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final menu = widget.menu;

    // Generate a subtle gradient color based on index
    final gradientColors = [
      primaryColor.withOpacity(0.1 + (widget.index % 3) * 0.05),
      primaryColor.withOpacity(0.05 + (widget.index % 3) * 0.03),
    ];

    return AnimatedScale(
      scale: _scaleAnimation.value,
      duration: const Duration(milliseconds: 200),
      child: MouseRegion(
        onEnter: (_) => _hoverController.forward(),
        onExit: (_) => _hoverController.reverse(),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, menu.route),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon card
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F1724) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Center(
                  child: _buildMenuIcon(
                    menu.id,
                    _accentForIndex(widget.index),
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Label outside of the card container
              Text(
                menu.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
