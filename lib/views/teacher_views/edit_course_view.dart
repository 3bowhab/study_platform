import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/course_model.dart';
import 'package:study_platform/services/teacher/teacher_edit_course_servise.dart';

class EditCourseView extends StatefulWidget {
  final CourseModel course;

  const EditCourseView({super.key, required this.course});

  @override
  State<EditCourseView> createState() => _EditCourseViewState();
}

class _EditCourseViewState extends State<EditCourseView> {
  final _formKey = GlobalKey<FormState>();
  final TeacherEditCourseService _service = TeacherEditCourseService();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _thumbnailController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;

  String _status = "draft";
  String _difficulty = "beginner";

  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course.title);
    _descController = TextEditingController(text: widget.course.description);
    _thumbnailController = TextEditingController(text: widget.course.thumbnail);
    _priceController = TextEditingController(
      text: widget.course.price.toString(),
    );
    _durationController = TextEditingController(
      text: widget.course.durationHours.toString(),
    );

    _status = widget.course.status; // 👈 ناخد القيمة القديمة
    _difficulty = widget.course.difficulty; // 👈 ناخد القيمة القديمة
  }

  Future<void> _updateCourse() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      await _service.updateCourse(
        id: widget.course.id,
        title: _titleController.text,
        description: _descController.text,
        thumbnail: _thumbnailController.text,
        status: _status, // 👈 من الـ dropdown
        difficulty: _difficulty, // 👈 من الـ dropdown
        price: double.tryParse(_priceController.text) ?? 0.0,
        durationHours: int.tryParse(_durationController.text) ?? 0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Course updated successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to update course: $e")));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteCourse() async {
    setState(() => _isDeleting = true);

    try {
      await _service.deleteCourse(widget.course.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🗑️ Course deleted successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to delete course: $e")));
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("✏️ Edit Course: ${widget.course.title}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator:
                    (v) => v == null || v.isEmpty ? "Title required" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(labelText: "Thumbnail (URL)"),
              ),

              // 🔽 Dropdown for Status
              DropdownButtonFormField<String>(
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

              // 🔽 Dropdown for Difficulty
              DropdownButtonFormField<String>(
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
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: "Duration (hours)",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                    onPressed: _updateCourse,
                    icon: const Icon(Icons.save),
                    label: const Text("Save Changes"),
                  ),
              const SizedBox(height: 10),
              _isDeleting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: _deleteCourse,
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete Course"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
