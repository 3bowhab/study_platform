import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/course_model.dart';
import 'package:study_platform/services/authentication/handle_authentication_error.dart';
import 'package:study_platform/services/teacher/teacher_courses_service.dart';
import 'package:study_platform/views/teacher_views/add_course_view.dart';
import 'package:study_platform/views/teacher_views/teacher_sections_view.dart';
import 'package:study_platform/views/teacher_views/edit_course_view.dart';
import 'package:study_platform/widgets/custom_drawer.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

class TeacherCoursesView extends StatefulWidget {
  const TeacherCoursesView({super.key});

  @override
  State<TeacherCoursesView> createState() => _TeacherCoursesViewState();
}

class _TeacherCoursesViewState extends State<TeacherCoursesView> {
  final TeacherCoursesService _service = TeacherCoursesService();
  late Future<List<CourseModel>> _futureCourses;

  @override
  void initState() {
    super.initState();
    _futureCourses = _service.getAllTeacherCourses().catchError((e) {
      handleAuthenticationError(context, e.toString());
      return <
        CourseModel
      >[]; // Return an empty list to prevent the app from crashing
    });
  }

  Future<void> _refreshCourses() async {
    setState(() {
      _futureCourses = _service.getAllTeacherCourses().catchError((e) {
        handleAuthenticationError(context, e.toString());
        return <CourseModel>[];
      });
    });
  }

  // 💡 وظيفة مساعدة لتحويل رابط الصورة
  String _getFullThumbnail(String? path) {
    if (path == null || path.isEmpty) return "";
    return "https://res.cloudinary.com/dtoy7z1ou/$path";
  }

  // 💡 وظيفة مساعدة لبناء الشرائح (chips)
  Widget _buildInfoChip(String label, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 16, color: color),
          if (icon != null) const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.mainFont,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 💡 وظيفة لإضافة دورة
  void _addCourse() async {
    final added = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCourseView()),
    );
    if (mounted && added == true) {
      _refreshCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "📚 دوراتي",
          style: TextStyle(
            fontFamily: AppFonts.mainFont,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder<List<CourseModel>>(
          future: _futureCourses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "❌ Error: ${snapshot.error}",
                  style: const TextStyle(fontFamily: AppFonts.mainFont),
                ),
              );
            }
            final courses = snapshot.data ?? [];
            if (courses.isEmpty) {
              return const Center(
                child: Text(
                  "لا توجد دورات حاليًا.",
                  style: TextStyle(fontSize: 16, fontFamily: AppFonts.mainFont),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshCourses,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => TeacherSectionsView(course: course),
                            ),
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child:
                                    course.thumbnail != null &&
                                            course.thumbnail!.isNotEmpty
                                        ? Image.network(
                                          _getFullThumbnail(course.thumbnail),
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.1),
                                              child: const Icon(
                                                Icons.broken_image,
                                                size: 60,
                                                color: Colors.black45,
                                              ),
                                            );
                                          },
                                        )
                                        : Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.primaryColor,
                                                AppColors.gradientColor,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.book,
                                            size: 60,
                                            color: Colors.white70,
                                          ),
                                        ),
                              ),
                              if (course.price != null && course.price! > 0)
                                Container(
                                  margin: const EdgeInsets.all(12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "\$${course.price!.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontFamily: AppFonts.mainFont,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  margin: const EdgeInsets.all(12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.successColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "مجاني",
                                    style: TextStyle(
                                      fontFamily: AppFonts.mainFont,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        course.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: AppFonts.mainFont,
                                          color: AppColors.primaryColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: AppColors.primaryColor,
                                      ),
                                      tooltip: "تعديل الدورة",
                                      onPressed: () async {
                                        final updated = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => EditCourseView(
                                                  course: course,
                                                ),
                                          ),
                                        );
                                        if (mounted && updated == true) {
                                          _refreshCourses();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  course.description,
                                  style: TextStyle(
                                    fontFamily: AppFonts.mainFont,
                                    color: Colors.grey[800],
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildInfoChip(
                                      course.teacherName,
                                      AppColors.primaryColor,
                                      icon: Icons.person_rounded,
                                    ),
                                    _buildInfoChip(
                                      course.difficulty,
                                      AppColors.secondaryColor,
                                      icon: Icons.school_rounded,
                                    ),
                                    _buildInfoChip(
                                      "${course.averageRating?.toStringAsFixed(1) ?? '0.0'}",
                                      Colors.amber,
                                      icon: Icons.star,
                                    ),
                                    _buildInfoChip(
                                      "${course.totalSections ?? 0} قسم",
                                      Colors.purple,
                                      icon: Icons.article_outlined,
                                    ),
                                    _buildInfoChip(
                                      "${course.totalQuizzes ?? 0} اختبار",
                                      Colors.teal,
                                      icon: Icons.quiz,
                                    ),
                                    _buildInfoChip(
                                      "${course.totalEnrollments ?? 0} مشترك",
                                      Colors.indigo,
                                      icon: Icons.people_alt_rounded,
                                    ),
                                    _buildInfoChip(
                                      "${course.durationHours ?? 0} ساعة",
                                      Colors.orange,
                                      icon: Icons.access_time_rounded,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCourse,
        label: const Text(
          'أضف دورة جديدة',
          style: TextStyle(fontFamily: AppFonts.mainFont),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.secondaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
