import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/quiz_model.dart';
import 'package:study_platform/services/teacher/teacher_quiz_service.dart';

class EditQuizView extends StatefulWidget {
  final QuizModel quiz;
  final int sectionId;

  const EditQuizView({super.key, required this.quiz, required this.sectionId});

  @override
  State<EditQuizView> createState() => _EditQuizViewState();
}

class _EditQuizViewState extends State<EditQuizView> {
  final _formKey = GlobalKey<FormState>();
  final TeacherQuizService _service = TeacherQuizService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _timeLimitController;
  late TextEditingController _passingScoreController;
  late TextEditingController _maxAttemptsController;

  bool _shuffleQuestions = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quiz.title);
    _descriptionController = TextEditingController(
      text: widget.quiz.description,
    );
    _timeLimitController = TextEditingController(
      text: widget.quiz.timeLimitMinutes.toString(),
    );
    _passingScoreController = TextEditingController(
      text: widget.quiz.passingScore.toString(),
    );
    _maxAttemptsController = TextEditingController(
      text: widget.quiz.maxAttempts.toString(),
    );
    _shuffleQuestions = widget.quiz.shuffleQuestions;
  }

  Future<void> _saveQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _service.updateQuiz(
        sectionId: widget.sectionId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        timeLimitMinutes: int.parse(_timeLimitController.text),
        passingScore: int.parse(_passingScoreController.text),
        maxAttempts: int.parse(_maxAttemptsController.text),
        shuffleQuestions: _shuffleQuestions,
        questions: widget.quiz.questions.map((q) => q.toJson()).toList(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Quiz updated successfully")),
        );
        Navigator.pop(context, true); // نرجع مع success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Failed: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("✏ Edit Quiz")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: "Title"),
                        validator: (val) => val!.isEmpty ? "Required" : null,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Description",
                        ),
                      ),
                      TextFormField(
                        controller: _timeLimitController,
                        decoration: const InputDecoration(
                          labelText: "Time Limit (mins)",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _passingScoreController,
                        decoration: const InputDecoration(
                          labelText: "Passing Score",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _maxAttemptsController,
                        decoration: const InputDecoration(
                          labelText: "Max Attempts",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SwitchListTile(
                        title: const Text("Shuffle Questions"),
                        value: _shuffleQuestions,
                        onChanged:
                            (val) => setState(() => _shuffleQuestions = val),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _saveQuiz,
                        icon: const Icon(Icons.save),
                        label: const Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
