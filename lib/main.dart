import 'package:flutter/material.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/views/parent_views/parent_dashboard_view.dart';
import 'package:study_platform/views/register_view.dart';
import 'package:study_platform/views/student_views/student_bottom_nav.dart';
import 'package:study_platform/views/teacher_views/teacher_dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  final loggedIn = await storage.isLoggedIn();
  final userType = await storage.getUserType();

  runApp(MyApp(loggedIn: loggedIn, userType: userType));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  final String? userType;
  const MyApp({super.key, required this.loggedIn, this.userType});

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (!loggedIn) {
      home = const RegisterView();
    } else {
      switch (userType) {
        case "student":
          home = const StudentBottomNav();
          break;
        case "teacher":
          home = const TeacherDashboardView();
          break;
        case "parent":
          home = const ParentDashboardView();
          break;
        default:
          home = const RegisterView(); // fallback لو في حاجة غلط
      }
    }

    return MaterialApp(title: 'Study Platform', home: home);
  }
}
