// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/models/student_models/course_model.dart';
import 'package:study_platform/services/student/post_enrollment_service.dart';
import 'package:study_platform/services/student/student_courses_service.dart';
import 'package:study_platform/widgets/app_bar.dart'; // Make sure this import is correct
import 'package:study_platform/widgets/custom_drawer.dart';

class StudentCoursesView extends StatefulWidget {
  const StudentCoursesView({super.key});

  @override
  State<StudentCoursesView> createState() => _StudentCoursesViewState();
}

class _StudentCoursesViewState extends State<StudentCoursesView> {
  final StudentCoursesService _coursesService = StudentCoursesService();
  final PostEnrollmentService _enrollmentService = PostEnrollmentService();

  List<CourseModel> courses = [];
  bool isLoading = true;
  String? errorMessage;

  final Set<int> _enrollingIds = {};
  final Set<int> _enrolledIds = {};
  final Set<int> _expandedIds = {};

  String _getFullThumbnail(String? path) {
    if (path == null || path.isEmpty) return "";
    return "https://res.cloudinary.com/dtoy7z1ou/$path";
  }

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final data = await _coursesService.getAllCourses();
      if (!mounted) return;
      setState(() {
        courses = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _enrollCourse(CourseModel course) async {
    if (!mounted) return;
    setState(() => _enrollingIds.add(course.id));
    try {
      await _enrollmentService.enrollTemporarySingle(course.id);
      if (!mounted) return;
      setState(() => _enrolledIds.add(course.id));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تم الاشتراك في ${course.title}",
            style: const TextStyle(fontFamily: AppFonts.mainFont),
          ),
          backgroundColor: AppColors.successColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      if (e.toString().contains("Already enrolled")) {
        setState(() => _enrolledIds.add(course.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "أنت مشترك بالفعل في ${course.title}",
              style: const TextStyle(fontFamily: AppFonts.mainFont),
            ),
            backgroundColor: AppColors.errorColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "❌ حصل خطأ: $e",
              style: const TextStyle(fontFamily: AppFonts.mainFont),
            ),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (!mounted) return;
      setState(() => _enrollingIds.remove(course.id));
    }
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: "الدورات", hasDrawer: true),
      endDrawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: _fetchCourses,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(
                    child: Text(
                      "❌ $errorMessage",
                      style: const TextStyle(fontFamily: AppFonts.mainFont),
                    ),
                  )
                  : Directionality(
                    textDirection: TextDirection.rtl,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, i) {
                              final c = courses[i];
                              final isEnrolling = _enrollingIds.contains(c.id);
                              final isEnrolled = _enrolledIds.contains(c.id);
                              final isExpanded = _expandedIds.contains(c.id);
                        
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: BorderSide(
                                    color:
                                        isExpanded
                                            ? AppColors.primaryColor
                                            : Colors.transparent,
                                    width: isExpanded ? 2 : 0,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isExpanded) {
                                        _expandedIds.remove(c.id);
                                      } else {
                                        _expandedIds.add(c.id);
                                      }
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child:
                                                c.thumbnail != null &&
                                                        c.thumbnail!.isNotEmpty
                                                    ? Image.network(
                                                      _getFullThumbnail(
                                                        c.thumbnail,
                                                      ),
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color: AppColors
                                                              .primaryColor
                                                              .withOpacity(0.1),
                                                          child: const Icon(
                                                            Icons.broken_image,
                                                            size: 60,
                                                            color:
                                                                Colors.black45,
                                                          ),
                                                        );
                                                      },
                                                    )
                                                    : Container(
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            AppColors
                                                                .primaryColor,
                                                            AppColors
                                                                .gradientColor,
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.book,
                                                        size: 60,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                          ),
                                          if (c.price != null && c.price! > 0)
                                            Container(
                                              margin: const EdgeInsets.all(8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.secondaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                "${c.price!.toStringAsFixed(2)} جنيه",
                                                style: TextStyle(
                                                  fontFamily: AppFonts.mainFont,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          else
                                            Container(
                                              margin: const EdgeInsets.all(8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.successColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    c.title,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          AppFonts.mainFont,
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      (c.averageRating ?? 0)
                                                          .toStringAsFixed(1),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppFonts.mainFont,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                    Text(
                                                      " (${c.totalEnrollments ?? 0})",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppFonts.mainFont,
                                                        fontSize: 12,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: [
                                                _buildInfoChip(
                                                  Icons.person_rounded,
                                                  c.teacherName,
                                                  AppColors.primaryColor,
                                                ),
                                                _buildInfoChip(
                                                  Icons.school_rounded,
                                                  c.difficulty,
                                                  AppColors.secondaryColor,
                                                ),
                                              ],
                                            ),
                                            if (isExpanded)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    "وصف الدورة:",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.mainFont,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    c.description,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.mainFont,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      _buildInfoChip(
                                                        Icons
                                                            .access_time_rounded,
                                                        "${c.durationHours ?? 0} ساعة",
                                                        Colors.orange,
                                                      ),
                                                      _buildInfoChip(
                                                        Icons.article_outlined,
                                                        "${c.totalSections ?? 0} قسم",
                                                        Colors.purple,
                                                      ),
                                                      _buildInfoChip(
                                                        Icons.quiz,
                                                        "${c.totalQuizzes ?? 0} اختبار",
                                                        Colors.teal,
                                                      ),
                                                      _buildInfoChip(
                                                        Icons
                                                            .people_alt_rounded,
                                                        "${c.totalEnrollments ?? 0} مشترك",
                                                        Colors.indigo,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                  ElevatedButton.icon(
                                                    onPressed:
                                                        (isEnrolling ||
                                                                isEnrolled)
                                                            ? null
                                                            : () =>
                                                                _enrollCourse(
                                                                  c,
                                                                ),
                                                    icon:
                                                        isEnrolling
                                                            ? const SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            )
                                                            : isEnrolled
                                                            ? const Icon(
                                                              Icons
                                                                  .check_circle_outline,
                                                              size: 20,
                                                            )
                                                            : const Icon(
                                                              Icons
                                                                  .add_circle_outline,
                                                              size: 20,
                                                            ),
                                                    label: Text(
                                                      isEnrolled
                                                          ? "مشترك بالفعل"
                                                          : "اشترك الآن",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppFonts.mainFont,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          isEnrolled
                                                              ? AppColors
                                                                  .successColor
                                                              : AppColors
                                                                  .primaryColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      minimumSize: const Size(
                                                        double.infinity,
                                                        50,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (!isExpanded)
                                              Align(
                                                alignment: Alignment.center,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 30,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _expandedIds.add(c.id);
                                                    });
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }, childCount: courses.length),
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
