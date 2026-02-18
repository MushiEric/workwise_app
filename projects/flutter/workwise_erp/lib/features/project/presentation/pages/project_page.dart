import 'package:flutter/material.dart';
import '../../../../core/widgets/app_drawer.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Project module (placeholder)')),
    );
  }
}
