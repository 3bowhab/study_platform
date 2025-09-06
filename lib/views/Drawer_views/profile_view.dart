import 'package:flutter/material.dart';
import 'package:study_platform/models/authentication/user_model.dart';
import 'package:study_platform/models/users/parent_profile_model.dart';
import 'package:study_platform/models/users/student_profile_model.dart';
import 'package:study_platform/models/users/teacher_profile_model.dart';

class ProfileView extends StatelessWidget {
  final dynamic profile; // ممكن Student / Teacher / Parent

  const ProfileView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("بيانات الحساب")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Directionality(textDirection: TextDirection.rtl, child: _buildProfileContent()),
        ],
      ),
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
  Widget _buildUserInfo(UserModel user) {
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
      children: [
        _profileHeader(Icons.family_restroom, "ولي الأمر"),
        _buildUserInfo(parent.user),
        _infoCard("المهنة", parent.occupation),
        _infoCard("جهة الاتصال في حالة الطوارئ", parent.emergencyContact),
        _infoCard("الإشعارات عبر البريد", parent.emailNotifications ? "مفعل" : "غير مفعّل"),
        _infoCard("الإشعارات عبر الرسائل", parent.smsNotifications ? "مفعل" : "غير مفعّل"),
        _infoCard("عدد الأبناء", "${parent.children.length}"),
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
