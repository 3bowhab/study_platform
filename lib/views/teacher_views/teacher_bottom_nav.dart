// import 'package:flutter/material.dart';
// import 'package:study_platform/helper/app_colors_fonts.dart'; // Make sure this import exists and is correct.
// import 'package:study_platform/views/teacher_views/teacher_courses_view.dart';

// class TeacherBottomNavBar extends StatefulWidget {
//   const TeacherBottomNavBar({super.key});

//   @override
//   State<TeacherBottomNavBar> createState() => _TeacherBottomNavBarState();
// }

// class _TeacherBottomNavBarState extends State<TeacherBottomNavBar> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = const [
//     TeacherCoursesView(),
//     Center(child: Text("📚 Quizzes Page")), // Placeholder
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//     final bool isSelected = _selectedIndex == index;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//         decoration:
//             isSelected
//                 ? BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                 )
//                 : null,
//         child: Row(
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 fontFamily: AppFonts.mainFont,
//                 fontSize: 12,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(width: 6),
//             Icon(icon, size: isSelected ? 28 : 24, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true, // This is important to make the custom nav transparent.
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.only(left: 12, right: 12, bottom: 50, top: 10),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [AppColors.primaryColor, AppColors.gradientColor],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(Icons.book, "الدورات", 0),
//               _buildNavItem(Icons.quiz, "الاختبارات", 1),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
