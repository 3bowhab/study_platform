import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/quiz_model.dart';
import 'package:study_platform/services/student/quiz_service.dart';

class QuizAttemptView extends StatefulWidget {
  final int courseId;
  final int sectionId;
  final QuizModel quiz;

  const QuizAttemptView({
    super.key,
    required this.courseId,
    required this.sectionId,
    required this.quiz,
  });

  @override
  State<QuizAttemptView> createState() => _QuizAttemptViewState();
}

class _QuizAttemptViewState extends State<QuizAttemptView> {
  final QuizService _quizService = QuizService();
  final Map<int, int> _selectedAnswers = {}; // {questionId: choiceId}
  bool _isSubmitting = false;

  Future<void> _submitQuiz() async {
    if (_selectedAnswers.length < widget.quiz.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please answer all questions")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await _quizService.submitQuiz(
        courseId: widget.courseId,
        sectionId: widget.sectionId,
        quizId: widget.quiz.id,
        attemptId: widget.quiz.attemptId!,
        answers:
            _selectedAnswers.entries
                .map((e) => {"question_id": e.key, "choice_id": e.value})
                .toList(),
      );

      if (!mounted) return;

      // 📊 عرض النتائج في Dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("📊 Quiz Results"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // دائرة النتيجة
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        value: (result['score'] as num) / 100,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade300,
                        color: result['is_passed'] ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${(result['score'] as num).toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("✅ Correct: ${result['correct_answers']}"),
                      Text("❓ Total: ${result['total_questions']}"),
                      Text("⏱ Time: ${result['time_taken_minutes']} min"),
                      Text(
                        "🎯 Status: ${result['is_passed'] ? "Passed 🎉" : "Failed ❌"}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              result['is_passed'] ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to submit quiz: $e")));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz: ${widget.quiz.title}")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.quiz.questions.length,
        itemBuilder: (context, index) {
          final question = widget.quiz.questions[index];
          final qId = question.id;

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Q${index + 1}: ${question.questionText}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  ...question.choices.map((choice) {
                    return RadioListTile<int>(
                      title: Text(choice.choiceText),
                      value: choice.id,
                      groupValue: _selectedAnswers[qId],
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswers[qId] = value!;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: _isSubmitting ? null : _submitQuiz,
          child:
              _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit Quiz"),
        ),
      ),
    );
  }
}
