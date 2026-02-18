import 'package:flutter/material.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Inventory'),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Inventory module')),
    );
  }
}
