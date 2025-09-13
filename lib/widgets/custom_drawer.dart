import 'package:flutter/material.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/services/authentication/refresh_token_service.dart';
import 'package:study_platform/services/settings/logout_service.dart';
import 'package:study_platform/views/Drawer_views/settings_view.dart';
import 'package:study_platform/views/Drawer_views/account_view.dart';
import 'package:study_platform/views/register_view.dart';

class CustomDrawer extends StatefulWidget {
 CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // يخلي العناصر تبدأ من فوق
        children: [
          customDrawerHeader(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الحساب'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الإعدادات'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsView()),
              );
            },
          ),
          logoutTile(context),
        ],
      ),
    );
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
    decoration: const BoxDecoration(color: Colors.blue),
    child: FutureBuilder(
      future: Future.wait([
        StorageService().getFullName(),
        StorageService().getEmail(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.white);
        }
        final fullName = snapshot.data?[0] ?? "Guest";
        final email = snapshot.data?[1] ?? "No Email";

        return GestureDetector(
          onTap: () async {
            final token = await StorageService().getAccessToken();
            print("📌 Stored Token: $token");
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                fullName,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      },
    ),
  );
  }
}

ListTile logoutTile(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.logout),
    title: const Text('تسجيل الخروج'),
    onTap: () {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
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
                    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const RegisterView()),
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
