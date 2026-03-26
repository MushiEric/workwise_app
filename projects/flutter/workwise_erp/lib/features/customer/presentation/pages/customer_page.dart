import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_modal.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../state/customers_state.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_contact.dart';
import '../providers/customer_providers.dart';

// ─────────────────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────────────────

class CustomerPage extends ConsumerStatefulWidget {
  const CustomerPage({super.key});

  @override
  ConsumerState<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends ConsumerState<CustomerPage> {
  int _tab = 0;
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isSearching = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // kick off initial load
      ref.read(customersNotifierProvider.notifier).loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // listen inside build (allowed) to show/hide loading dialog
    ref.listen<CustomersState>(customersNotifierProvider, (previous, next) {
      final starting = next.maybeWhen(loading: () => true, orElse: () => false);
      final wasLoading = previous?.maybeWhen(loading: () => true, orElse: () => false) ?? false;
      if (starting && !wasLoading) {
        showAppLoadingDialog(context, message: 'Fetching customers...');
      } else if (!starting && wasLoading) {
        hideAppLoadingDialog(context);
      }
    });

    final primary = AppColors.primary;
    return Scaffold(
      appBar: CustomAppBar(
        foregroundColor: Colors.white, // icons/text on appbar should contrast against blue background
        title: const ['Customers', 'Contacts', 'Settings'][_tab],
        actions: [
          if (_tab == 0) ...[
            IconButton(
              icon: Icon(
                _isSearching ? LucideIcons.x : LucideIcons.search,
                // color left to appbar foregroundColor
              ),
              tooltip: _isSearching ? 'Close search' : 'Search',
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _query = '';
                    _searchCtrl.clear();
                  }
                  _isSearching = !_isSearching;
                });
              },
            ),
            
          ],
          if (_tab == 1)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: () =>
                  ref.read(contactsNotifierProvider.notifier).reset(),
            ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          if (_tab == 0 && _isSearching)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search customers…',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: [
                _CustomerListTab(
                  query: _query,
                  searchCtrl: _searchCtrl,
                  onQueryChanged: (v) => setState(() => _query = v),
                ),
                const _ContactsTab(),
                const _SettingsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_rounded),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tab 1 — Customer List (scrollable table)
// ─────────────────────────────────────────────────────────

class _CustomerListTab extends ConsumerWidget {
  const _CustomerListTab({
    required this.query,
    required this.searchCtrl,
    required this.onQueryChanged,
  });

  final String query;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(customersNotifierProvider);

    List<Customer> filter(List<Customer> all) {
      if (query.isEmpty) return all;
      final q = query.toLowerCase();
      return all.where((c) {
        return (c.name?.toLowerCase().contains(q) ?? false) ||
            (c.shortName?.toLowerCase().contains(q) ?? false) ||
            (c.email?.toLowerCase().contains(q) ?? false) ||
            (c.phone?.contains(q) ?? false) ||
            (c.taxNumber?.toLowerCase().contains(q) ?? false) ||
            (c.vrn?.toLowerCase().contains(q) ?? false) ||
            (c.customerNumber?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    return Column(
      children: [
        // search bar is provided by parent
        const SizedBox(height: 8),
        // Table body
        Expanded(
          child: state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (msg) => _ErrorBody(
              message: msg,
              onRetry: () => ref
                  .read(customersNotifierProvider.notifier)
                  .loadCustomers(),
            ),
            loaded: (customers) {
              final filtered = filter(customers);
              if (filtered.isEmpty) {
                return _EmptyBody(
                  icon: Icons.people_outline_rounded,
                  label: query.isNotEmpty
                      ? 'No customers match your search'
                      : 'No customers found',
                  onClear: query.isNotEmpty
                      ? () {
                          searchCtrl.clear();
                          onQueryChanged('');
                        }
                      : null,
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref
                    .read(customersNotifierProvider.notifier)
                    .loadCustomers(),
                child: _CustomerTable(customers: filtered, isDark: isDark),
              );
            },
          ),
        ),
      ],
    );
  }
}
// ── Horizontally scrollable DataTable ───────────────────

class _CustomerTable extends StatelessWidget {
  final List<Customer> customers;
  final bool isDark;

  const _CustomerTable({required this.customers, required this.isDark});

  String _fmt(String? v) => (v == null || v.trim().isEmpty || v == 'null') ? '—' : v;

  String _fmtBalance(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '—';
    final d = double.tryParse(raw);
    if (d == null) return raw;
    final abs = d.abs();
    final sign = d < 0 ? '-' : '';
    // format with commas
    final parts = abs.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return '$sign$whole.${parts[1]}';
  }

  Color _balanceColor(String? raw) {
    final d = double.tryParse(raw ?? '');
    if (d == null) return Colors.grey;
    if (d < 0) return Colors.red.shade600;
    if (d > 0) return Colors.green.shade600;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: isDark ? Colors.white70 : AppColors.primary,
      letterSpacing: 0.5,
    );
    final cellStyle = TextStyle(
      fontSize: 13,
      color: isDark ? Colors.white : const Color(0xFF1A2634),
    );
    final mutedStyle = TextStyle(
      fontSize: 12,
      color: isDark ? Colors.white54 : Colors.grey.shade600,
    );

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: DataTable(
            headingRowHeight: 44,
            dataRowMinHeight: 52,
            dataRowMaxHeight: 68,
            columnSpacing: 20,
            headingRowColor: WidgetStateProperty.all(
              isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.primary.withValues(alpha: 0.06),
            ),
            border: TableBorder(
              horizontalInside: BorderSide(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 0.8,
              ),
            ),
            columns: [
              DataColumn(label: Text('S/N', style: headerStyle)),
              DataColumn(label: Text('CUSTOMER NAME', style: headerStyle)),
              DataColumn(label: Text('SHORT NAME', style: headerStyle)),
              DataColumn(label: Text('PHONE', style: headerStyle)),
              DataColumn(label: Text('EMAIL', style: headerStyle)),
              DataColumn(label: Text('TIN', style: headerStyle)),
              DataColumn(label: Text('VRN', style: headerStyle)),
              DataColumn(label: Text('CURRENCY', style: headerStyle)),
              DataColumn(
                  label: Text('BALANCE', style: headerStyle),
                  numeric: true),
            ],
            rows: List.generate(customers.length, (i) {
              final c = customers[i];
              final balFmt = _fmtBalance(c.balance);
              final balColor = _balanceColor(c.balance);
              final currency = c.currencySymbol ?? c.currencyCode ?? '—';

              return DataRow(
                cells: [
                  DataCell(Text('${i + 1}', style: mutedStyle)),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fmt(c.name),
                          style: cellStyle.copyWith(
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (c.customerNumber != null)
                          Text(c.customerNumber!, style: mutedStyle),
                      ],
                    ),
                  ),
                  DataCell(Text(_fmt(c.shortName), style: cellStyle)),
                  DataCell(Text(_fmt(c.phone), style: cellStyle)),
                  DataCell(
                    SizedBox(
                      width: 160,
                      child: Text(
                        _fmt(c.email),
                        style: cellStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(Text(_fmt(c.taxNumber), style: cellStyle)),
                  DataCell(Text(_fmt(c.vrn), style: cellStyle)),
                  DataCell(Text(currency, style: cellStyle)),
                  DataCell(
                    Text(
                      balFmt,
                      style: cellStyle.copyWith(
                        color: balColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tab 2 — Contacts
// ─────────────────────────────────────────────────────────

class _ContactsTab extends ConsumerStatefulWidget {
  const _ContactsTab();

  @override
  ConsumerState<_ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends ConsumerState<_ContactsTab> {
  Customer? _selectedCustomer;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openCustomerPicker(List<Customer> customers) {
    AppModal.show(
      context: context,
      title: 'Select Customer',
      icon: Icons.people_rounded,
      iconColor: AppColors.primary,
      expandContent: true,
      content: _CustomerPickerContent(
        customers: customers,
        selected: _selectedCustomer,
        onSelect: (c) {
          Navigator.pop(context);
          setState(() => _selectedCustomer = c);
          if (c.id != null) {
            ref
                .read(contactsNotifierProvider.notifier)
                .loadContacts(c.id!, c.name ?? '');
          }
        },
      ),
    );
  }

  List<CustomerContact> _filter(List<CustomerContact> all) {
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all.where((c) {
      return (c.name?.toLowerCase().contains(q) ?? false) ||
          (c.email?.toLowerCase().contains(q) ?? false) ||
          (c.phone?.contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final customersState = ref.watch(customersNotifierProvider);
    final contactsState = ref.watch(contactsNotifierProvider);

    final customers = customersState.maybeWhen(
      loaded: (list) => list,
      orElse: () => <Customer>[],
    );

    return Column(
      children: [
        // ── Customer selector ──────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: GestureDetector(
            onTap: customers.isEmpty
                ? null
                : () => _openCustomerPicker(customers),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedCustomer != null
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.people_rounded,
                      size: 20,
                      color: isDark
                          ? Colors.white54
                          : Colors.grey.shade500),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedCustomer?.name ?? 'Select a customer…',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedCustomer != null
                            ? (isDark ? Colors.white : const Color(0xFF1A2634))
                            : (isDark
                                ? Colors.white38
                                : Colors.grey.shade400),
                        fontWeight: _selectedCustomer != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Icon(Icons.expand_more_rounded,
                      size: 20,
                      color: isDark ? Colors.white38 : Colors.grey.shade500),
                ],
              ),
            ),
          ),
        ),

        // ── Search (only when contacts loaded) ────────────
        if (_selectedCustomer != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                hintText: 'Search contacts…',
                hintStyle: TextStyle(
                    fontSize: 14,
                    color:
                        isDark ? Colors.white38 : Colors.grey.shade400),
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColors.surfaceVariantLight,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
        ],

        const SizedBox(height: 8),

        // ── Content area ───────────────────────────────────
        Expanded(
          child: _selectedCustomer == null
              ? _EmptyBody(
                  icon: Icons.contacts_rounded,
                  label: 'Select a customer to view contacts',
                )
              : contactsState.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (msg) => _ErrorBody(
                    message: msg,
                    onRetry: () => ref
                        .read(contactsNotifierProvider.notifier)
                        .loadContacts(
                          _selectedCustomer!.id!,
                          _selectedCustomer!.name ?? '',
                        ),
                  ),
                  loaded: (contacts) {
                    final filtered = _filter(contacts);
                    if (filtered.isEmpty) {
                      return _EmptyBody(
                        icon: Icons.person_search_rounded,
                        label: _query.isNotEmpty
                            ? 'No contacts match your search'
                            : 'No contacts for this customer',
                        onClear: _query.isNotEmpty
                            ? () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              }
                            : null,
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () => ref
                          .read(contactsNotifierProvider.notifier)
                          .loadContacts(
                            _selectedCustomer!.id!,
                            _selectedCustomer!.name ?? '',
                          ),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ContactCard(
                              contact: filtered[i], isDark: isDark),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ── Customer picker content (inside modal) ────────────────

class _CustomerPickerContent extends StatefulWidget {
  final List<Customer> customers;
  final Customer? selected;
  final ValueChanged<Customer> onSelect;

  const _CustomerPickerContent({
    required this.customers,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_CustomerPickerContent> createState() => _CustomerPickerContentState();
}

class _CustomerPickerContentState extends State<_CustomerPickerContent> {
  String _q = '';
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _q.isEmpty
        ? widget.customers
        : widget.customers.where((c) {
            return (c.name?.toLowerCase().contains(_q) ?? false) ||
                (c.shortName?.toLowerCase().contains(_q) ?? false);
          }).toList();

    return Column(
      children: [
        TextField(
          controller: _ctrl,
          onChanged: (v) => setState(() => _q = v.toLowerCase()),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded, size: 18),
            hintText: 'Search…',
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.surfaceVariantLight,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
        const SizedBox(height: 12),
        ...filtered.map((c) {
          final isSelected = widget.selected?.id == c.id;
          return ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                (c.name?.isNotEmpty == true ? c.name![0] : '?')
                    .toUpperCase(),
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              c.name ?? '—',
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? Colors.white
                        : const Color(0xFF1A2634)),
              ),
            ),
            subtitle: c.shortName != null
                ? Text(c.shortName!,
                    style: const TextStyle(fontSize: 12))
                : null,
            trailing: isSelected
                ? Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 20)
                : null,
            onTap: () => widget.onSelect(c),
          );
        }),
      ],
    );
  }
}

// ── Contact card widget ──────────────────────────────────

class _ContactCard extends StatelessWidget {
  final CustomerContact contact;
  final bool isDark;

  const _ContactCard({required this.contact, required this.isDark});

  String _yesNo(int? v) {
    if (v == null) return '—';
    return v == 1 ? 'YES' : 'NO';
  }

  Color _yesNoColor(int? v) {
    if (v == null) return Colors.grey;
    return v == 1 ? Colors.green.shade600 : Colors.red.shade500;
  }

  String _formatLastLogin(String? v) {
    if (v == null) return 'Never';
    try {
      final dt = DateTime.parse(v.replaceFirst(' ', 'T'));
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return v;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = (contact.name?.isNotEmpty == true
            ? contact.name!.trim().split(' ').take(2).map((w) => w[0]).join()
            : '?')
        .toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: avatar + name/email/phone ─────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: (contact.profile != null &&
                          contact.profile!.isNotEmpty)
                      ? NetworkImage(contact.profile!)
                      : null,
                  child: (contact.profile == null || contact.profile!.isEmpty)
                      ? Text(
                          initials,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name ?? '—',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A2634),
                        ),
                      ),
                      if (contact.email != null) ...[
                        const SizedBox(height: 3),
                        _IconText(
                            icon: Icons.email_outlined,
                            text: contact.email!,
                            isDark: isDark),
                      ],
                      if (contact.phone != null) ...[
                        const SizedBox(height: 3),
                        _IconText(
                            icon: Icons.phone_outlined,
                            text: contact.phone!,
                            isDark: isDark),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(
                height: 1,
                color: isDark ? Colors.white10 : Colors.grey.shade100),
            const SizedBox(height: 10),

            // ── Customer name ──────────────────────────────
            if (contact.customerName != null)
              _LabelValue(
                label: 'Customer',
                value: contact.customerName!,
                isDark: isDark,
                valueStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),

            const SizedBox(height: 8),

            // ── Permissions grid ───────────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PermBadge(
                  label: 'PFI View',
                  value: _yesNo(contact.pfiView),
                  color: _yesNoColor(contact.pfiView),
                ),
                _PermBadge(
                  label: 'PFI Approve',
                  value: _yesNo(contact.pfiApprove),
                  color: _yesNoColor(contact.pfiApprove),
                ),
                _PermBadge(
                  label: 'Jobcard View',
                  value: _yesNo(contact.jobcardView),
                  color: _yesNoColor(contact.jobcardView),
                ),
                _PermBadge(
                  label: 'Jobcard Approve',
                  value: _yesNo(contact.jobcardApprove),
                  color: _yesNoColor(contact.jobcardApprove),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Last login ─────────────────────────────────
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 14,
                    color: isDark ? Colors.white38 : Colors.grey.shade400),
                const SizedBox(width: 5),
                Text(
                  'Last login: ${_formatLastLogin(contact.lastLoginAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  const _IconText({required this.icon, required this.text, required this.isDark});
  @override
  Widget build(BuildContext context) {
    final color = isDark ? Colors.white54 : Colors.grey.shade600;
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(text,
              style: TextStyle(fontSize: 12, color: color),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final TextStyle? valueStyle;
  const _LabelValue(
      {required this.label,
      required this.value,
      required this.isDark,
      this.valueStyle});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.grey.shade600),
        ),
        Expanded(
          child: Text(
            value,
            style: valueStyle ??
                TextStyle(
                    fontSize: 13,
                    color:
                        isDark ? Colors.white : const Color(0xFF1A2634)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _PermBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _PermBadge(
      {required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: value == '—'
            ? Colors.grey.withValues(alpha: 0.08)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: value == '—'
                ? Colors.grey.withValues(alpha: 0.2)
                : color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: value == '—' ? Colors.grey : color),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tab 3 — Settings (blank)
// ─────────────────────────────────────────────────────────

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_rounded,
              size: 72,
              color: isDark ? Colors.white24 : Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 60,
                color: isDark ? Colors.red.shade300 : Colors.red.shade400),
            const SizedBox(height: 16),
            Text('Failed to load',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634))),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade600)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onClear;
  const _EmptyBody({required this.icon, required this.label, this.onClear});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 72,
              color: isDark ? Colors.white24 : Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey.shade600)),
          if (onClear != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onClear, child: const Text('Clear filters')),
          ],
        ],
      ),
    );
  }
}
