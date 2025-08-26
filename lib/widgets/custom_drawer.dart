import 'package:flutter/material.dart';
import 'package:study_platform/views/Drawer_views/account_view.dart';
import 'package:study_platform/views/Drawer_views/settings_view.dart';
import 'package:study_platform/views/register_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // يخلي العناصر تبدأ من فوق
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'القائمة',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الحساب'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const RegisterView()),
                (route) => false, // false = ميخليش أي صفحة قديمة
              );
            },
          ),
        ],
      ),
    );
  }
}
