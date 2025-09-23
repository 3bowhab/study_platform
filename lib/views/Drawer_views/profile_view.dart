import 'package:flutter/material.dart';
import 'package:study_platform/models/users/parent_profile_model.dart';
import 'package:study_platform/models/users/student_profile_model.dart';
import 'package:study_platform/models/users/teacher_profile_model.dart';
import 'package:study_platform/models/users/user_profile_model.dart';
import 'package:study_platform/services/account/profile_repository.dart';
import 'package:study_platform/views/Drawer_views/edit_profile_view.dart';
import 'package:study_platform/widgets/app_bar.dart';
import 'package:study_platform/widgets/loading_indecator.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

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
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final refreshed = await ProfileRepository().getUserProfile();
      if (!mounted) return;
      setState(() => profile = refreshed);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ فشل تحديث البيانات: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: GradientAppBar(title: "بيانات الحساب", hasDrawer: false),
          body: RefreshIndicator(
            onRefresh: _refreshProfile,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: _buildProfileContent(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileView(profile: profile),
                      ),
                    );

                    if (updated == true) {
                      await _refreshProfile();
                    }
                  },
                  child: const Text(
                    "تعديل الحساب",
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
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
        _infoCard("اسم المستخدم", user.username, Icons.person_outline),
        _infoCard("البريد", user.email, Icons.email_outlined),
        _infoCard("الاسم", user.fullName, Icons.badge_outlined),
        _infoCard("رقم الهاتف", user.phoneNumber, Icons.phone_outlined),
        _infoCard(
          "تاريخ الميلاد",
          user.dateOfBirth,
          Icons.calendar_today_outlined,
        ),
        _infoCard("السيرة", user.bio, Icons.description_outlined),
        _infoCard("العنوان", user.address, Icons.location_on_outlined),
        _infoCard("المدينة", user.city, Icons.location_city_outlined),
        _infoCard("الدولة", user.country, Icons.public_outlined),
        _infoCard(
          "اسم ولي الأمر",
          user.parentName,
          Icons.family_restroom_outlined,
        ),
      ],
    );
  }

  // 🎓 الطالب
  Widget _buildStudent(StudentProfileModel student) {
    return Column(
      children: [
        _profileHeader(Icons.school, "الطالب"),
        _buildUserInfo(student.user),
        _infoCard("معلومات ولي الأمر", student.parentInfo, Icons.info_outline),
        _infoCard(
          "الأهداف التعليمية",
          student.learningGoals,
          Icons.book_outlined,
        ),
        _infoCard("الاهتمامات", student.interests, Icons.interests_outlined),
        _infoCard("المدرسة", student.schoolName, Icons.school_outlined),
        _infoCard("المرحلة", student.gradeLevel, Icons.grade_outlined),
      ],
    );
  }

  // 👨‍🏫 المدرس
  Widget _buildTeacher(TeacherProfileModel teacher) {
    return Column(
      children: [
        _profileHeader(Icons.person, "المدرس"),
        _buildUserInfo(teacher.user),
        _infoCard("التخصص", teacher.specialization, Icons.subject_outlined),
        _infoCard(
          "الخبرة",
          "${teacher.experienceYears} سنوات",
          Icons.work_outline,
        ),
        _infoCard("المؤهل", teacher.education, Icons.school_outlined),
        _infoCard(
          "الشهادات",
          teacher.certifications,
          Icons.military_tech_outlined,
        ),
        _infoCard(
          "الأجر بالساعة",
          "${teacher.hourlyRate}",
          Icons.attach_money_outlined,
        ),
        _infoCard("لينكدإن", teacher.linkedinUrl, Icons.link_outlined),
        _infoCard(
          "الموقع الإلكتروني",
          teacher.websiteUrl,
          Icons.language_outlined,
        ),
        _infoCard(
          "الحالة",
          teacher.isApproved ? "معتمد" : "غير معتمد",
          Icons.verified_outlined,
        ),
        _infoCard(
          "تم الاعتماد في",
          teacher.approvedAt,
          Icons.event_available_outlined,
        ),
        _infoCard(
          "تم الاعتماد بواسطة",
          "${teacher.approvedBy}",
          Icons.person_add_outlined,
        ),
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
        _infoCard("المهنة", parent.occupation, Icons.business_center_outlined),
        _infoCard(
          "جهة الاتصال في حالة الطوارئ",
          parent.emergencyContact,
          Icons.local_hospital_outlined,
        ),
        _infoCard(
          "الإشعارات عبر البريد",
          parent.emailNotifications ? "مفعل" : "غير مفعّل",
          Icons.notifications_active_outlined,
        ),
        _infoCard(
          "الإشعارات عبر الرسائل",
          parent.smsNotifications ? "مفعل" : "غير مفعّل",
          Icons.sms_outlined,
        ),
        const SizedBox(height: 20),
        if (parent.children.isEmpty)
          const Center(child: Text("لا يوجد أبناء مسجلين")),
        for (var child in parent.children) ...[
          _buildStudent(child),
          const Divider(thickness: 1),
        ],
      ],
    );
  }

  // 🟦 العنوان الرئيسي
  Widget _profileHeader(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor, AppColors.gradientColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.white),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.mainFont,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 📋 كارت معلومة
  Widget _infoCard(String label, String? value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryColor),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.mainFont,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        subtitle: Text(
          value ?? "غير متوفر",
          style: const TextStyle(
            fontFamily: AppFonts.mainFont,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
