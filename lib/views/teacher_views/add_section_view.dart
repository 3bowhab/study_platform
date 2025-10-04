import 'package:flutter/material.dart';
import 'package:study_platform/services/teacher/teacher_sections_service.dart';
import 'package:study_platform/widgets/app_bar.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

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

    if (!mounted) return;
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

      if (!mounted) return;
      Navigator.pop(context, true); // ✅ رجع true علشان نعمل refresh
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ فشل إضافة القسم: $e")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _contentController.dispose();
    _orderController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontFamily: AppFonts.mainFont,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: AppColors.gradientColor,
              width: 2,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const GradientAppBar(title: "➕ إضافة قسم", centerTitle: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _titleController,
                  labelText: "عنوان القسم",
                  validator:
                      (v) => v == null || v.isEmpty ? "العنوان مطلوب" : null,
                ),
                _buildTextField(
                  controller: _descController,
                  labelText: "الوصف",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedContentType,
                    decoration: InputDecoration(
                      labelText: "نوع المحتوى",
                      labelStyle: const TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: AppFonts.mainFont,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColors.gradientColor,
                          width: 2,
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "text", child: Text("نص")),
                      DropdownMenuItem(value: "video", child: Text("فيديو")),
                      DropdownMenuItem(value: "pdf", child: Text("ملف PDF")),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedContentType = val!);
                    },
                  ),
                ),
                _buildTextField(
                  controller: _contentController,
                  labelText: "محتوى القسم (رابط أو نص)",
                ),
                _buildTextField(
                  controller: _orderController,
                  labelText: "الترتيب",
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  controller: _durationController,
                  labelText: "المدة (بالدقائق)",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      _isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                          : Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.gradientColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: _createSection,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "إنشاء قسم",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFonts.mainFont,
                                ),
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
