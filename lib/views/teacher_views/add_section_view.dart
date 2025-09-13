import 'package:flutter/material.dart';
import 'package:study_platform/services/teacher/teacher_sections_service.dart';

class AddSectionView extends StatefulWidget {
  final int courseId;

  const AddSectionView({super.key, required this.courseId});

  @override
  State<AddSectionView> createState() => _AddSectionViewState();
}

class _AddSectionViewState extends State<AddSectionView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _contentController = TextEditingController();
  final _orderController = TextEditingController();
  final _durationController = TextEditingController();

  String _selectedContentType = "text"; // default value

  final TeacherSectionsService _service = TeacherSectionsService();

  bool _isLoading = false;

  Future<void> _createSection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _service.createSection(
        courseId: widget.courseId,
        title: _titleController.text,
        description: _descController.text,
        contentType: _selectedContentType,
        content: _contentController.text,
        order: int.tryParse(_orderController.text) ?? 0,
        durationMinutes: int.tryParse(_durationController.text) ?? 0,
      );

      Navigator.pop(context, true); // ✅ رجع true علشان نعمل refresh
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("➕ Add Section")),
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
                    (v) => v == null || v.isEmpty ? "Title required" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              DropdownButtonFormField<String>(
                value: _selectedContentType,
                items: const [
                  DropdownMenuItem(value: "text", child: Text("Text")),
                  DropdownMenuItem(value: "video", child: Text("Video")),
                  DropdownMenuItem(value: "pdf", child: Text("PDF")),
                ],
                onChanged: (val) {
                  setState(() => _selectedContentType = val!);
                },
                decoration: const InputDecoration(labelText: "Content Type"),
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: "Content"),
              ),
              TextFormField(
                controller: _orderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Order"),
              ),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Duration (minutes)",
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                    onPressed: _createSection,
                    icon: const Icon(Icons.save),
                    label: const Text("Create Section"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
