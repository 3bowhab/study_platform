import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/couse_model.dart';
import 'package:study_platform/services/student/student_courses_service.dart';

class StudentCoursesView extends StatefulWidget {
  const StudentCoursesView({super.key});

  @override
  State<StudentCoursesView> createState() => _StudentCoursesViewState();
}

class _StudentCoursesViewState extends State<StudentCoursesView> {
  final StudentCoursesService _coursesService = StudentCoursesService();
  List<CourseModel> courses = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final data = await _coursesService.getAllCourses();
      setState(() {
        courses = data;
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
        appBar: AppBar(title: const Text("Courses")),
        body: Center(child: Text("❌ Error: $errorMessage")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading:
                  course.thumbnail != null
                      ? Image.network(course.thumbnail!)
                      : const Icon(Icons.book),
              title: Text(course.title),
              subtitle: Text(
                "${course.description}\n${course.teacherName} | ${course.difficulty} | ${course.durationHours}h",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text("${course.price}"),
            ),
          );
        },
      ),
    );
  }
}
