import 'package:concentric_transition/page_view.dart';
import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/views/register_view.dart';

final pages = [
  const PageData(
    icon: Icons.school,
    title: "ابدأ رحلتك التعليمية بسهولة وتعلم أينما كنت",
    bgColor: AppColors.primaryColor,
    textColor: AppColors.tertiaryColor,
  ),
  const PageData(
    icon: Icons.edit_note,
    title: "تدرب على الدروس والاختبارات خطوة بخطوة",
    bgColor: AppColors.secondaryColor,
    textColor: AppColors.primaryColor,
  ),
  const PageData(
    icon: Icons.trending_up,
    title: "تابع تقدمك وحقق أهدافك التعليمية معنا",
    bgColor: AppColors.tertiaryColor,
    textColor: AppColors.primaryColor,
  ),
];

class ConcentricAnimationOnboarding extends StatelessWidget {
  const ConcentricAnimationOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Icon(Icons.navigate_next, size: screenWidth * 0.08),
          );
        },
        itemCount: pages.length,
        opacityFactor: 2.0,
        scaleFactor: 2,
        onFinish: () async {
          final storage = StorageService();
          await storage.setSeenOnboarding(true);

          // استنى الانيميشن الصغير
          await Future.delayed(const Duration(milliseconds: 800));

          Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => const RegisterView(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ));
        },

        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(child: _Page(page: page));
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class _Page extends StatelessWidget {
  final PageData page;
  final bool isLastPage;

  // ignore: unused_element_parameter
  const _Page({required this.page, this.isLastPage = false});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final childContent = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: page.textColor,
            ),
            child: Icon(page.icon, size: screenHeight * 0.1, color: page.bgColor),
          ),
          Text(
            page.title ?? "",
            style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.035,
              fontFamily: AppFonts.mainFont,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return isLastPage
        ? AnimatedScale(
            duration: const Duration(milliseconds: 800),
            scale: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: 0,
              child: childContent,
            ),
          )
        : childContent;
  }
}
