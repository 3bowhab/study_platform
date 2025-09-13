import 'package:flutter/material.dart';
import 'package:study_platform/views/student_views/student_courses_view.dart';
import 'package:study_platform/views/student_views/student_dashboard_view.dart';
import 'package:study_platform/views/student_views/student_enrollments_view.dart';

class StudentBottomNav extends StatefulWidget {
  const StudentBottomNav({super.key});

  @override
  State<StudentBottomNav> createState() => _StudentBottomNavState();
}

class _StudentBottomNavState extends State<StudentBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    StudentEnrollmentsView(), 
    StudentCoursesView(),
    StudentDashboardView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // 🎓 أيقونة للاشتراكات
            label: "Enrollments",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Courses"),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
        ],
      ),
    );
  }
}
