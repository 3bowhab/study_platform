import 'package:flutter/material.dart';
import 'package:study_platform/widgets/custom_drawer.dart';

class TeacherDashboardView extends StatefulWidget {
  const TeacherDashboardView({super.key});

  @override
  State<TeacherDashboardView> createState() => _TeacherDashboardViewState();
}

class _TeacherDashboardViewState extends State<TeacherDashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard')),
      drawer: CustomDrawer(),
      body: const Center(child: Text('Welcome to the Teacher Dashboard!')),
    );
  }
}