import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/services/settings/reset_password_request_service.dart';
import 'package:study_platform/views/Drawer_views/new_password_view.dart';
import 'package:study_platform/widgets/custom_text_field.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final PasswordResetService passwordResetService = PasswordResetService();

  bool isLoading = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

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
                  // 🔹 الجزء العلوي (ديزاين مع الأنيميشن)
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
                          top: 40,
                          left: 10,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.pop(context); // بيرجع للصفحة اللي قبل
                            },
                          ),
                        ),
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
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: const Center(
                                child: Text(
                                  "نسيت كلمة المرور",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontFamily: AppFonts.mainFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 الجزء السفلي (الفورم الحقيقي)
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: autovalidateMode,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: <Widget>[
                            FadeInUp(
                              duration: const Duration(milliseconds: 1800),
                              child: CustomTextField(
                                controller: _emailController,
                                labelText: "البريد الإلكتروني",
                                validator: AppValidators.emailValidator,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // زرار إرسال
                            FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                onPressed: _sendRequest,
                                child: const Text(
                                  "إرسال",
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontFamily: AppFonts.mainFont,
                                  ),
                                ),
                              ),
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

  Future<void> _sendRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        await passwordResetService.requestPasswordReset(
          _emailController.text.trim(),
        );
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("📩 رابط إعادة التعيين اتبعت لبريدك")),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewPasswordView()),
        );
      } catch (e) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ حصل خطأ: $e")));
      }
    } else {
      setState(() => autovalidateMode = AutovalidateMode.always);
    }
  }
}
