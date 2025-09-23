import 'package:flutter/material.dart';
import 'package:study_platform/models/users/parent_profile_model.dart';
import 'package:study_platform/models/users/student_profile_model.dart';
import 'package:study_platform/models/users/teacher_profile_model.dart';
import 'package:study_platform/models/users/user_profile_model.dart';
import 'package:study_platform/services/account/edit_parent_profile_service.dart';
import 'package:study_platform/services/account/edit_student_profile_service.dart';
import 'package:study_platform/services/account/edit_teacher_profile_service.dart';
import 'package:study_platform/services/account/edit_user_profile_service.dart';
import 'package:study_platform/widgets/birthday_input.dart';
import 'package:study_platform/widgets/app_bar.dart';
import 'package:study_platform/widgets/loading_indecator.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

class EditProfileView extends StatefulWidget {
  final dynamic profile;

  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController dateOfBirthController;
  late TextEditingController bioController;
  late TextEditingController cityController;
  late TextEditingController addressController;
  late TextEditingController countryController;

  TextEditingController? schoolController;
  TextEditingController? gradeController;
  TextEditingController? learningGoalsController;
  TextEditingController? interestsController;

  TextEditingController? specializationController;
  TextEditingController? experienceController;
  TextEditingController? educationController;
  TextEditingController? certificationsController;
  TextEditingController? hourlyRateController;
  TextEditingController? linkedinUrlController;
  TextEditingController? websiteUrlController;

  TextEditingController? occupationController;
  TextEditingController? emergencyContactController;
  TextEditingController? emailNotificationsController;
  TextEditingController? smsNotificationsController;

  late UserProfileModel user;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    user = profile.user;

    emailController = TextEditingController(text: user.email);
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    phoneController = TextEditingController(text: user.phoneNumber);
    dateOfBirthController = TextEditingController(text: user.dateOfBirth);
    bioController = TextEditingController(text: user.bio);
    cityController = TextEditingController(text: user.city);
    addressController = TextEditingController(text: user.address);
    countryController = TextEditingController(text: user.country);

    if (profile is StudentProfileModel) {
      schoolController = TextEditingController(text: profile.schoolName);
      gradeController = TextEditingController(text: profile.gradeLevel);
      learningGoalsController = TextEditingController(
        text: profile.learningGoals,
      );
      interestsController = TextEditingController(text: profile.interests);
    }

    if (profile is TeacherProfileModel) {
      specializationController = TextEditingController(
        text: profile.specialization,
      );
      experienceController = TextEditingController(
        text: profile.experienceYears.toString(),
      );
      educationController = TextEditingController(text: profile.education);
      certificationsController = TextEditingController(
        text: profile.certifications,
      );
      hourlyRateController = TextEditingController(
        text: profile.hourlyRate.toString(),
      );
      linkedinUrlController = TextEditingController(text: profile.linkedinUrl);
      websiteUrlController = TextEditingController(text: profile.websiteUrl);
    }

    if (profile is ParentProfileModel) {
      occupationController = TextEditingController(text: profile.occupation);
      emergencyContactController = TextEditingController(
        text: profile.emergencyContact,
      );
      emailNotificationsController = TextEditingController(
        text: profile.emailNotifications.toString(),
      );
      smsNotificationsController = TextEditingController(
        text: profile.smsNotifications.toString(),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    bioController.dispose();
    cityController.dispose();
    addressController.dispose();
    countryController.dispose();
    schoolController?.dispose();
    gradeController?.dispose();
    learningGoalsController?.dispose();
    interestsController?.dispose();
    specializationController?.dispose();
    experienceController?.dispose();
    educationController?.dispose();
    certificationsController?.dispose();
    hourlyRateController?.dispose();
    linkedinUrlController?.dispose();
    websiteUrlController?.dispose();
    occupationController?.dispose();
    emergencyContactController?.dispose();
    emailNotificationsController?.dispose();
    smsNotificationsController?.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    // 💡 تم حذف التحقق من صحة الفورم هنا.

    if (!mounted) return;
    setState(() {
      _isSaving = true;
    });

    try {
      final profile = widget.profile;

      final updatedUser = UserProfileModel(
        id: user.id,
        username: user.username,
        email: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        fullName: "${firstNameController.text} ${lastNameController.text}",
        userType: user.userType,
        phoneNumber: phoneController.text,
        dateOfBirth: dateOfBirthController.text,
        bio: bioController.text,
        address: addressController.text,
        city: cityController.text,
        country: countryController.text,
        emailVerified: user.emailVerified,
        dateJoined: user.dateJoined,
        lastLogin: user.lastLogin,
        parentName: user.parentName,
      );
      await EditUserProfileService().updateUserProfile(updatedUser);

      if (profile is StudentProfileModel) {
        final updated = StudentProfileModel(
          id: profile.id,
          user: updatedUser,
          createdAt: profile.createdAt,
          updatedAt: DateTime.now().toString(),
          parentInfo: profile.parentInfo,
          gradeLevel: gradeController?.text ?? "",
          schoolName: schoolController?.text ?? "",
          learningGoals: learningGoalsController?.text ?? "",
          interests: interestsController?.text ?? "",
        );
        await EditStudentProfileService().updateStudentProfile(updated);
      } else if (profile is TeacherProfileModel) {
        final updated = TeacherProfileModel(
          id: profile.id,
          user: updatedUser,
          createdAt: profile.createdAt,
          updatedAt: DateTime.now().toString(),
          specialization: specializationController?.text ?? "",
          experienceYears: int.tryParse(experienceController?.text ?? "0") ?? 0,
          education: educationController?.text ?? "",
          certifications: certificationsController?.text ?? "",
          hourlyRate: double.tryParse(hourlyRateController?.text ?? "0") ?? 0,
          linkedinUrl: linkedinUrlController?.text ?? "",
          websiteUrl: websiteUrlController?.text ?? "",
          isApproved: profile.isApproved,
          approvedAt: profile.approvedAt,
          approvedBy: profile.approvedBy,
        );
        await EditTeacherProfileService().updateTeacherProfile(updated);
      } else if (profile is ParentProfileModel) {
        final updated = ParentProfileModel(
          id: profile.id,
          user: updatedUser,
          createdAt: profile.createdAt,
          updatedAt: DateTime.now().toString(),
          occupation: occupationController?.text ?? "",
          emergencyContact: emergencyContactController?.text ?? "",
          emailNotifications: profile.emailNotifications,
          smsNotifications: profile.smsNotifications,
          children: profile.children,
        );
        await EditParentProfileService().updateParentProfile(updated);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ تم تحديث البيانات بنجاح")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ فشل التحديث: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    return Stack(
      children: [
        Scaffold(
          appBar: GradientAppBar(title: "تعديل الحساب", hasDrawer: false),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      "البريد",
                      emailController,
                      icon: Icons.email_outlined,
                    ),
                    _buildTextField(
                      "الاسم الأول",
                      firstNameController,
                      icon: Icons.person_outline,
                    ),
                    _buildTextField(
                      "الاسم الأخير",
                      lastNameController,
                      icon: Icons.person_outline,
                    ),
                    _buildTextField(
                      "رقم الهاتف",
                      phoneController,
                      icon: Icons.phone_outlined,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: BirthDateField(
                        initialDate:
                            dateOfBirthController.text.isNotEmpty
                                ? dateOfBirthController.text
                                : null,
                        onChanged: (selectedDate) {
                          setState(() {
                            dateOfBirthController.text = selectedDate;
                          });
                        },
                      ),
                    ),
                    _buildTextField(
                      "السيرة",
                      bioController,
                      icon: Icons.description_outlined,
                    ),
                    _buildTextField(
                      "العنوان",
                      addressController,
                      icon: Icons.location_on_outlined,
                    ),
                    _buildTextField(
                      "المدينة",
                      cityController,
                      icon: Icons.location_city_outlined,
                    ),
                    _buildTextField(
                      "الدولة",
                      countryController,
                      icon: Icons.public_outlined,
                    ),

                    if (profile is StudentProfileModel) ...[
                      _buildTextField(
                        "المدرسة",
                        schoolController!,
                        icon: Icons.school_outlined,
                      ),
                      _buildTextField(
                        "المرحلة",
                        gradeController!,
                        icon: Icons.grade_outlined,
                      ),
                      _buildTextField(
                        "أهداف التعلم",
                        learningGoalsController!,
                        icon: Icons.book_outlined,
                      ),
                      _buildTextField(
                        "الاهتمامات",
                        interestsController!,
                        icon: Icons.interests_outlined,
                      ),
                    ],

                    if (profile is TeacherProfileModel) ...[
                      _buildTextField(
                        "التخصص",
                        specializationController!,
                        icon: Icons.subject_outlined,
                      ),
                      _buildTextField(
                        "عدد سنوات الخبرة",
                        experienceController!,
                        icon: Icons.work_outline,
                        isNumber: true,
                      ),
                      _buildTextField(
                        "المؤهل",
                        educationController!,
                        icon: Icons.school_outlined,
                      ),
                      _buildTextField(
                        "الشهادات",
                        certificationsController!,
                        icon: Icons.military_tech_outlined,
                      ),
                      _buildTextField(
                        "المعدل بالساعة",
                        hourlyRateController!,
                        icon: Icons.attach_money_outlined,
                        isNumber: true,
                      ),
                      _buildTextField(
                        "لينكدإن",
                        linkedinUrlController!,
                        icon: Icons.link_outlined,
                      ),
                      _buildTextField(
                        "الموقع الإلكتروني",
                        websiteUrlController!,
                        icon: Icons.language_outlined,
                      ),
                    ],

                    if (profile is ParentProfileModel) ...[
                      _buildTextField(
                        "المهنة",
                        occupationController!,
                        icon: Icons.business_center_outlined,
                      ),
                      _buildTextField(
                        "جهة الاتصال في حالات الطوارئ",
                        emergencyContactController!,
                        icon: Icons.local_hospital_outlined,
                      ),
                      _buildTextField(
                        "الإشعارات عبر البريد الإلكتروني",
                        emailNotificationsController!,
                        icon: Icons.notifications_active_outlined,
                      ),
                      _buildTextField(
                        "الإشعارات عبر الرسائل القصيرة",
                        smsNotificationsController!,
                        icon: Icons.sms_outlined,
                      ),
                    ],

                    const SizedBox(height: 20),
                    editProfileButton(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isSaving) const LoadingIndicator(),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(fontFamily: AppFonts.mainFont),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: AppFonts.mainFont,
            color: AppColors.primaryColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryColor.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          prefixIcon:
              icon != null ? Icon(icon, color: AppColors.primaryColor) : null,
          filled: true,
          fillColor: AppColors.primaryColor.withOpacity(0.05),
        ),
        // validator: (value) => (value == null || value.isEmpty) ? "مطلوب" : null, // 💡 تم حذف الـ validator
      ),
    );
  }

  ElevatedButton editProfileButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isSaving ? null : _handleSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child:
          _isSaving
              ? const CircularProgressIndicator(color: AppColors.whiteColor)
              : const Text(
                "حفظ التعديلات",
                style: TextStyle(fontFamily: AppFonts.mainFont, fontSize: 18),
              ),
    );
  }
}
