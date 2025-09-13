import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/course_model.dart';
import 'package:study_platform/services/teacher/teacher_courses_service.dart';
import 'package:study_platform/views/teacher_views/add_course_view.dart';
import 'package:study_platform/views/teacher_views/teacher_sections_view.dart';
import 'package:study_platform/widgets/custom_drawer.dart';


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
    _futureCourses = _service.getAllTeacherCourses();
  }

  Future<void> _refreshCourses() async {
    setState(() {
      _futureCourses = _service.getAllTeacherCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📚 My Courses"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final added = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCourseView()),
              );
              if (added == true) {
                _refreshCourses();
              }
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder<List<CourseModel>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          }
          final courses = snapshot.data ?? [];
          if (courses.isEmpty) {
            return const Center(child: Text("No courses found."));
          }

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TeacherSectionsView(course: course),
                      ),
                    );
                  },
                  leading:
                      course.thumbnail != null
                          ? Image.network(
                            course.thumbnail!,
                            width: 60,
                            fit: BoxFit.cover,
                          )
                          : const Icon(Icons.book, size: 40),
                  title: Text(
                    course.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.description),
                      Text("👨‍🏫 Teacher: ${course.teacherName}"),
                      Text("📌 Status: ${course.status}"),
                      Text("🎯 Difficulty: ${course.difficulty}"),
                      Text("🕒 Duration: ${course.durationHours} hrs"),
                      Text(
                        "📚 Sections: ${course.totalSections}, Quizzes: ${course.totalQuizzes}",
                      ),
                      Text("👥 Enrollments: ${course.totalEnrollments}"),
                      Text("⭐ Avg Rating: ${course.averageRating}"),
                      Text("📅 Created: ${course.createdAt}"),
                      Text("📝 Updated: ${course.updatedAt}"),
                    ],
                  ),
                  trailing: Text("\$${course.price.toStringAsFixed(2)}"),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
