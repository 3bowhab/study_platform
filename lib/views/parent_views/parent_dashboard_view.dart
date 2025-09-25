import 'package:flutter/material.dart';
import 'package:study_platform/services/authentication/handle_authentication_error.dart';
import 'package:study_platform/services/parent/parent_child_progress_service.dart';
import 'package:study_platform/views/parent_views/link_child_view.dart';
import 'package:study_platform/views/parent_views/parent_child_quiz_results_view.dart';
import 'package:study_platform/widgets/app_bar.dart';
import 'package:study_platform/widgets/custom_drawer.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

class ParentDashboardView extends StatefulWidget {
  const ParentDashboardView({super.key});

  @override
  State<ParentDashboardView> createState() => _ParentDashboardViewState();
}

class _ParentDashboardViewState extends State<ParentDashboardView> {
  int _selectedIndex = 0;

  final ParentChildProgressService _progressService =
      ParentChildProgressService();

  Map<String, dynamic>? _childProgress;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final progress = await _progressService.getFirstChildProgress();
      if (!mounted) return;
      setState(() {
        _childProgress = progress;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      handleAuthenticationError(context, e.toString());

      if (!mounted) return;
      setState(() {
        // ✅ Store the error message
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (!mounted) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages => [
    _buildProgressPage(),
    const ParentChildQuizResultsView(),
  ];

  // ✅ New widget to show the "no children found" message and button
  Widget _buildNoChildrenMessage() {
    return RefreshIndicator(
      onRefresh: _fetchProgress,
      color: AppColors.primaryColor,
      child: ListView(
        // ✅ استخدم ListView لجعل السحب للأسفل ممكنا
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  "لا يوجد أطفال مرتبطين بهذا الحساب.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontFamily: AppFonts.mainFont,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "قم بربط حسابك بحساب أحد الطلاب للاطلاع على تقدمه.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontFamily: AppFonts.mainFont,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LinkChildView(),
                      ),
                    );
                    print("Navigate to linking page");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "ربط حساب طالب",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: AppFonts.mainFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressPage() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    // ✅ Check for the specific error message
    if (_error != null &&
        _error!.contains("No children found for this parent")) {
      return _buildNoChildrenMessage();
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_childProgress == null) {
      return const Center(child: Text("لا يوجد بيانات حالياً"));
    }

    final summary = _childProgress!["overall_summary"];
    final child = _childProgress!["child"];
    final courses = (_childProgress!["courses"] as List?) ?? [];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator(
        onRefresh: _fetchProgress,
        color: AppColors.primaryColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader("${child["name"]}", child["username"]),
            const SizedBox(height: 20),
            _infoCard("📚 إجمالي الكورسات", "${summary["total_courses"]}"),
            _infoCard(
              "✅ الأقسام المكتملة",
              "${summary["total_sections_completed"]}",
            ),
            _infoCard("📖 إجمالي الأقسام", "${summary["total_sections"]}"),
            _infoCard(
              "📊 نسبة الإكمال",
              "${summary["overall_completion_percentage"]}%",
            ),
            const SizedBox(height: 20),
            _buildSubHeading("الدورات المشترك بها"),
            _buildCoursesList(courses),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String username) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor, AppColors.gradientColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ملخص تقدم الطالب:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              fontFamily: AppFonts.mainFont,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: AppFonts.mainFont,
            ),
          ),
          Text(
            "(${username})",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontFamily: AppFonts.mainFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeading(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
          fontFamily: AppFonts.mainFont,
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontFamily: AppFonts.mainFont,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontFamily: AppFonts.mainFont,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesList(List courses) {
    if (courses.isEmpty) {
      return const Center(child: Text("لم يشترك الطالب في أي دورات بعد."));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final courseName = course["course_name"] ?? "اسم الدورة غير متوفر";
        final sectionsCompleted = course["sections_completed"] ?? 0;
        final totalSections = course["total_sections"] ?? 0;
        final completionPercentage = course["completion_percentage"] ?? 0;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.mainFont,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "الأقسام المكتملة: $sectionsCompleted من $totalSections",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: AppFonts.mainFont,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: completionPercentage / 100,
                  backgroundColor: Colors.grey[300],
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 5),
                Text(
                  "نسبة الإكمال: ${completionPercentage.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.mainFont,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration:
            isSelected
                ? BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                )
                : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, size: isSelected ? 28 : 24, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const GradientAppBar(title: "لوحة ولي الأمر", hasDrawer: true),
      endDrawer: const CustomDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 50, top: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryColor, AppColors.gradientColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.insights, "التقدم", 0),
              _buildBottomNavItem(Icons.quiz, "نتائج الكويزات", 1),
            ],
          ),
        ),
      ),
    );
  }
}
