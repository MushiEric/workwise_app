import 'package:flutter/material.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';

class HRPage extends StatelessWidget {
  const HRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'HR'),
      drawer: const AppDrawer(),
      body: const Center(child: Text('HR module')),
    );
  }
}
