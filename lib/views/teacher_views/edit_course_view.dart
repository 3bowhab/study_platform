import 'package:flutter/material.dart';
import 'package:study_platform/models/student_models/course_model.dart';
import 'package:study_platform/services/teacher/teacher_edit_course_servise.dart';
import 'package:study_platform/widgets/app_bar.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

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

  // 💡 التعديل هنا: جعل القيمة الافتراضية "published"
  String _status = "published";
  late String _difficulty;

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

    _status = widget.course.status;
    _difficulty = widget.course.difficulty;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _thumbnailController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _updateCourse() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      await _service.updateCourse(
        id: widget.course.id,
        title: _titleController.text,
        description: _descController.text,
        thumbnail: _thumbnailController.text,
        status: _status,
        difficulty: _difficulty,
        price: double.tryParse(_priceController.text) ?? 0.0,
        durationHours: int.tryParse(_durationController.text) ?? 0,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ تم تحديث الدورة بنجاح")));

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ فشل تحديث الدورة: $e")));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteCourse() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text("تأكيد الحذف"),
              content: const Text("هل أنت متأكد من حذف هذه الدورة؟"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("إلغاء"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("حذف", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
    );

    if (confirmed != true) return;

    if (!mounted) return;
    setState(() => _isDeleting = true);

    try {
      await _service.deleteCourse(widget.course.id);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("🗑️ تم حذف الدورة بنجاح")));

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ فشل حذف الدورة: $e")));
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
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
            value: "draft",
            child: Row(
              children: [
                Icon(Icons.edit_note, color: Colors.grey),
                SizedBox(width: 8),
                Text("مسودة"),
              ],
            ),
          ),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: GradientAppBar(title: "✏️ تعديل الدورة", centerTitle: false),
        body: SingleChildScrollView(
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
                  controller: _descController,
                  labelText: "الوصف",
                  validator:
                      (v) => v == null || v.isEmpty ? "الوصف مطلوب" : null,
                ),
                _buildTextField(
                  controller: _thumbnailController,
                  labelText: "رابط الصورة المصغرة",
                ),

                // 🔽 استخدام الدوال المخصصة
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
                      _isSaving
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
                              onPressed: _updateCourse,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "حفظ التغييرات",
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
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      _isDeleting
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.errorColor,
                            ),
                          )
                          : Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.errorColor,
                            ),
                            child: ElevatedButton(
                              onPressed: _deleteCourse,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "حذف الدورة",
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
