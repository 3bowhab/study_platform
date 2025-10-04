import 'package:flutter/material.dart';
import 'package:study_platform/services/teacher/teacher_courses_service.dart';
import 'package:study_platform/widgets/app_bar.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

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

  // 💡 التعديل هنا: جعل القيمة الافتراضية "published"
  String _status = "published";
  String _difficulty = "beginner";
  bool _isLoading = false;

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;
    setState(() => _isLoading = true);

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

      if (!mounted) return;
      // Navigate back and return `true` to indicate success for a refresh.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ فشل إنشاء الدورة: $e")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _priceController.dispose();
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

  // 🔽 الدالة المخصصة لقائمة حالة الدورة
  Widget _buildStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _status,
        decoration: InputDecoration(
          labelText: "الحالة",
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
        items: const [
          DropdownMenuItem(
            value: "published",
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text("منشورة"),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "draft",
            child: Row(
              children: [
                Icon(Icons.edit_note, color: Colors.grey),
                SizedBox(width: 8),
                Text("مسودة"),
              ],
            ),
          ),
        ],
        onChanged: (val) => setState(() => _status = val!),
      ),
    );
  }

  // 🔽 الدالة المخصصة لقائمة صعوبة الدورة
  Widget _buildDifficultyDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _difficulty,
        decoration: InputDecoration(
          labelText: "الصعوبة",
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
        items: const [
          DropdownMenuItem(
            value: "beginner",
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.blue),
                SizedBox(width: 8),
                Text("مبتدئ"),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "intermediate",
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.orange),
                Icon(Icons.star, color: Colors.orange),
                SizedBox(width: 8),
                Text("متوسط"),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "advanced",
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.red),
                Icon(Icons.star, color: Colors.red),
                Icon(Icons.star, color: Colors.red),
                SizedBox(width: 8),
                Text("متقدم"),
              ],
            ),
          ),
        ],
        onChanged: (val) => setState(() => _difficulty = val!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: "إضافة دورة جديدة"),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _titleController,
                  labelText: "عنوان الدورة",
                  validator:
                      (v) => v == null || v.isEmpty ? "العنوان مطلوب" : null,
                ),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: "الوصف",
                  validator:
                      (v) => v == null || v.isEmpty ? "الوصف مطلوب" : null,
                ),
                _buildTextField(
                  controller: _thumbnailController,
                  labelText: "رابط الصورة المصغرة",
                ),
                _buildStatusDropdown(),
                _buildDifficultyDropdown(),
                _buildTextField(
                  controller: _priceController,
                  labelText: "السعر",
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  controller: _durationController,
                  labelText: "المدة (بالساعات)",
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
                              onPressed: _createCourse,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "إنشاء دورة",
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
