import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/enrollment_model.dart';
import 'package:study_platform/models/student_models/couse_model.dart';
import 'package:study_platform/models/student_models/my_courses_service.dart';
import 'package:study_platform/services/student/get_enrollment_service.dart';

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
      setState(() {
        enrollments = data;
        isLoadingEnrollments = false;
      });
    } catch (e) {
      setState(() {
        errorEnrollments = e.toString();
        isLoadingEnrollments = false;
      });
    }
  }

  Future<void> _fetchMyCourses() async {
    try {
      final data = await _myCoursesService.getMyCourses();
      setState(() {
        myCourses = data;
        isLoadingCourses = false;
      });
    } catch (e) {
      setState(() {
        errorCourses = e.toString();
        isLoadingCourses = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleEnrollments =
        _showAllEnrollments ? enrollments : enrollments.take(3).toList();

    final visibleCourses =
        _showAllCourses ? myCourses : myCourses.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("My Enrollments & Courses")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================== Enrollments ==================
            const Text(
              "🎓 My Enrollments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (isLoadingEnrollments)
              const Center(child: CircularProgressIndicator())
            else if (errorEnrollments != null)
              Text("❌ Error: $errorEnrollments")
            else ...[
              ...visibleEnrollments.map(
                (enrollment) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(enrollment.course.title),
                    subtitle: Text(
                      "👨‍🏫 ${enrollment.course.teacherName}\n"
                      "Progress: ${enrollment.progressPercentage}%",
                    ),
                    trailing: Icon(
                      enrollment.isActive ? Icons.play_circle : Icons.lock,
                      color: enrollment.isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ),
              if (enrollments.length > 3)
                Center(
                  child: IconButton(
                    icon: Icon(
                      _showAllEnrollments
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 32,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _showAllEnrollments = !_showAllEnrollments;
                      });
                    },
                  ),
                ),
            ],

            const SizedBox(height: 24),

            // ================== My Courses ==================
            const Text(
              "📚 My Courses",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (isLoadingCourses)
              const Center(child: CircularProgressIndicator())
            else if (errorCourses != null)
              Text("❌ Error: $errorCourses")
            else ...[
              ...visibleCourses.map(
                (course) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading:
                        course.thumbnail != null
                            ? Image.network(
                              course.thumbnail!,
                              width: 50,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.book, size: 40),
                    title: Text(course.title),
                    subtitle: Text(
                      "👨‍🏫 ${course.teacherName} • ${course.difficulty}",
                    ),
                  ),
                ),
              ),
              if (myCourses.length > 3)
                Center(
                  child: IconButton(
                    icon: Icon(
                      _showAllCourses
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 32,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _showAllCourses = !_showAllCourses;
                      });
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
