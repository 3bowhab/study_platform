import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/models/student_models/course_response.dart';
import 'package:study_platform/models/student_models/quiz_model.dart';
import 'package:study_platform/models/student_models/section_model.dart';
import 'package:study_platform/services/student/course_details_service.dart';
import 'package:study_platform/services/student/quiz_service.dart';
import 'package:study_platform/views/student_views/quiz_attempt_view.dart';

class CourseDetailsView extends StatefulWidget {
  final int courseId;

  const CourseDetailsView({super.key, required this.courseId});

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<CourseDetailsView> {
  final CourseDetailsService _courseDetailsService = CourseDetailsService();
  final QuizService _quizService = QuizService();

  CourseResponse? course;
  bool isLoading = true;
  String? error;
  bool _isPageLoading = false; // متغير جديد للتحميل على مستوى الصفحة
//المحاولات
  @override
  void initState() {
    super.initState();
    _fetchCourseDetails();
  }

  Future<void> _fetchCourseDetails() async {
    try {
      final data = await _courseDetailsService.getCourseDetails(
        widget.courseId,
      );
      if (!mounted) return;
      setState(() {
        course = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _openQuiz(int sectionId, QuizModel quiz) async {
    if (!mounted) return;
    setState(() {
      _isPageLoading = true;
    });

    try {
      final quizData = await _quizService.getQuiz(
        courseId: widget.courseId,
        sectionId: sectionId,
        quizId: quiz.id,
      );

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizAttemptView(
            courseId: widget.courseId,
            sectionId: sectionId,
            quiz: quizData.copyWith(id: quiz.id),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("فشل تحميل الاختبار: $e")));
    } finally {
      if (mounted) setState(() => _isPageLoading = false);
    }
  }

  String _getFullThumbnail(String? path) {
    if (path == null || path.isEmpty) {
      return "";
    }
    return "https://res.cloudinary.com/dtoy7z1ou/$path";
  }

  Widget _buildSection(SectionModel section, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getSectionIcon(section.contentType),
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      section.title,
                      style: TextStyle(
                        fontFamily: AppFonts.mainFont,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              if (section.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  section.description,
                  style: TextStyle(
                    fontFamily: AppFonts.mainFont,
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (section.durationMinutes != null)
                    _buildInfoChip(
                      icon: Icons.access_time_filled_rounded,
                      text: "${section.durationMinutes} دقيقة",
                    ),
                  if (section.totalViews != null)
                    _buildInfoChip(
                      icon: Icons.visibility,
                      text: "${section.totalViews} مشاهدة",
                    ),
                ],
              ),
              if (section.hasQuiz && section.quiz != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _openQuiz(section.id, section.quiz!),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.quiz_rounded),
                  label: Text(
                    "ابدأ الاختبار: ${section.quiz!.title}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "درجة النجاح: ${section.quiz!.passingScore}% • المحاولات: ${section.quiz!.totalAttempts}/${section.quiz!.maxAttempts}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSectionIcon(String contentType) {
    switch (contentType) {
      case "video":
        return Icons.play_circle_fill_rounded;
      case "pdf":
        return Icons.picture_as_pdf_rounded;
      default:
        return Icons.article_rounded;
    }
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primaryColor),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 12,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            ...[
              RefreshIndicator(
                onRefresh: _fetchCourseDetails,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : error != null
                          ? Center(
                              child: Text(
                              "خطأ: $error",
                              style:
                                  const TextStyle(fontFamily: AppFonts.mainFont),
                            ))
                          : course == null
                              ? const Center(
                                  child: Text(
                                  "لا توجد دورة",
                                  style:
                                      TextStyle(fontFamily: AppFonts.mainFont),
                                ))
                              : CustomScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    SliverAppBar(
                                      expandedHeight: 250,
                                      floating: false,
                                      pinned: true,
                                      iconTheme: const IconThemeData(color: Colors.white),
                                      flexibleSpace: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primaryColor,
                                              AppColors.gradientColor,
                                            ],
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                          ),
                                        ),
                                        child: FlexibleSpaceBar(
                                          title: Text(
                                            course!.course.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: AppFonts.mainFont,
                                            ),
                                          ),
                                          background: course!.course.thumbnail != null &&
                                                  course!.course.thumbnail!.isNotEmpty
                                              ? ColorFiltered(
                                                  colorFilter: ColorFilter.mode(
                                                    Colors.black.withOpacity(0.4),
                                                    BlendMode.darken,
                                                  ),
                                                  child: Image.network(
                                                    _getFullThumbnail(
                                                        course!.course.thumbnail),
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        color: Colors.white.withOpacity(0.2),
                                                        child: const Icon(
                                                          Icons.broken_image,
                                                          size: 50,
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : const Center(
                                                  child: Icon(
                                                    Icons.book,
                                                    size: 80,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "عن الدورة",
                                              style: TextStyle(
                                                fontFamily: AppFonts.mainFont,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              course!.course.description,
                                              style: TextStyle(
                                                fontFamily: AppFonts.mainFont,
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            _buildCourseStats(),
                                            const SizedBox(height: 24),
                                            Text(
                                              "السكاشن",
                                              style: TextStyle(
                                                fontFamily: AppFonts.mainFont,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          return _buildSection(
                                            course!.course.sections[index],
                                            index,
                                          );
                                        },
                                        childCount: course!.course.sections.length,
                                      ),
                                    ),
                              SliverToBoxAdapter(
                                child: const SizedBox(height: 50),
                              ),
                            ],
                                ),
                ),
              ),
              // مؤشر التحميل على مستوى الصفحة
              if (_isPageLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCourseStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.timer,
            value: "${course!.course.durationHours} س",
            label: "المدة",
          ),
          _buildStatItem(
            icon: Icons.article_outlined,
            value: "${course!.course.totalSections}",
            label: "السكاشن",
          ),
          _buildStatItem(
            icon: Icons.group_rounded,
            value: "${course!.course.totalEnrollments}",
            label: "المسجلين",
          ),
          _buildStatItem(
            icon: Icons.star_rate_rounded,
            value: "${course!.course.averageRating}",
            label: "التقييم",
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.mainFont,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.mainFont,
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}