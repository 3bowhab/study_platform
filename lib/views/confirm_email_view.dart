import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/services/authentication/register_service.dart';
import 'package:study_platform/services/authentication/resend_ver_code_service.dart';
import 'package:study_platform/views/home_view.dart';
import 'package:study_platform/views/parent_views/parent_dashboard_view.dart';
import 'package:study_platform/views/student_views/student_bottom_nav.dart';
import 'package:study_platform/views/teacher_views/teacher_home_view.dart';
import 'package:study_platform/widgets/custom_text_field.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class ConfirmEmailView extends StatefulWidget {
  const ConfirmEmailView({super.key});

  @override
  State<ConfirmEmailView> createState() => _ConfirmEmailViewState();
}

class _ConfirmEmailViewState extends State<ConfirmEmailView> {
  final formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final StorageService storageService = StorageService();
  String? otp;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // 🔹 الجزء العلوي (نفس ديزاين الريجستر)
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: FadeInUp(
                            duration: const Duration(seconds: 1),
                            child: Image.asset("assets/images/light-1.png"),
                          ),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 120,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Image.asset("assets/images/light-2.png"),
                          ),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Image.asset("assets/images/clock.png"),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 105,
                          width: 220,
                          height: 250,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Image.asset(
                              "assets/images/otp.png", // ممكن تغيرها لصورة OTP
                            ),
                          ),
                        ),
                        Positioned(
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: const Center(
                                child: Text(
                                  "تأكيد البريد\nالإلكتروني",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: AppFonts.mainFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 الجزء السفلي (الفورم بتاع OTP)
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: formkey,
                      autovalidateMode: autovalidateMode,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: <Widget>[
                            FadeInUp(
                              duration: const Duration(milliseconds: 1800),
                              child: CustomTextField(
                                labelText: 'رمز التحقق (OTP)',
                                validator: AppValidators.requiredField,
                                onsaved: (newValue) => otp = newValue,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(height: 30),

                            FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: confirmButton(context),
                            ),
                            const SizedBox(height: 20),

                            FadeInUp(
                              duration: const Duration(milliseconds: 2000),
                              child: resendButton(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) const LoadingIndicator(),
      ],
    );
  }

  ElevatedButton confirmButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.primaryColor,
      ),
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          formkey.currentState!.save();

          try {
            String response = await RegisterService().confirmEmail(otp!);

            setState(() => isLoading = false);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Registration Successful")),
            );

            final userType = await storageService.getUserType();
            if (userType == null) {
              throw Exception("❌ No user type found, please login again.");
            }

            Widget dashboardPage;
            switch (userType) {
              case "student":
                dashboardPage = const StudentBottomNav();
                break;
              case "teacher":
                dashboardPage = const TeacherHomeView();
                break;
              case "parent":
                dashboardPage = const ParentDashboardView();
                break;
              default:
                dashboardPage = const HomeView();
            }

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => dashboardPage),
              (route) => false,
            );

            print("Response: $response");
          } catch (e) {
            setState(() => isLoading = false);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("❌ Error: $e"),
                duration: const Duration(seconds: 15),
              ),
            );
          }
        } else {
          setState(() => autovalidateMode = AutovalidateMode.always);
        }
      },
      child: const Text(
        "تأكيد",
        style: TextStyle(color: Colors.white, fontFamily: AppFonts.mainFont),
      ),
    );
  }

  TextButton resendButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() => isLoading = true);

        try {
          await ResendVerificationEmailService().resendVerificationEmail();

          setState(() => isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("📩 Verification email sent successfully"),
            ),
          );
        } catch (e) {
          setState(() => isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("❌ Error: $e"),
              duration: const Duration(seconds: 15),
            ),
          );
        }
      },
      child: const Text(
        "إعادة إرسال الرمز",
        style: TextStyle(
          fontFamily: AppFonts.mainFont,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
