import 'package:flutter/material.dart';
import 'package:study_platform/models/users/parent_profile_model.dart';
import 'package:study_platform/models/users/student_profile_model.dart';
import 'package:study_platform/models/users/teacher_profile_model.dart';
import 'package:study_platform/models/users/user_profile_model.dart';
import 'package:study_platform/services/account/profile_repository.dart';
import 'package:study_platform/views/Drawer_views/edit_profile_view.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class ProfileView extends StatefulWidget {
  final dynamic profile; // Student / Teacher / Parent

  const ProfileView({super.key, required this.profile});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late dynamic profile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
  }

  Future<void> _refreshProfile() async {
    setState(() => isLoading = true);
    try {
      final refreshed = await ProfileRepository().getUserProfile();
      setState(() => profile = refreshed);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ فشل تحديث البيانات: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("بيانات الحساب")),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: _buildProfileContent(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileView(profile: profile),
                    ),
                  );

                  if (updated == true) {
                    // ✅ حصل تعديل → نعمل GET جديد
                    await _refreshProfile();
                  }
                },
                child: const Text("✏️ تعديل الحساب"),
              ),
            ],
          ),
        ),
        if (isLoading) const LoadingIndicator(),
      ],
    );
  }

  Widget _buildProfileContent() {
    if (profile is StudentProfileModel) {
      return _buildStudent(profile as StudentProfileModel);
    } else if (profile is TeacherProfileModel) {
      return _buildTeacher(profile as TeacherProfileModel);
    } else if (profile is ParentProfileModel) {
      return _buildParent(profile as ParentProfileModel);
    } else {
      return const Center(child: Text("نوع الحساب غير معروف"));
    }
  }

  // 👤 معلومات المستخدم العامة
  Widget _buildUserInfo(UserProfileModel user) {
    return Column(
      children: [
        _infoCard("اسم المستخدم", user.username),
        _infoCard("البريد", user.email),
        _infoCard("الاسم", user.fullName),
        _infoCard("رقم الهاتف", user.phoneNumber),
        _infoCard("تاريخ الميلاد", user.dateOfBirth),
        _infoCard("السيرة", user.bio),
        _infoCard("العنوان", user.address),
        _infoCard("المدينة", user.city),
        _infoCard("الدولة", user.country),
        _infoCard("اسم ولي الأمر", user.parentName),
      ],
    );
  }

  // 🎓 الطالب
  Widget _buildStudent(StudentProfileModel student) {
    return Column(
      children: [
        _profileHeader(Icons.school, "الطالب"),
        _buildUserInfo(student.user),
        _infoCard("معلومات ولي الأمر", student.parentInfo),
        _infoCard("الأهداف التعليمية", student.learningGoals),
        _infoCard("الاهتمامات", student.interests),
        _infoCard("المدرسة", student.schoolName),
        _infoCard("المرحلة", student.gradeLevel),
      ],
    );
  }

  // 👨‍🏫 المدرس
  Widget _buildTeacher(TeacherProfileModel teacher) {
    return Column(
      children: [
        _profileHeader(Icons.person, "المدرس"),
        _buildUserInfo(teacher.user),
        _infoCard("التخصص", teacher.specialization),
        _infoCard("الخبرة", "${teacher.experienceYears} سنوات"),
        _infoCard("المؤهل", teacher.education),
        _infoCard("الشهادات", teacher.certifications),
        _infoCard("الأجر بالساعة", "${teacher.hourlyRate}"),
        _infoCard("لينكدإن", teacher.linkedinUrl),
        _infoCard("الموقع الإلكتروني", teacher.websiteUrl),
        _infoCard("الحالة", teacher.isApproved ? "معتمد" : "غير معتمد"),
        _infoCard("تم الاعتماد في", teacher.approvedAt),
        _infoCard("تم الاعتماد بواسطة", "${teacher.approvedBy}"),
      ],
    );
  }

  // 👨‍👩‍👦 ولي الأمر
  Widget _buildParent(ParentProfileModel parent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _profileHeader(Icons.family_restroom, "ولي الأمر"),
        _buildUserInfo(parent.user),
        _infoCard("المهنة", parent.occupation),
        _infoCard("جهة الاتصال في حالة الطوارئ", parent.emergencyContact),
        _infoCard(
          "الإشعارات عبر البريد",
          parent.emailNotifications ? "مفعل" : "غير مفعّل",
        ),
        _infoCard(
          "الإشعارات عبر الرسائل",
          parent.smsNotifications ? "مفعل" : "غير مفعّل",
        ),
        const SizedBox(height: 20),
        if (parent.children.isEmpty)
          const Center(child: Text("لا يوجد أبناء مسجلين")),
        for (var child in parent.children) ...[
          _buildStudent(child), // 👈 كده ولي الأمر يشوف بيانات ابنه بالكامل
          const Divider(thickness: 1),
        ],
      ],
    );
  }


  // 🟦 العنوان الرئيسي
  Widget _profileHeader(IconData icon, String title) {
    return Column(
      children: [
        Icon(icon, size: 80, color: Colors.blueAccent),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Divider(height: 30, thickness: 1),
      ],
    );
  }

  // 📋 كارت معلومة
  Widget _infoCard(String label, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.info_outline, color: Colors.blueAccent),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value ?? "غير متوفر"),
      ),
    );
  }
}
