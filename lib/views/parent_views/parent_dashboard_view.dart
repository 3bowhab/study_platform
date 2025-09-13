import 'package:flutter/material.dart';
import 'package:study_platform/widgets/custom_drawer.dart';

class ParentDashboardView extends StatefulWidget {
  const ParentDashboardView({super.key});

  @override
  State<ParentDashboardView> createState() => _ParentDashboardViewState();
}

class _ParentDashboardViewState extends State<ParentDashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard')),
      drawer: CustomDrawer(),
      body: const Center(child: Text('Welcome to the Parent Dashboard!')),
    );
  }
}