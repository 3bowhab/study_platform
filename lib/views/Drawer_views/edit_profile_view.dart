import 'package:flutter/material.dart';
import 'package:study_platform/models/users/student_profile_model.dart';
import 'package:study_platform/models/users/teacher_profile_model.dart';
import 'package:study_platform/models/users/parent_profile_model.dart';
import 'package:study_platform/models/users/user_profile_model.dart';
import 'package:study_platform/services/account/edit_parent_profile_service.dart';
import 'package:study_platform/services/account/edit_student_profile_service.dart';
import 'package:study_platform/services/account/edit_teacher_profile_service.dart';
import 'package:study_platform/services/account/edit_user_profile_service.dart';

class EditProfileView extends StatefulWidget {
  final dynamic profile; // ممكن يكون Student / Teacher / Parent

  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers للحقول المشتركة (UserProfileModel)
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController dateOfBirthController;
  late TextEditingController bioController;
  late TextEditingController cityController;
  late TextEditingController addressController;
  late TextEditingController countryController;

  // Controllers إضافية للأنواع
  // طالب
  TextEditingController? schoolController; 
  TextEditingController? gradeController; 
  TextEditingController? learningGoalsController; 
  TextEditingController? interestsController;


  // مدرس
  TextEditingController? specializationController; 
  TextEditingController? experienceController;
  TextEditingController? educationController; 
  TextEditingController? certificationsController;
  TextEditingController? hourlyRateController; 
  TextEditingController? linkedinUrlController;
  TextEditingController? websiteUrlController;


  // ولي أمر
  TextEditingController? occupationController; 
  TextEditingController? emergencyContactController;
  TextEditingController? emailNotificationsController; 
  TextEditingController? smsNotificationsController;

  late UserProfileModel user; // البروفايل الأساسي

  @override
  void initState() {
    super.initState();

    final profile = widget.profile;
    user = profile.user; // هنا كل الأنواع فيها user = UserProfileModel

    // 👤 بيانات عامة من UserProfileModel
    emailController = TextEditingController(text: user.email);
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    phoneController = TextEditingController(text: user.phoneNumber);
    dateOfBirthController = TextEditingController(text: user.dateOfBirth);
    bioController = TextEditingController(text: user.bio);
    cityController = TextEditingController(text: user.city);
    addressController = TextEditingController(text: user.address);
    countryController = TextEditingController(text: user.country);

    // 🎓 طالب
    if (profile is StudentProfileModel) {
      schoolController = TextEditingController(text: profile.schoolName);
      gradeController = TextEditingController(text: profile.gradeLevel);
      learningGoalsController = TextEditingController(text: profile.learningGoals);
      interestsController = TextEditingController(text: profile.interests);
    }

    // 👨‍🏫 مدرس
    if (profile is TeacherProfileModel) {
      specializationController = TextEditingController(text: profile.specialization);
      experienceController = TextEditingController(text: profile.experienceYears.toString());
      educationController = TextEditingController(text: profile.education);
      certificationsController = TextEditingController(text: profile.certifications);
      hourlyRateController = TextEditingController(text: profile.hourlyRate.toString());
      linkedinUrlController = TextEditingController(text: profile.linkedinUrl);
      websiteUrlController = TextEditingController(text: profile.websiteUrl);
    }

    // 👨‍👩‍👦 ولي أمر
    if (profile is ParentProfileModel) {
      occupationController = TextEditingController(text: profile.occupation);
      emergencyContactController = TextEditingController(text: profile.emergencyContact);
      emailNotificationsController = TextEditingController(text: profile.emailNotifications.toString());
      smsNotificationsController = TextEditingController(text: profile.smsNotifications.toString());
    }
  }

  @override
  void dispose() {
    // user
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    bioController.dispose();
    cityController.dispose();
    addressController.dispose();
    countryController.dispose();

    // student
    schoolController?.dispose();
    gradeController?.dispose();
    learningGoalsController?.dispose();
    interestsController?.dispose();

    // teacher
    specializationController?.dispose();
    experienceController?.dispose();
    educationController?.dispose();
    certificationsController?.dispose();
    hourlyRateController?.dispose();
    linkedinUrlController?.dispose();
    websiteUrlController?.dispose();

    // parent
    occupationController?.dispose();
    emergencyContactController?.dispose();
    emailNotificationsController?.dispose();
    smsNotificationsController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Scaffold(
      appBar: AppBar(title: const Text("تعديل الحساب")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("البريد", emailController),
              _buildTextField("الاسم الأول", firstNameController),
              _buildTextField("الاسم الأخير", lastNameController),
              _buildTextField("رقم الهاتف", phoneController),
              _buildTextField("تاريخ الميلاد", dateOfBirthController),
              _buildTextField("السيرة", bioController),
              _buildTextField("العنوان", addressController),
              _buildTextField("المدينة", cityController),
              _buildTextField("الدولة", countryController),

              if (profile is StudentProfileModel) ...[
                _buildTextField("المدرسة", schoolController!),
                _buildTextField("المرحلة", gradeController!),
                _buildTextField("أهداف التعلم", learningGoalsController!),
                _buildTextField("الاهتمامات", interestsController!),
              ],

              if (profile is TeacherProfileModel) ...[
                _buildTextField("التخصص", specializationController!),
                _buildTextField(
                  "عدد سنوات الخبرة",
                  experienceController!,
                  isNumber: true,
                ),
                _buildTextField("المؤهل", educationController!),
                _buildTextField("الشهادات", certificationsController!),
                _buildTextField(
                  "المعدل بالساعة",
                  hourlyRateController!,
                  isNumber: true,
                ),
                _buildTextField("لينكدإن", linkedinUrlController!),
                _buildTextField("الموقع الإلكتروني", websiteUrlController!),
              ],

              if (profile is ParentProfileModel) ...[
                _buildTextField("المهنة", occupationController!),
                _buildTextField("جهة الاتصال في حالات الطوارئ", emergencyContactController!),
                _buildTextField("الإشعارات عبر البريد الإلكتروني", emailNotificationsController!),
                _buildTextField("الإشعارات عبر الرسائل القصيرة", smsNotificationsController!),
              ],

              const SizedBox(height: 20),
              editProfileButton(context),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton editProfileButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("⏳ جاري تحديث البيانات...")),
            );

            final profile = widget.profile;

            // ✨ تحديث UserProfileModel
            final updatedUser = UserProfileModel(
              id: user.id,
              username: user.username,
              email: emailController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              fullName: "${firstNameController.text} ${lastNameController.text}",
              userType: user.userType,
              phoneNumber: phoneController.text,
              // profilePicture: user.profilePicture,
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

            // ✨ تحديث البروفايل الخاص
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
                experienceYears:
                    int.tryParse(experienceController?.text ?? "0") ?? 0,
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
          }
        }
      },
      child: const Text("حفظ التعديلات"),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        // validator: (value) => (value == null || value.isEmpty) ? "مطلوب" : null,
      ),
    );
  }
}
