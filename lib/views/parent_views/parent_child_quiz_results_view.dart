import 'package:flutter/material.dart';
import 'package:study_platform/services/authentication/handle_authentication_error.dart';
import 'package:study_platform/services/parent/parent_child_quiz_results_service.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/views/parent_views/link_child_view.dart';

class ParentChildQuizResultsView extends StatefulWidget {
  const ParentChildQuizResultsView({super.key});

  @override
  State<ParentChildQuizResultsView> createState() =>
      _ParentChildQuizResultsViewState();
}

class _ParentChildQuizResultsViewState
    extends State<ParentChildQuizResultsView> {
  final ParentChildQuizResultsService _quizService =
      ParentChildQuizResultsService();

  Map<String, dynamic>? _quizResults;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuizResults();
  }

  Future<void> _fetchQuizResults() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await _quizService.getFirstChildQuizResults();
      if (!mounted) return;
      setState(() {
        _quizResults = results;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      handleAuthenticationError(context, e.toString());
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  // ✅ ويدجت جديدة لعرض رسالة "لا يوجد أطفال" مع زر
  Widget _buildNoChildrenMessage() {
    // ✅ Wrap the content in a RefreshIndicator
    return RefreshIndicator(
      onRefresh: _fetchQuizResults,
      color: AppColors.primaryColor,
      child: ListView(
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
                    // TODO: Update this to navigate to the correct linking page
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null &&
        _error!.contains("No children found for this parent")) {
      return _buildNoChildrenMessage();
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_quizResults == null || _quizResults!.isEmpty) {
      return const Center(child: Text("لا توجد بيانات متاحة حالياً."));
    }

    final childName = _quizResults!["child"] ?? "الاسم غير متوفر";
    final summary = _quizResults!["summary"] ?? {};
    final courses = (_quizResults!["courses"] as List?) ?? [];

    return RefreshIndicator(
      onRefresh: _fetchQuizResults,
      color: AppColors.primaryColor,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(childName),
            const SizedBox(height: 20),
            _buildSubHeading("الملخص الإجمالي"),
            _buildSummaryCards(summary),
            const SizedBox(height: 20),
            _buildSubHeading("نتائج الدورات"),
            _buildCoursesList(courses),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
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
            "نتائج اختبارات الطالب:",
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
        ],
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> summary) {
    return Column(
      children: [
        _infoCard(
          Icons.school,
          "إجمالي الدورات",
          "${summary["total_courses"] ?? 0}",
        ),
        _infoCard(
          Icons.quiz,
          "إجمالي الاختبارات المكتملة",
          "${summary["total_quizzes_completed"] ?? 0}",
        ),
        // ✅ إضافة خانة الدرجة الكلية
        _infoCard(
          Icons.score,
          "الدرجة الكلية",
          "${(summary["overall_total_score"] ?? 0).toStringAsFixed(1)}",
        ),
        _infoCard(
          Icons.star,
          "المتوسط الإجمالي",
          "${(summary["overall_average"] ?? 0).toStringAsFixed(1)}",
        ),
      ],
    );
  }

  Widget _buildCoursesList(List courses) {
    if (courses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "لا توجد نتائج اختبارات متاحة في الدورات.",
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: AppFonts.mainFont,
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final courseName = course["course_name"] ?? "اسم الدورة غير متوفر";
        final quizzesCompleted = course["quizzes_completed"] ?? 0;
        final averageScore = course["average_score"] ?? 0;

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: AppFonts.mainFont,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "الاختبارات المكتملة: $quizzesCompleted",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontFamily: AppFonts.mainFont,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "المتوسط: ${averageScore.toStringAsFixed(1)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontFamily: AppFonts.mainFont,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontFamily: AppFonts.mainFont,
                  ),
                ),
              ],
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
}
