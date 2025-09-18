import 'package:flutter/material.dart';
import 'package:study_platform/services/parent/parent_child_quiz_results_service.dart';

class ParentChildQuizResultsView extends StatefulWidget {
  const ParentChildQuizResultsView({super.key});

  @override
  State<ParentChildQuizResultsView> createState() =>
      _ParentChildQuizResultsViewState();
}

class _ParentChildQuizResultsViewState
    extends State<ParentChildQuizResultsView> {
  final ParentChildQuizResultsService _quizService =
      ParentChildQuizResultsService();

  Map<String, dynamic>? _quizResults;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuizResults();
  }

  Future<void> _fetchQuizResults() async {
    try {
      final results = await _quizService.getFirstChildQuizResults();
      setState(() {
        _quizResults = results;
      });
    } catch (e) {
      setState(() {
        _error = "❌ Failed to load quiz results: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz Results")),
        body: Center(child: Text(_error!)),
      );
    }

    final childName = _quizResults!["child"]; // ده مجرد String
    final summary = _quizResults!["summary"];
    final courses = List<Map<String, dynamic>>.from(
      _quizResults!["courses"] ?? [],
    );

    return Scaffold(
      appBar: AppBar(title: Text("Quiz Results - $childName")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ معلومات الطفل
          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text("👦 $childName"),
            ),
          ),

          const SizedBox(height: 16),

          // ✅ الملخص
          _infoCard("📚 Total Courses", "${summary["total_courses"]}"),
          _infoCard(
            "📝 Total Quizzes Completed",
            "${summary["total_quizzes_completed"]}",
          ),
          _infoCard(
            "📊 Overall Total Score",
            "${summary["overall_total_score"]}",
          ),
          _infoCard("⭐ Overall Average", "${summary["overall_average"]}"),

          const SizedBox(height: 20),

          // ✅ تفاصيل الكورسات
          const Text(
            "📖 Courses:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          if (courses.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("🚫 No courses found for this child."),
            )
          else
            ...courses.map(
              (c) => Card(
                child: ListTile(
                  title: Text(c["course_name"] ?? "Unnamed Course"),
                  trailing: Text("Score: ${c["total_score"] ?? 0}"),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
