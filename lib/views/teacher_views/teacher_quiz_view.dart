import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/quiz_model.dart';
import 'package:study_platform/services/teacher/teacher_quiz_service.dart';
import 'package:study_platform/views/teacher_views/edit_quiz_view.dart';


class TeacherQuizView extends StatefulWidget {
  final int sectionId;
  const TeacherQuizView({super.key, required this.sectionId});

  @override
  State<TeacherQuizView> createState() => _TeacherQuizViewState();
}

class _TeacherQuizViewState extends State<TeacherQuizView> {
  final TeacherQuizService _service = TeacherQuizService();
  Future<QuizModel?>? _futureQuiz;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  void _loadQuiz() {
    setState(() {
      _futureQuiz = _service.getQuizBySection(widget.sectionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📖 Manage Quiz")),
      body: FutureBuilder<QuizModel?>(
        future: _futureQuiz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          }

          final quiz = snapshot.data;

          if (quiz == null) {
            // مفيش كويز مربوط بالسيكشن ده
            return Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  // final created = await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => AddQuizView(sectionId: widget.sectionId),
                  //   ),
                  // );
                  // if (created == true) _loadQuiz();
                },
                icon: const Icon(Icons.add),
                label: const Text("Create Quiz"),
              ),
            );
          }

          // لو في كويز → اعرضه
          return RefreshIndicator(
            onRefresh: () async => _loadQuiz(),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "📌 ${quiz.title}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == "edit") {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditQuizView(quiz: quiz, sectionId: widget.sectionId),
                            ),
                          );
                          if (updated == true) _loadQuiz();
                        } else if (value == "delete") {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text("⚠ Delete Quiz"),
                                  content: const Text(
                                    "Are you sure you want to delete this quiz?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(ctx, false),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            await _service.deleteQuiz(quiz.id);
                            _loadQuiz();
                          }
                        }
                      },
                      itemBuilder:
                          (context) => const [
                            PopupMenuItem(value: "edit", child: Text("✏ Edit")),
                            PopupMenuItem(
                              value: "delete",
                              child: Text("🗑 Delete"),
                            ),
                          ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text("📝 ${quiz.description}"),
                Text("⏱ Time Limit: ${quiz.timeLimitMinutes} mins"),
                Text("🏆 Passing Score: ${quiz.passingScore}"),
                Text("🔄 Shuffle Questions: ${quiz.shuffleQuestions}"),
                const Divider(),
                const Text(
                  "📖 Questions:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...quiz.questions.map(
                  (q) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(q.questionText),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            q.choices.map((c) {
                              return Text(
                                "${c.isCorrect ? "✅" : "❌"} ${c.choiceText}",
                              );
                            }).toList(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          // final updated = await Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => EditQuestionView(question: q),
                          //   ),
                          // );
                          // if (updated == true) _loadQuiz();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
