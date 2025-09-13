import 'package:flutter/material.dart';
import 'package:study_platform/services/teacher/teacher_courses_service.dart';

class AddCourseView extends StatefulWidget {
  const AddCourseView({super.key});

  @override
  State<AddCourseView> createState() => _AddCourseViewState();
}

class _AddCourseViewState extends State<AddCourseView> {
  final _formKey = GlobalKey<FormState>();
  final TeacherCoursesService _service = TeacherCoursesService();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();

  String _status = "draft";
  String _difficulty = "beginner";
  bool _loading = false;

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _service.createCourse(
        title: _titleController.text,
        description: _descriptionController.text,
        thumbnail: _thumbnailController.text,
        status: _status,
        difficulty: _difficulty,
        price: double.tryParse(_priceController.text) ?? 0.0,
        durationHours: int.tryParse(_durationController.text) ?? 0,
      );

      if (mounted) {
        Navigator.pop(context, true); // 👈 نرجع ونحدث الكورسات
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to create course: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("➕ Add New Course")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator:
                    (v) => v == null || v.isEmpty ? "Title is required" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator:
                    (v) =>
                        v == null || v.isEmpty
                            ? "Description is required"
                            : null,
              ),
              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(labelText: "Thumbnail URL"),
              ),
              DropdownButtonFormField(
                value: _status,
                items: const [
                  DropdownMenuItem(value: "draft", child: Text("Draft")),
                  DropdownMenuItem(
                    value: "published",
                    child: Text("Published"),
                  ),
                ],
                onChanged: (val) => setState(() => _status = val!),
                decoration: const InputDecoration(labelText: "Status"),
              ),
              DropdownButtonFormField(
                value: _difficulty,
                items: const [
                  DropdownMenuItem(value: "beginner", child: Text("Beginner")),
                  DropdownMenuItem(
                    value: "intermediate",
                    child: Text("Intermediate"),
                  ),
                  DropdownMenuItem(value: "advanced", child: Text("Advanced")),
                ],
                onChanged: (val) => setState(() => _difficulty = val!),
                decoration: const InputDecoration(labelText: "Difficulty"),
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
              ),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Duration (hours)",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _createCourse,
                child:
                    _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Create Course"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
