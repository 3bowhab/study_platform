import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/course_model.dart';
import 'package:study_platform/services/student/post_enrollment_service.dart';
import 'package:study_platform/services/student/student_courses_service.dart';

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
  final Set<int> _selectedIds = {};

  bool _bulkLoading = false;

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

  Future<void> _enrollCourse(CourseModel course) async {
    setState(() => _enrollingIds.add(course.id));
    try {
      await _enrollmentService.enrollTemporarySingle(course.id);
      setState(() => _enrolledIds.add(course.id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Enrolled in ${course.title}")),
        );
      }
    } catch (e) {
      if (mounted) {
        if (e.toString().contains("already_enrolled")) {
          setState(() => _enrolledIds.add(course.id));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("ℹ️ Already enrolled in ${course.title}")),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
        }
      }
    } finally {
      if (mounted) setState(() => _enrollingIds.remove(course.id));
    }
  }

  Future<void> _enrollSelected() async {
    if (_bulkLoading || _selectedIds.isEmpty) return;
    setState(() => _bulkLoading = true);

    try {
      final result = await _enrollmentService.enrollTemporaryBulk(
        _selectedIds.toList(),
      );

      final enrolled = (result["enrolled_courses"] ?? []) as List<dynamic>;
      final already = (result["already_enrolled"] ?? []) as List<dynamic>;

      setState(() {
        _enrolledIds.addAll(_selectedIds);
        _selectedIds.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅ Enrolled: ${enrolled.map((e) => e['course_title']).join(', ')}\n"
              "ℹ️ Already: ${already.map((e) => e['course_title']).join(', ')}",
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Bulk Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _bulkLoading = false);
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
        body: Center(child: Text("❌ $errorMessage")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, i) {
          final c = courses[i];
          final isEnrolling = _enrollingIds.contains(c.id);
          final isEnrolled = _enrolledIds.contains(c.id);
          final isSelected = _selectedIds.contains(c.id);

          return Card(
            color: isSelected ? Colors.blue.shade50 : null,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Checkbox(
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedIds.add(c.id);
                    } else {
                      _selectedIds.remove(c.id);
                    }
                  });
                },
              ),
              title: Text(c.title),
              subtitle: Text(
                "👨‍🏫 ${c.teacherName}  •  ${c.difficulty}\n${c.description}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed:
                      (isEnrolling || isEnrolled)
                          ? null
                          : () => _enrollCourse(c),
                  child:
                      isEnrolling
                          ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(isEnrolled ? "Enrolled" : "Enroll"),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton:
          _selectedIds.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: _bulkLoading ? null : _enrollSelected,
                icon:
                    _bulkLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.done_all),
                label: Text(
                  _bulkLoading
                      ? "Enrolling..."
                      : "Enroll ${_selectedIds.length} selected",
                ),
              )
              : null,
    );
  }
}
