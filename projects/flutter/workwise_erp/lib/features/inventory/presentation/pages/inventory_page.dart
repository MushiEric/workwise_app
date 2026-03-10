import 'package:flutter/material.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_tab_bar.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3 , vsync: this); // TODO: implement TabController and TabBarView
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Inventory'),
      drawer: const AppDrawer(),
      body: AppTabBar(
        controller: _tabController, // TODO: implement TabController and TabBarView
        tabs: ['Overview', 'Items', 'History'],
          ),
    );
  }
}
