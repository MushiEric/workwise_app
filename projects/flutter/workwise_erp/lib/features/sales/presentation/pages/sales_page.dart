import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/provider/permission_provider.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/scroll_aware_fab.dart';
import '../../../../core/widgets/dashboard_stat_card.dart';
import '../../../../core/widgets/dashboard_stats_row.dart';
import '../../domain/entities/sales_order.dart';
import '../providers/sales_providers.dart';
import '../state/sales_state.dart';
import '../widgets/order_tile.dart';
import 'sales_view_page.dart';
import '../../../../core/themes/app_icons.dart';
import '../../../../core/widgets/drawer_filter.dart';
import '../../../../core/widgets/google_nav_bar.dart';
import '../../../jobcard/presentation/providers/jobcard_providers.dart';
import '../../../customer/presentation/providers/customer_providers.dart';
import '../../../support/presentation/providers/support_providers.dart';

import '../../../pfi/presentation/providers/pfi_providers.dart';
import '../../../pfi/presentation/state/pfi_state.dart';
import '../../../pfi/domain/entities/pfi.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;
  bool _showStats = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DrawerFilterValue? _activeFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(salesNotifierProvider.notifier)
          .loadOrders(_mapFilterToParams(_activeFilter));
      ref.read(pfiNotifierProvider.notifier).loadPfis();
      _warmupMetadata();
    });
  }

  void _warmupMetadata() {
    // Warm up common metadata providers for create forms to avoid loading states later
    final providers = [
      salesUsersProvider,
      salesOrderStatusesProvider,
      salesProductsProvider,
      salesPackageUnitsProvider,
      salesVehiclesProvider,
      salesPackageTypesProvider,
      salesWarehousesProvider,
      salesQuotationsProvider,
      salesContractsProvider,
      salesRequestsProvider,
      salesTaxesProvider,
      salesCurrenciesProvider,
      salesJobcardsProvider,
      salesSupportTicketsProvider,
      salesProjectsProvider,
      salesTripsProvider,
      salesPaymentTermsProvider,
      salesPaymentMethodProvider,
      salesPrioritiesProvider,
      salesCargoUnitsProvider,
      salesPaymentTypesProvider,
      salesDiscountTypesProvider,
      salesSubscriptionDurationsProvider,
      salesSettingsProvider,
      salesSettingsConfigProvider,
      pfiSettingsProvider,
    ];

    for (final p in providers) {
      try {
        if (p is ProviderListenable) {
           ref.read(p);
        }
      } catch (_) {}
    }

    // Trigger stateful metadata loads if not already loaded
    try {
      ref.read(customersNotifierProvider.notifier).loadCustomers();
    } catch (_) {}
    try {
      ref.read(supportNotifierProvider.notifier).loadTickets(limit: 1000);
    } catch (_) {}
  }

  void _onScroll() {
    if (_tabController.index == 0) {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(salesNotifierProvider.notifier).loadMoreOrders();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salesState = ref.watch(salesNotifierProvider);
    final pfiState = ref.watch(pfiNotifierProvider);
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
          title: "Sales",
          actions: [
            IconButton(
              icon: Icon(
                _isSearching ? AppIcons.x : AppIcons.search,
                size: 20.r,
              ),
              color: AppColors.white,
              onPressed: () {
                setState(() {
                  if (_isSearching) _searchController.clear();
                  _isSearching = !_isSearching;
                });
              },
            ),
            IconButton(
              icon: Icon(
                _showStats ? AppIcons.eye : AppIcons.eyeOff,
                size: 20.r,
              ),
              color: AppColors.white,
              onPressed: () => setState(() => _showStats = !_showStats),
            ),
            IconButton(
              icon: Icon(
                AppIcons.filter,
                size: 20.r,
                color: _activeFilter != null && !_activeFilter!.isEmpty
                    ? Colors.yellow
                    : Colors.white,
              ),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
        ),
        key: _scaffoldKey,
        endDrawer: DrawerFilter(
          title: _tabController.index == 0
              ? 'Filter Sales Orders'
              : 'Filter PFIs',
          users: ref.watch(salesUsersProvider).valueOrNull ?? [],
          statuses: ref.watch(salesOrderStatusesProvider).valueOrNull ?? [],
          initialValue: _activeFilter,
          onApply: (v) {
            setState(() => _activeFilter = v);
            ref
                .read(salesNotifierProvider.notifier)
                .loadOrders(_mapFilterToParams(v));
          },
          onReset: () {
            setState(() => _activeFilter = null);
            ref
                .read(salesNotifierProvider.notifier)
                .loadOrders(_mapFilterToParams(null));
          },
        ),

        drawer: const AppDrawer(),
        body: Column(
          children: [
            // Search Bar
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: _isSearching
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
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
                            hintText: _tabController.index == 0
                                ? 'Search orders...'
                                : 'Search PFIs...',
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                              fontSize: 14.sp,
                            ),
                            prefixIcon: Icon(
                              AppIcons.search,
                              color: isDark ? Colors.white54 : primaryColor,
                              size: 18.r,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                AppIcons.x,
                                color: isDark ? Colors.white54 : primaryColor,
                                size: 18.r,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _isSearching = false;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1A2634),
                            fontSize: 14.sp,
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Stats Header
            DashboardStatsRow(
              visible: _showStats,
              cards: _tabController.index == 0
                  ? _buildOrderStats(salesState, isDark)
                  : _buildPfiStats(pfiState, isDark),
            ),

            SizedBox(height: 16.h),

            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Orders"),
                  Tab(text: "PFIs"),
                ],
                labelColor: primaryColor,
                labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(fontSize: 13.sp),
                unselectedLabelColor: isDark
                    ? Colors.white54
                    : Colors.grey.shade600,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: primaryColor.withOpacity(0.15),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
              ),
            ),

            SizedBox(height: 12.h),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList(salesState, isDark),
                  _buildPfisList(pfiState, isDark),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: ScrollAwareFab(
          controller: _scrollController,
          onPressed: () {
            if (_tabController.index == 0) {
              Navigator.pushNamed(context, '/sales/orders/create');
            } else {
              Navigator.pushNamed(context, '/sales/pfi/create');
            }
          },
          icon: Icon(AppIcons.addRounded, size: 20.r),
          label: _tabController.index == 0 ? 'New Order' : 'New PFI',
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        bottomNavigationBar: _tabController.index == 0
            ? AppGoogleNavBar(
                selectedIndex: 0,
                onTabChange: (idx) {
                  if (idx == 1) {
                    Navigator.pushReplacementNamed(context, '/sales/settings');
                  }
                },
                items: const [
                  AppGoogleNavBarItem(
                      label: 'Orders', icon: AppIcons.shoppingCart),
                  AppGoogleNavBarItem(
                      label: 'Settings', icon: AppIcons.settings),
                ],
                backgroundColor:
                    isDark ? const Color(0xFF151A2E) : Colors.white,
                activeTabBackgroundColor: isDark
                    ? Colors.white12
                    : AppColors.primary.withOpacity(0.15),
                activeColor: AppColors.primary,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              )
            : AppGoogleNavBar(
                selectedIndex: 0,
                onTabChange: (idx) {
                  if (idx == 1) {
                    Navigator.pushNamed(context, '/sales/pfi/settings');
                  }
                },
                items: const [
                  AppGoogleNavBarItem(
                      label: 'PFI', icon: Icons.receipt_long_rounded),
                  AppGoogleNavBarItem(
                      label: 'PFI Settings', icon: AppIcons.settings),
                ],
                backgroundColor:
                    isDark ? const Color(0xFF151A2E) : Colors.white,
                activeTabBackgroundColor: isDark
                    ? Colors.white12
                    : AppColors.primary.withOpacity(0.15),
                activeColor: AppColors.primary,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
      ),
    );
  }

  List<Widget> _buildOrderStats(SalesState state, bool isDark) {
    return state.maybeWhen(
      loaded: (orders, _, __) {
        final Map<String, int> counts = {};
        final Map<String, String?> colors = {};

        for (var o in orders) {
          final sName = o.statusRow?.name ?? 'Unknown';
          counts[sName] = (counts[sName] ?? 0) + 1;
          if (!colors.containsKey(sName)) {
            colors[sName] = o.statusRow?.color;
          }
        }

        final cards = <Widget>[];
        // 1. Total Card
        cards.add(
          DashboardStatCard(
            label: 'Total Orders',
            count: orders.length,
            icon: Icons.shopping_cart_rounded,
            borderColor: AppColors.primary,
          ),
        );

        // 2. Status Cards (Dynamic)
        final sortedKeys = counts.keys.toList()..sort();
        for (var statusName in sortedKeys) {
          cards.add(
            DashboardStatCard(
              label: statusName,
              count: counts[statusName]!,
              icon: _getStatusIcon(statusName),
              borderColor: _parseColor(colors[statusName]),
            ),
          );
        }
        return cards;
      },
      loading: () => List.generate(
        4,
        (_) => const DashboardStatCardSkeleton(),
      ),
      orElse: () => [],
    );
  }

  IconData _getStatusIcon(String status) {
    final s = status.toLowerCase();
    if (s.contains('pending')) return Icons.pending_actions_rounded;
    if (s.contains('complete')) return Icons.check_circle_rounded;
    if (s.contains('process')) return Icons.hourglass_top_rounded;
    if (s.contains('cancel')) return Icons.cancel_rounded;
    if (s.contains('draft')) return Icons.edit_note_rounded;
    if (s.contains('invoice')) return Icons.receipt_long_rounded;
    if (s.contains('approve')) return Icons.assignment_turned_in_rounded;
    return Icons.shopping_bag_rounded; // Default
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.primary;
    try {
      final clean = hex.replaceFirst('#', '');
      final value = int.parse(
        clean.length == 6 ? 'FF$clean' : clean,
        radix: 16,
      );
      return Color(value);
    } catch (_) {
      return AppColors.primary;
    }
  }

  List<Widget> _buildPfiStats(PfiState state, bool isDark) {
    return [
      DashboardStatCard(
        label: 'Total PFIs',
        count: state.pfis.length,
        icon: Icons.receipt_long_rounded,
        borderColor: AppColors.primary,
      ),
      DashboardStatCard(
        label: 'Sent',
        count: state.pfis.where((p) => p.status == 1).length,
        icon: Icons.send_rounded,
        borderColor: Colors.orange,
      ),
      DashboardStatCard(
        label: 'Accepted',
        count: state.pfis.where((p) => p.status == 2).length,
        icon: Icons.check_rounded,
        borderColor: Colors.green,
      ),
    ];
  }

  Widget _buildOrdersList(SalesState state, bool isDark) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => ListView.separated(
        padding: EdgeInsets.all(16.r),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => _buildOrderSkeleton(isDark),
      ),
      error: (msg) => _buildError(
        msg,
        isDark,
        () => ref.read(salesNotifierProvider.notifier).loadOrders(),
      ),
      loaded: (orders, isLoadingMore, hasMore) {
        final filtered = _searchController.text.isEmpty
            ? orders
            : orders.where((o) {
                final q = _searchController.text.toLowerCase();
                return (o.orderNumber?.toLowerCase().contains(q) ?? false) ||
                    (o.customer?.name?.toLowerCase().contains(q) ?? false);
              }).toList();

        if (filtered.isEmpty) {
          return _buildEmptyState(
            isDark,
            _searchController.text.isNotEmpty ||
                (_activeFilter != null && !_activeFilter!.isEmpty),
          );
        }

        // Apply Drawer Filter to Orders
        var finalFiltered = filtered;
        if (_activeFilter != null && !_activeFilter!.isEmpty) {
          finalFiltered = finalFiltered.where((o) {
            // Status filter
            if (_activeFilter!.statusId != null) {
              final status = (o.statusRow?.name?.toLowerCase() ?? '');
              if (status != _activeFilter!.statusId) return false;
            }
            // Staff filter (creator)
            if (_activeFilter!.staffId != null) {
              if (o.user?.id != _activeFilter!.staffId) return false;
            }
            // Date filter
            if (_activeFilter!.dateFrom != null ||
                _activeFilter!.dateTo != null) {
              final dateStr = o.createdAt ?? o.startDate;
              if (dateStr == null) return false;
              final dt = DateTime.tryParse(dateStr.replaceAll(' ', 'T'));
              if (dt == null) return false;
              if (_activeFilter!.dateFrom != null &&
                  dt.isBefore(_activeFilter!.dateFrom!)) {
                return false;
              }
              if (_activeFilter!.dateTo != null &&
                  dt.isAfter(
                    _activeFilter!.dateTo!.add(const Duration(days: 1)),
                  )) {
                return false;
              }
            }
            // Customer filter
            if (_activeFilter!.customer != null &&
                _activeFilter!.customer!.isNotEmpty) {
              final name = o.customer?.name?.toLowerCase() ?? '';
              if (!name.contains(_activeFilter!.customer!.toLowerCase())) {
                return false;
              }
            }
            // Vehicle filter
            if (_activeFilter!.vehicle != null &&
                _activeFilter!.vehicle!.isNotEmpty) {
              // Assuming order might have vehicle info, checking if available
              final vName =
                  o.truckList?.firstOrNull?.vehicleName?.toLowerCase() ?? '';
              if (!vName.contains(_activeFilter!.vehicle!.toLowerCase())) {
                return false;
              }
            }
            return true;
          }).toList();
        }

        if (finalFiltered.isEmpty) return _buildEmptyState(isDark, true);

        return RefreshIndicator(
          onRefresh: () => ref
              .read(salesNotifierProvider.notifier)
              .loadOrders(_mapFilterToParams(_activeFilter)),
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16.r),
            itemCount:
                finalFiltered.length +
                (state.maybeWhen(
                  loaded: (_, isLoadingMore, __) => isLoadingMore ? 1 : 0,
                  orElse: () => 0,
                )),
            itemBuilder: (ctx, i) {
              if (i >= finalFiltered.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return OrderTile(
                order: finalFiltered[i],
                onTap: () => Navigator.pushNamed(
                  context,
                  '/sales/orders/view',
                  arguments: finalFiltered[i],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPfisList(PfiState state, bool isDark) {
    if (state.isLoading && state.pfis.isEmpty) {
      return ListView.separated(
        padding: EdgeInsets.all(16.r),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => _buildPfiSkeleton(isDark),
      );
    }
    if (state.error != null && state.pfis.isEmpty) {
      return _buildError(
        state.error!,
        isDark,
        () => ref.read(pfiNotifierProvider.notifier).loadPfis(),
      );
    }

    final filtered = _searchController.text.isEmpty
        ? state.pfis
        : state.pfis.where((p) {
            final q = _searchController.text.toLowerCase();
            return (p.proposalNumber?.toLowerCase().contains(q) ?? false) ||
                (p.subject?.toLowerCase().contains(q) ?? false);
          }).toList();

    if (filtered.isEmpty) {
      return _buildEmptyState(
        isDark,
        _searchController.text.isNotEmpty ||
            (_activeFilter != null && !_activeFilter!.isEmpty),
      );
    }

    // Apply Drawer Filter to PFIs
    var finalFiltered = filtered;
    if (_activeFilter != null && !_activeFilter!.isEmpty) {
      finalFiltered = finalFiltered.where((p) {
        // Status filter
        if (_activeFilter!.statusId != null) {
          final sId = _activeFilter!.statusId!.toLowerCase();
          final pStatus = p.status ?? -1;
          // Mapping: 0=Draft, 1=Sent, 2=Accepted, 3=Invoiced, 4=Declined
          if (sId == 'pending' && pStatus != 1) return false;
          if (sId == 'completed' && pStatus != 2 && pStatus != 3) return false;
          if (sId == 'cancelled' && pStatus != 4) return false;
          if (sId == 'sent' && pStatus != 1) return false;
          if (sId == 'accepted' && pStatus != 2) return false;
        }
        // Date filter
        if (_activeFilter!.dateFrom != null || _activeFilter!.dateTo != null) {
          final dt = p.createdAt;
          if (dt == null) return false;
          if (_activeFilter!.dateFrom != null &&
              dt.isBefore(_activeFilter!.dateFrom!)) {
            return false;
          }
          if (_activeFilter!.dateTo != null &&
              dt.isAfter(_activeFilter!.dateTo!.add(const Duration(days: 1)))) {
            return false;
          }
        }
        return true;
      }).toList();
    }

    if (finalFiltered.isEmpty) return _buildEmptyState(isDark, true);

    return RefreshIndicator(
      onRefresh: () => ref.read(pfiNotifierProvider.notifier).loadPfis(),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16.r),
        itemCount: finalFiltered.length,
        itemBuilder: (ctx, i) => _PfiTile(pfi: finalFiltered[i]),
      ),
    );
  }

  Widget _buildError(String msg, bool isDark, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.errorOutlineRounded,
            size: 48.r,
            color: Colors.red.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            msg,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 16.h),
          AppButton(text: "Retry", onPressed: onRetry),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? AppIcons.searchOffRounded : AppIcons.file,
            size: 64.r,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            isSearching ? "No results found" : "No items found",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _mapFilterToParams(DrawerFilterValue? filter) {
    final startStr = filter?.dateFrom != null
        ? DateFormat('yyyy-MM-dd').format(filter!.dateFrom!)
        : '2000-01-01';
    final endStr = filter?.dateTo != null
        ? DateFormat('yyyy-MM-dd HH:mm:ss').format(filter!.dateTo!)
        : '2100-12-31 23:59:59';

    final map = <String, dynamic>{
      'draw': '1',
      'search[value]': _searchController.text,
      'search[regex]': 'false',
      'start_date': startStr,
      'end_date': endStr,
    };

    if (filter?.staffId != null) {
      map['user'] = filter!.staffId!.toString();
    }
    if (filter?.customer?.isNotEmpty == true) {
      map['customer'] = filter!.customer!;
    }
    if (filter?.vehicle?.isNotEmpty == true) {
      map['vehicle'] = filter!.vehicle!;
    }
    if (filter?.pickup?.isNotEmpty == true) {
      map['pickup'] = filter!.pickup!;
    }
    if (filter?.delivery?.isNotEmpty == true) {
      map['delivery'] = filter!.delivery!;
    }
    if (filter?.departure?.isNotEmpty == true) {
      map['departure'] = filter!.departure!;
    }
    if (filter?.statusId?.isNotEmpty == true) {
      map['status_id'] = filter!.statusId!;
    }

    return map;
  }

  Widget _buildOrderSkeleton(bool isDark) {
    final base = isDark ? Colors.white12 : Colors.grey.shade200;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      color: isDark ? const Color(0xFF151A2E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                // Removed icon container from skeleton to match the updated UI
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: base,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 100.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: base,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPfiSkeleton(bool isDark) {
    return _buildOrderSkeleton(isDark);
  }
}

class _PfiTile extends StatelessWidget {
  final Pfi pfi;
  const _PfiTile({required this.pfi});

  String _statusLabel(int? s) {
    switch (s) {
      case 0:
        return 'Draft';
      case 1:
        return 'Sent';
      case 2:
        return 'Accepted';
      case 3:
        return 'Invoiced';
      case 4:
        return 'Declined';
      default:
        return 'Unknown';
    }
  }

  Color _statusColor(int? s) {
    switch (s) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/sales/pfi/view', arguments: pfi);
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pfi.proposalNumber ?? '#${pfi.id}',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2634),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            pfi.subject ?? 'No subject',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(pfi.status).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        _statusLabel(pfi.status),
                        style: TextStyle(
                          color: _statusColor(pfi.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      pfi.createdAt != null
                          ? DateFormat.yMMMd().format(pfi.createdAt!)
                          : 'No date',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
