import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/provider/permission_provider.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/scroll_aware_fab.dart';
import '../../domain/entities/sales_order.dart';
import '../providers/sales_providers.dart';
import '../state/sales_state.dart';
import '../widgets/order_tile.dart';
import 'sales_view_page.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workwise_erp/core/utils/scroll_aware_fab.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesNotifierProvider.notifier).loadOrders();
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
    final state = ref.watch(salesNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    // show/hide global loading dialog on state transition
    ref.listen<SalesState>(salesNotifierProvider, (prev, next) {
      final prevLoading =
          prev?.maybeWhen(loading: () => true, orElse: () => false) ?? false;
      final nextLoading = next.maybeWhen(
        loading: () => true,
        orElse: () => false,
      );
      if (prevLoading == nextLoading) return;
      if (nextLoading) {
        showAppLoadingDialog(context, message: 'Fetching orders...');
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
          title: "Sales Orders",
          actions: [
            if (!_isSearching)
              IconButton(
                icon: Icon(
                  LucideIcons.search,
                  size: 20,
                  color: isDark ? Colors.white70 : AppColors.white,
                ),
                onPressed: () {
                  setState(() => _isSearching = true);
                },
              ),
            IconButton(
              icon: Icon(
                LucideIcons.sliders,  
                size: 20,
                color: isDark ? Colors.white70 : AppColors.white,
              ),
              onPressed: _showFilterOptions,
            ),
            // Quick link to PFIs (permission guarded)
            Builder(builder: (ctx) {
              final checker = ref.watch(permissionCheckerProvider);
              if (!checker.hasPermission('show PFI')) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  LucideIcons.fileText,
                  size: 20,
                  color: isDark ? Colors.white70 : AppColors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, '/pfi'),
              );
            }),
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
                        hintText: 'Search orders...',
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
                      'Total Orders',
                      _getOrderCount(state),
                      Icons.shopping_cart_rounded,
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
        
        // Quick Create FAB (scroll-aware)
        floatingActionButton: ScrollAwareFab(
          controller: _scrollController,
          onPressed: () {
            // Navigate to create order
          },
          icon: const Icon(Icons.add_rounded),
          label: 'New Order',
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildBody(SalesState state, bool isDark) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const Center(
        
      ),
      error: (msg) => Center(
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
                'Failed to load orders',
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
                onPressed: () => ref.read(salesNotifierProvider.notifier).loadOrders(),
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
      loaded: (orders) {
        // Filter orders based on search
        final filteredOrders = _searchController.text.isEmpty
            ? orders
            : orders.where((order) {
                final searchTerm = _searchController.text.toLowerCase();
                return (order.orderNumber?.toLowerCase().contains(searchTerm) ?? false) ||
                       (order.customer?.name?.toLowerCase().contains(searchTerm) ?? false);
              }).toList();

        if (filteredOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _searchController.text.isEmpty
                      ? Icons.shopping_cart_outlined
                      : Icons.search_off_rounded,
                  size: 80,
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchController.text.isEmpty
                      ? 'No orders found'
                      : 'No matching orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _searchController.text.isEmpty
                      ? 'Create your first sales order'
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
          onRefresh: () => ref.read(salesNotifierProvider.notifier).loadOrders(),
          color: AppColors.primary,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: filteredOrders.length,
            itemBuilder: (context, idx) {
              final SalesOrder order = filteredOrders[idx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OrderTile(
                  order: order,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SalesViewPage(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
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
          ),
        ],
      ),
    );
  }

  int _getOrderCount(SalesState state) {
    return state.maybeWhen(
      loaded: (orders) => orders.length,
      orElse: () => 0,
    );
  }

  int _getPendingCount(SalesState state) {
    return state.maybeWhen(
      loaded: (orders) => orders.where((o) {
        final status = o.statusRow?.name?.toLowerCase() ?? '';
        return status == 'pending' || status == 'processing';
      }).length,
      orElse: () => 0,
    );
  }

  int _getCompletedCount(SalesState state) {
    return state.maybeWhen(
      loaded: (orders) => orders.where((o) {
        final status = o.statusRow?.name?.toLowerCase() ?? '';
        return status == 'completed' || status == 'delivered';
      }).length,
      orElse: () => 0,
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
                'Filter Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('Status', 'All', Icons.flag_rounded),
              _buildFilterOption('Date Range', 'Last 30 days', Icons.date_range_rounded),
              _buildFilterOption('Customer', 'All customers', Icons.people_rounded),
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