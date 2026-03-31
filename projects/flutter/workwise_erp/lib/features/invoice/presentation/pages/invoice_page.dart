import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/invoice_providers.dart';
import '../../presentation/state/invoice_state.dart';
import '../widgets/invoice_tile.dart';

class InvoicePage extends ConsumerWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text('Error: ${state.error}'))
          : ListView.builder(
              itemCount: state.invoices.length,
              itemBuilder: (ctx, i) => InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/sales/invoices/view',
                    arguments: state.invoices[i],
                  );
                },
                child: InvoiceTile(invoice: state.invoices[i]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
