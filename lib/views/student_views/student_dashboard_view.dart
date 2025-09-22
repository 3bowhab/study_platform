import 'package:flutter/material.dart';
import 'package:study_platform/services/student/student_dashboard_service.dart';
import 'package:study_platform/widgets/app_bar.dart';
import 'package:study_platform/widgets/custom_drawer.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

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
      if (!mounted) {
        return;
      }
      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
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
        appBar: const GradientAppBar(title: "احصائياتى", hasDrawer: true),
        body: Center(child: Text("❌ Error: $errorMessage")),
      );
    }

    final inProgress = dashboardData["in_progress_courses"] ?? 0;
    final completed = dashboardData["completed_courses"] ?? 0;
    final recentActivity = dashboardData["recent_activity"] as List? ?? [];

    return Scaffold(
      appBar: const GradientAppBar(title: "احصائياتى", hasDrawer: true),
      endDrawer: CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: _fetchDashboard, // 🔄 هنا الدالة اللي هتتعاد عند السحب
        child: SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(), // ✅ مهم عشان يشتغل حتى لو المحتوى قصير
          padding: const EdgeInsets.all(16),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📊 Cards for stats
                Row(
                  children: [
                    _buildStatCard("الدورات الجارية", inProgress, AppColors.primaryColor),
                    const SizedBox(width: 12),
                    _buildStatCard("الدورات المكتملة", completed, AppColors.gradientColor),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Activity
                const Text(
                  "🕒 النشاط الأخير",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.mainFont,
                  ),
                ),
                const SizedBox(height: 10),

                if (recentActivity.isEmpty)
                  const Center(
                    child: Text(
                      "لا يوجد نشاط مؤخرًا.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: AppFonts.mainFont,
                      ),
                    ),
                  )
                else
                  Column(
                    children:
                        recentActivity.map((activity) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.history,
                                color: Colors.deepPurple,
                              ),
                              title: Text(
                                activity["title"] ?? "نشاط",
                                style: const TextStyle(
                                  fontFamily: AppFonts.mainFont,
                                ),
                              ),
                              subtitle: Text(
                                activity["time"] ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontFamily: AppFonts.mainFont,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int number, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: AppFonts.mainFont,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: AppFonts.mainFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
