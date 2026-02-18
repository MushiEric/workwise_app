import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';
import '../providers/operators_providers.dart';
import '../widgets/operator_tile.dart';

class OperatorsPage extends ConsumerStatefulWidget {
  const OperatorsPage({super.key});

  @override
  ConsumerState<OperatorsPage> createState() => _OperatorsPageState();
}

class _OperatorsPageState extends ConsumerState<OperatorsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(operatorsNotifierProvider.notifier).loadOperators();
    });
  }

  Future<void> _refresh() => ref.read(operatorsNotifierProvider.notifier).loadOperators();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(operatorsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: 'Operators'),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: state.when(
          initial: () => const Center(child: SizedBox.shrink()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (msg) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 64, color: isDark ? Colors.red.shade300 : Colors.red.shade400),
                const SizedBox(height: 12),
                Text('Failed to load operators', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2634))),
                const SizedBox(height: 8),
                Text(msg, textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600)),
                const SizedBox(height: 16),
                ElevatedButton.icon(onPressed: _refresh, icon: const Icon(Icons.refresh_rounded), label: const Text('Retry'))
              ],
            ),
          ),
          loaded: (operators) {
            if (operators.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_search, size: 80, color: isDark ? Colors.white24 : Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text('No operators found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                    const SizedBox(height: 8),
                    Text('Operators are managed from the web portal', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600)),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: operators.length,
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                itemBuilder: (context, idx) {
                  final o = operators[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OperatorTile(operatorModel: o, onTap: () {
                      Navigator.pushNamed(context, '/logistic/operators/detail', arguments: o.id);
                    }),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }
}
