import 'package:flutter/material.dart';
import 'package:study_platform/services/student/student_dashboard_service.dart';
import 'package:study_platform/widgets/app_bar.dart';
import 'package:study_platform/widgets/custom_drawer.dart';

class StudentDashboardView extends StatefulWidget {
  const StudentDashboardView({super.key});

  @override
  State<StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends State<StudentDashboardView> {
  final StudentDashboardService _dashboardService = StudentDashboardService();
  dynamic dashboardData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    try {
      final data = await _dashboardService.getStudentDashboard();
      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Student Dashboard")),
        body: Center(child: Text("❌ Error: $errorMessage")),
      );
    }

    return Scaffold(
      appBar: const GradientAppBar(title: "احصائياتى", hasDrawer: true),
      endDrawer: CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("✅ Dashboard Data Loaded:"),
          const SizedBox(height: 10),
          Text(dashboardData.toString()), // مؤقتًا dynamic لحد ما نعمل model
        ],
      ),
    );
  }
}
