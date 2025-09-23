// في ملف CustomDrawer.dart

import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/services/authentication/refresh_token_service.dart';
import 'package:study_platform/services/settings/logout_service.dart';
import 'package:study_platform/views/Drawer_views/settings_view.dart';
import 'package:study_platform/views/parent_views/link_child_view.dart';
import 'package:study_platform/views/register_view.dart';
// 💡 استيراد ProfileView و ProfileRepository
import 'package:study_platform/views/Drawer_views/profile_view.dart';
import 'package:study_platform/services/account/profile_repository.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // 💡 إضافة حالة التحميل
  bool _isLoadingProfile = false;

  // 💡 دالة جديدة لجلب بيانات البروفايل والانتقال للصفحة
  Future<void> _fetchAndNavigateToProfile(BuildContext context) async {
    // 💡 إظهار مؤشر التحميل
    setState(() {
      _isLoadingProfile = true;
    });

    try {
      final profile = await ProfileRepository().getUserProfile();

      if (!context.mounted) return;
      // 💡 إغلاق الدرور قبل الانتقال
      Navigator.of(context).pop();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileView(profile: profile)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ فشل تحميل بيانات الحساب: $e")));
    } finally {
      if (mounted) {
        // 💡 إخفاء مؤشر التحميل
        setState(() {
          _isLoadingProfile = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), // ✅ خلي الشمال مقفول
                bottomLeft: Radius.circular(25), // ✅ الشمال مقفول
              ),
            ),
            child: FutureBuilder<String?>(
              future: StorageService().getUserType(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userType = snapshot.data ?? "";

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    customDrawerHeader(),
                    // 💡 تم تعديل هذا ListTile
                    ListTile(
                      leading: const Icon(
                        Icons.settings,
                        color: AppColors.primaryColor,
                      ),
                      title: const Text(
                        'الحساب',
                        style: TextStyle(fontFamily: AppFonts.mainFont),
                      ),
                      onTap: () async {
                        // 💡 استدعاء الدالة الجديدة
                        await _fetchAndNavigateToProfile(context);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      ),
                      title: const Text(
                        'الإعدادات',
                        style: TextStyle(fontFamily: AppFonts.mainFont),
                      ),
                      onTap: () {
                        // 💡 إغلاق الدرور قبل الانتقال
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsView(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    if (userType.toLowerCase() == "parent")
                      ListTile(
                        leading: const Icon(
                          Icons.family_restroom,
                          color: AppColors.primaryColor,
                        ),
                        title: const Text(
                          'حساب الابن',
                          style: TextStyle(fontFamily: AppFonts.mainFont),
                        ),
                        onTap: () {
                          // 💡 إغلاق الدرور قبل الانتقال
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LinkChildView(),
                            ),
                          );
                        },
                      ),
                    if (userType.toLowerCase() == "parent")
                      const Divider(height: 1),

                    logoutTile(context),
                  ],
                );
              },
            ),
          ),
          // 💡 إضافة مؤشر التحميل فوق الدرور
          if (_isLoadingProfile)
            const ModalBarrier(dismissible: false, color: Colors.black54),
          if (_isLoadingProfile)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

ListTile logoutWithoutService(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.logout),
    title: const Text('تسجيل الخروج'),
    onTap: () async {
      // مسح البيانات
      await StorageService().logout();
      RefreshTokenService().stopAutoRefresh();

      // اقفل الـ Drawer
      Navigator.of(context).pop();

      // روح على شاشة اللوجين
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegisterView()),
        (route) => false,
      );
    },
  );
}

DrawerHeader customDrawerHeader() {
  return DrawerHeader(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primaryColor, AppColors.gradientColor],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
    child: FutureBuilder(
      future: Future.wait([
        StorageService().getFullName(),
        StorageService().getEmail(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        final fullName = snapshot.data?[0] ?? "Guest";
        final email = snapshot.data?[1] ?? "No Email";

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ صورة بروفايل افتراضية
            // const CircleAvatar(
            //   radius: 30,
            //   backgroundColor: Colors.white,
            //   child: Icon(Icons.person, size: 40, color: Colors.grey),
            // ),
            // const SizedBox(width: 15),
            // ✅ الاسم والإيميل
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

ListTile logoutTile(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.logout, color: AppColors.primaryColor),
    title: const Text(
      'تسجيل الخروج',
      style: TextStyle(fontFamily: AppFonts.mainFont),
    ),
    onTap: () {
      showDialog(
        context: context,
        builder:
            (dialogContext) => AlertDialog(
              title: const Text("تأكيد"),
              content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext); // يقفل الـ dialog
                  },
                  child: const Text("إلغاء"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext); // يقفل الـ dialog

                    try {
                      await LogoutService().logout();
                      await StorageService().logout();
                      RefreshTokenService().stopAutoRefresh();

                      // ✅ امسح أي شاشات سابقة ورجع للـ RegisterView
                      Future.microtask(() {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const RegisterView(),
                          ),
                          (route) => false,
                        );
                      });
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("❌ فشل تسجيل الخروج: $e")),
                      );
                    }
                  },
                  child: const Text("نعم"),
                ),
              ],
            ),
      );
    },
  );
}
