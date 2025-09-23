import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/models/student_models/enrollment_model.dart';
import 'package:study_platform/models/student_models/course_model.dart';
import 'package:study_platform/models/student_models/my_courses_service.dart';
import 'package:study_platform/services/authentication/handle_authentication_error.dart';
import 'package:study_platform/services/student/get_enrollment_service.dart';
import 'package:study_platform/views/student_views/course_details_view.dart';
import 'package:study_platform/widgets/app_bar.dart';
import 'package:study_platform/widgets/custom_drawer.dart';

class StudentEnrollmentsView extends StatefulWidget {
  const StudentEnrollmentsView({super.key});

  @override
  State<StudentEnrollmentsView> createState() => _StudentEnrollmentsViewState();
}

class _StudentEnrollmentsViewState extends State<StudentEnrollmentsView> {
  final GetEnrollmentService _enrollmentService = GetEnrollmentService();
  final MyCoursesService _myCoursesService = MyCoursesService();

  List<EnrollmentModel> enrollments = [];
  List<CourseModel> myCourses = [];

  bool isLoadingEnrollments = true;
  bool isLoadingCourses = true;

  String? errorEnrollments;
  String? errorCourses;

  bool _showAllEnrollments = false;
  // ignore: unused_field
  bool _showAllCourses = false;

  @override
  void initState() {
    super.initState();
    _fetchEnrollments();
    _fetchMyCourses();
  }

  Future<void> _fetchEnrollments() async {
    try {
      final data = await _enrollmentService.getStudentEnrollments();
      if (!mounted) {
        return;
      }
      setState(() {
        enrollments = data;
        isLoadingEnrollments = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        errorEnrollments = e.toString();
        isLoadingEnrollments = false;
      });
    }
  }

Future<void> _fetchMyCourses() async {
    try {
      final data = await _myCoursesService.getMyCourses();
      if (!mounted) {
        return;
      }
      setState(() {
        myCourses = data;
        isLoadingCourses = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      // 💡 تعديل هنا: استدعي الدالة وارجع بعدها على طول
      handleAuthenticationError(context, e.toString());

      // 💡 لو الدالة المساعدة لم ترجع، كمل تنفيذ الكود
      if (!context.mounted) {
        return;
      }

      setState(() {
        errorCourses = e.toString();
        isLoadingCourses = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final visibleEnrollments =
        _showAllEnrollments ? enrollments : enrollments.take(3).toList();

    // final visibleCourses =
    //      _showAllCourses ? myCourses : myCourses.take(3).toList();

    final visibleCourses = myCourses;

    return Scaffold(
      appBar: const GradientAppBar(title: "اشتراكاتى", hasDrawer: true),
      endDrawer: CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchEnrollments();
          await _fetchMyCourses();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================== Enrollments ==================
              // const Text(
              //   "🎓 My Enrollments",
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8),

              // if (isLoadingEnrollments)
              //   const Center(child: CircularProgressIndicator())
              // else if (errorEnrollments != null)
              //   Text("❌ Error: $errorEnrollments")
              // else ...[
              //   ...visibleEnrollments.map(
              //     (enrollment) => Card(
              //       margin: const EdgeInsets.symmetric(vertical: 6),
              //       child: ListTile(
              //         title: Text(enrollment.course.title),
              //         subtitle: Text(
              //           "👨‍🏫 ${enrollment.course.teacherName}\n"
              //           "Progress: ${enrollment.progressPercentage}%",
              //         ),
              //         trailing: Icon(
              //           enrollment.isActive ? Icons.play_circle : Icons.lock,
              //           color: enrollment.isActive ? Colors.green : Colors.grey,
              //         ),
              //       ),
              //     ),
              //   ),
              //   if (enrollments.length > 3)
              //     Center(
              //       child: IconButton(
              //         icon: Icon(
              //           _showAllEnrollments
              //               ? Icons.keyboard_arrow_up
              //               : Icons.keyboard_arrow_down,
              //           size: 32,
              //           color: Colors.blue,
              //         ),
              //         onPressed: () {
              //           setState(() {
              //             _showAllEnrollments = !_showAllEnrollments;
              //           });
              //         },
              //       ),
              //     ),
              // ],

              // const SizedBox(height: 24),

              // ================== My Courses ==================
              // const Text(
              //   "📚 My Courses",
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8),
              if (isLoadingCourses)
                const Center(child: CircularProgressIndicator())
              else if (errorCourses != null)
                Text("❌ Error: $errorCourses")
              else if (myCourses.isEmpty)
                Center(
                  child: const Text(
                    "لم تقم بالاشتراك في أي دورة حتى الآن.",
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      fontSize: 16,
                    ),
                  ),
                )
              else ...[
                ...visibleCourses.map(
                  (course) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CourseDetailsView(courseId: course.id),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.gradientColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ====== الصورة ======
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                              ),
                              child:
                                  course.thumbnail != null &&
                                          course.thumbnail!.isNotEmpty
                                      ? Image.network(
                                        getFullThumbnail(course.thumbnail),
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            width: double.infinity,
                                            height: 150,
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            child: const Icon(
                                              Icons.broken_image,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      )
                                      : Container(
                                        width: double.infinity,
                                        height: 150,
                                        color: Colors.white.withOpacity(0.2),
                                        child: const Icon(
                                          Icons.book,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ====== العنوان والمدرس ======
                                  Text(
                                    course.title,
                                    style: const TextStyle(
                                      fontFamily: AppFonts.mainFont,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "👨‍🏫 ${course.teacherName} • ${course.difficulty}",
                                    style: const TextStyle(
                                      fontFamily: AppFonts.mainFont,
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // ====== Chips ======
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoChip(
                                        Icons.timer,
                                        "${course.durationHours ?? 0} ساعة",
                                      ),
                                      _buildInfoChip(
                                        Icons.list,
                                        "${course.totalSections ?? 0} قسم",
                                      ),
                                      _buildInfoChip(
                                        Icons.quiz,
                                        "${course.totalQuizzes ?? 0} اختبار",
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // ====== السعر والـ Rating ======
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        course.price != null
                                            ? "\$${course.price!.toStringAsFixed(2)}"
                                            : "Free",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.greenAccent,
                                          fontFamily: AppFonts.mainFont,
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
                                            (course.averageRating ?? 0)
                                                .toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppFonts.mainFont,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            " (${course.totalEnrollments ?? 0})",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                              fontFamily: AppFonts.mainFont,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // if (myCourses.length > 3)
                //   Center(
                //     child: IconButton(
                //       icon: Icon(
                //         _showAllCourses
                //             ? Icons.keyboard_arrow_up
                //             : Icons.keyboard_arrow_down,
                //         size: 32,
                //         color: Colors.blue,
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           _showAllCourses = !_showAllCourses;
                //         });
                //       },
                //     ),
                //   ),
                const SizedBox(height: 100),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      avatar: Icon(icon, size: 18, color: AppColors.primaryColor),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.primaryColor,
          fontFamily: AppFonts.mainFont,
        ),
      ),
      backgroundColor: Colors.white24,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  String getFullThumbnail(String? path) {
    if (path == null || path.isEmpty) return "";
    return "https://res.cloudinary.com/dtoy7z1ou/$path";
  }
}
