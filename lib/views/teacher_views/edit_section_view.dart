import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/section_model.dart';
import 'package:study_platform/services/teacher/teacher_sections_service.dart';

class EditSectionView extends StatefulWidget {
  final SectionModel section;

  const EditSectionView({super.key, required this.section});

  @override
  State<EditSectionView> createState() => _EditSectionViewState();
}

class _EditSectionViewState extends State<EditSectionView> {
  final _formKey = GlobalKey<FormState>();
  final TeacherSectionsService _service = TeacherSectionsService();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _contentController;
  late TextEditingController _orderController;
  late TextEditingController _durationController;

  String _contentType = "text";
  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.section.title);
    _descController = TextEditingController(text: widget.section.description);
    _contentController = TextEditingController(text: widget.section.content);
    _orderController = TextEditingController(
      text: widget.section.order.toString(),
    );
    _durationController = TextEditingController(
      text: widget.section.durationMinutes.toString(),
    );
    _contentType = widget.section.contentType;
  }

  Future<void> _updateSection() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      await _service.updateSection(
        id: widget.section.id,
        title: _titleController.text,
        description: _descController.text,
        contentType: _contentType,
        content: _contentController.text,
        order: int.tryParse(_orderController.text) ?? 0,
        durationMinutes: int.tryParse(_durationController.text) ?? 0,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Section updated successfully")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to update section: $e")));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteSection() async {
    setState(() => _isDeleting = true);

    try {
      await _service.deleteSection(widget.section.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🗑️ Section deleted successfully")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to delete section: $e")));
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("✏️ Edit Section: ${widget.section.title}")),
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
              DropdownButtonFormField(
                value: _contentType,
                items: const [
                  DropdownMenuItem(value: "text", child: Text("Text")),
                  DropdownMenuItem(value: "video", child: Text("Video")),
                  DropdownMenuItem(value: "pdf", child: Text("PDF")),
                ],
                onChanged: (val) => setState(() => _contentType = val!),
                decoration: const InputDecoration(labelText: "Content Type"),
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: "Content"),
              ),
              TextFormField(
                controller: _orderController,
                decoration: const InputDecoration(labelText: "Order"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: "Duration (minutes)",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                    onPressed: _updateSection,
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
                    onPressed: _deleteSection,
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete Section"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
