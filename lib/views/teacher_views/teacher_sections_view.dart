import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/course_model.dart';
import 'package:study_platform/models/student_models/section_model.dart';
import 'package:study_platform/services/teacher/teacher_sections_service.dart';
import 'package:study_platform/views/teacher_views/add_section_view.dart';

class TeacherSectionsView extends StatefulWidget {
  final CourseModel course;

  const TeacherSectionsView({super.key, required this.course});

  @override
  State<TeacherSectionsView> createState() => _TeacherSectionsViewState();
}

class _TeacherSectionsViewState extends State<TeacherSectionsView> {
  final TeacherSectionsService _service = TeacherSectionsService();
  late Future<List<SectionModel>> _futureSections;

  @override
  void initState() {
    super.initState();
    _futureSections = _service.getCourseSections(widget.course.id);
  }

  Future<void> _refreshSections() async {
    setState(() {
      _futureSections = _service.getCourseSections(widget.course.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📖 Sections - ${widget.course.title}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddSectionView(courseId: widget.course.id),
                ),
              );
              if (added == true) {
                _refreshSections();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SectionModel>>(
        future: _futureSections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          }
          final sections = snapshot.data ?? [];
          if (sections.isEmpty) {
            return const Center(child: Text("No sections found."));
          }

          return RefreshIndicator(
            onRefresh: _refreshSections,
            child: ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.library_books,
                              size: 40,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                section.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (section.description.isNotEmpty)
                          Text("📝 ${section.description}"),
                        Text("📌 Type: ${section.contentType}"),
                        Text(
                          "▶ Content: ${section.content.isEmpty ? "N/A" : section.content}",
                        ),
                        Text("⏱ Duration: ${section.durationMinutes} mins"),
                        Text("👁 Views: ${section.totalViews}"),
                        Text("📅 Created: ${section.createdAt}"),
                        Text("📝 Updated: ${section.updatedAt}"),
                        if (section.hasQuiz) const Text("✅ Has Quiz"),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
