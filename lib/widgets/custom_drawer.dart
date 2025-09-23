import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/services/authentication/refresh_token_service.dart';
import 'package:study_platform/services/settings/logout_service.dart';
import 'package:study_platform/views/parent_views/link_child_view.dart';
import 'package:study_platform/views/register_view.dart';
// 💡 استيراد ProfileView و ProfileRepository
import 'package:study_platform/views/Drawer_views/profile_view.dart';
import 'package:study_platform/services/account/profile_repository.dart';
// 💡 استيراد ChangePasswordView و DeleteAccountService
import 'package:study_platform/views/Drawer_views/change_password_view.dart';
import 'package:study_platform/services/settings/delete_account_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isLoadingProfile = false;
  bool _isDeletingAccount = false;

  Future<void> _fetchAndNavigateToProfile(BuildContext context) async {
    setState(() {
      _isLoadingProfile = true;
    });

    try {
      final profile = await ProfileRepository().getUserProfile();

      if (!context.mounted) return;
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
        setState(() {
          _isLoadingProfile = false;
        });
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "تأكيد الحذف",
                style: TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              content: const Text(
                "هل أنت متأكد أنك تريد حذف الحساب؟ لا يمكن التراجع بعد ذلك.",
                style: TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(
                    "إلغاء",
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text(
                    "حذف",
                    style: TextStyle(fontFamily: AppFonts.mainFont),
                  ),
                ),
              ],
            ),
          ),
    );

    if (confirm != true) return;

    if (!mounted) return;
    setState(() => _isDeletingAccount = true);

    try {
      await DeleteAccountService().deleteAccount();
      await StorageService().logout();

      if (!mounted) return;
      setState(() => _isDeletingAccount = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ تم حذف الحساب بنجاح")));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegisterView()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDeletingAccount = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
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
                    ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        color: AppColors.primaryColor,
                      ),
                      title: const Text(
                        'الحساب',
                        style: TextStyle(fontFamily: AppFonts.mainFont),
                      ),
                      onTap: () async {
                        await _fetchAndNavigateToProfile(context);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primaryColor,
                      ),
                      title: const Text(
                        'تغيير كلمة السر',
                        style: TextStyle(fontFamily: AppFonts.mainFont),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordView(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade700,
                      ),
                      title: Text(
                        'حذف الحساب',
                        style: TextStyle(
                          fontFamily: AppFonts.mainFont,
                          color: Colors.red.shade700,
                        ),
                      ),
                      onTap: _isDeletingAccount ? null : _deleteAccount,
                      // 💡 تم حذف مؤشر التحميل الصغير من هنا
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
          // 💡 مؤشر التحميل الرئيسي عند أي عملية تحميل
          if (_isLoadingProfile || _isDeletingAccount)
            const ModalBarrier(dismissible: false, color: Colors.black54),
          if (_isLoadingProfile || _isDeletingAccount)
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
        builder: (dialogContext) {
          bool _isLoading = false;
          return StatefulBuilder(
            builder: (context, setState) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "تأكيد",
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    TextButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                Navigator.pop(dialogContext);
                              },
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          fontFamily: AppFonts.mainFont,
                          color: AppColors.primaryColor.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // 💡 هنا يتم التحكم في حالة الزر
                      onPressed:
                          _isLoading
                              ? null
                              : () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  await LogoutService().logout();
                                  await StorageService().logout();
                                  RefreshTokenService().stopAutoRefresh();

                                  if (context.mounted) {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterView(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  if (!context.mounted) return;
                                  Navigator.pop(
                                    dialogContext,
                                  ); // أغلق الديالوج حتى يرى المستخدم رسالة الخطأ
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("❌ فشل تسجيل الخروج: $e"),
                                    ),
                                  );
                                }
                              },
                      // 💡 هنا يتم تبديل محتوى الزر بين النص ومؤشر التحميل
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                "نعم",
                                style: TextStyle(fontFamily: AppFonts.mainFont),
                              ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}
