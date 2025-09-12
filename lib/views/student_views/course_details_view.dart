import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/course_response.dart';
// import 'package:study_platform/models/student_models/course_model.dart';
import 'package:study_platform/models/student_models/section_model.dart';
import 'package:study_platform/services/student/course_details_service.dart';

class CourseDetailsView extends StatefulWidget {
  final int courseId;

  const CourseDetailsView({super.key, required this.courseId});

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<CourseDetailsView> {
  final CourseDetailsService _courseDetailsService = CourseDetailsService();

  CourseResponse? course;
  bool isLoading = true;
  String? error;

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
      setState(() {
        course = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

Widget _buildSection(SectionModel section) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        leading: Icon(
          section.contentType == "video"
              ? Icons.play_circle
              : section.contentType == "pdf"
              ? Icons.picture_as_pdf
              : Icons.article,
          color: Colors.blue,
        ),
        title: Text(section.title),
        subtitle: Text(
          section.description.isNotEmpty
              ? section.description
              : 'No description',
        ),
        children: [
          if (section.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Content: ${section.content}"),
            ),
          if (section.videoFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Video: ${section.videoFile}"),
            ),
          if (section.pdfFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("PDF: ${section.pdfFile}"),
            ),
          if (section.hasQuiz && section.quiz != null)
            ExpansionTile(
              title: Text("Quiz: ${section.quiz!.title}"),
              children:
                  section.quiz!.questions.map((q) {
                    return ExpansionTile(
                      title: Text("Q: ${q.questionText}"),
                      children:
                          q.choices
                              .map(
                                (c) => ListTile(
                                  title: Text(
                                    "${c.choiceText} ${c.isCorrect ? '(Correct)' : ''}",
                                  ),
                                ),
                              )
                              .toList(),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Course Details")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text("❌ Error: $error"))
              : course == null
              ? const Center(child: Text("⚠️ No course found"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course!.course.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "👨‍🏫 ${course!.course.teacherName} • ${course!.course.difficulty} • Price: ${course!.course.price}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(course!.course.description),
                    const SizedBox(height: 20),
                    const Text(
                      "📂 Sections",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                     ...course!.course.sections.map((section) => _buildSection(section)),

                  ],
                ),
              ),
    );
  }
}
