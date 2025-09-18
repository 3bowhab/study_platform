import 'package:flutter/material.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/services/authentication/refresh_token_service.dart';
import 'package:study_platform/views/onboarding_view.dart';
import 'package:study_platform/views/parent_views/parent_dashboard_view.dart';
import 'package:study_platform/views/register_view.dart';
import 'package:study_platform/views/student_views/student_bottom_nav.dart';
import 'package:study_platform/views/teacher_views/teacher_home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  final loggedIn = await storage.isLoggedIn();
  final userType = await storage.getUserType();
  final seenOnboarding = await storage.getSeenOnboarding();

  // ✅ جدد التوكن أول ما الابلكيشن يفتح
  if (loggedIn) {
    await RefreshTokenService().refreshAccessToken();
  }

  runApp(
    MyApp(
      loggedIn: loggedIn,
      userType: userType,
      seenOnboarding: seenOnboarding,
    ),
  );

  // ⏳ شغل ريفرش التوكن كل 5 دقايق
  if (loggedIn) {
    RefreshTokenService().startAutoRefresh();
  }
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  final String? userType;
  final bool seenOnboarding;

  const MyApp({
    super.key,
    required this.loggedIn,
    this.userType,
    required this.seenOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (!seenOnboarding) {
      home = const ConcentricAnimationOnboarding();
    } else if (!loggedIn) {
      home = const RegisterView();
    } else {
      switch (userType) {
        case "student":
          home = const StudentBottomNav();
          break;
        case "teacher":
          home = const TeacherHomeView();
          break;
        case "parent":
          home = const ParentDashboardView();
          break;
        default:
          home = const RegisterView();
      }
    }

    return MaterialApp(title: 'Study Platform', home: home);
  }
}
