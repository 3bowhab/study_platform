import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/services/settings/change_password_service.dart';
import 'package:study_platform/services/settings/reset_password_request_service.dart';
import 'package:study_platform/widgets/custom_text_field.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool isLoading = false;

  final ChangePasswordService changePasswordService = ChangePasswordService();
  final PasswordResetService passwordResetService = PasswordResetService();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // 💡 الجزء العلوي (الخلفية + الصور + العنوان)
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
                            right: 10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
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
                          // الجزء المعدل في الكود
                          Positioned(
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: Container(
                                margin: const EdgeInsets.only(top: 50),
                                child: const Center(
                                  child: Column(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min, // 💡 جديد: يجعل العمود يأخذ أقل مساحة ممكنة
                                    children: [
                                      Text(
                                        "تغيير كلمة",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontFamily: AppFonts.mainFont,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "المرور",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontFamily: AppFonts.mainFont,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 💡 الجزء السفلي (الفورم)
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
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      labelText: 'كلمة المرور القديمة',
                                      controller: _oldPasswordController,
                                      validator:
                                          AppValidators.passwordValidator,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      labelText: 'كلمة المرور الجديدة',
                                      controller: _newPasswordController,
                                      validator:
                                          AppValidators.passwordValidator,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      labelText: 'تأكيد كلمة المرور الجديدة',
                                      controller: _confirmController,
                                      obscureText: true,
                                      validator:
                                          (value) =>
                                              AppValidators.confirmPasswordValidator(
                                                value,
                                                _newPasswordController.text,
                                              ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),

                              // 💡 زر التأكيد
                              FadeInUp(
                                duration: const Duration(milliseconds: 1900),
                                child: submitButton(context),
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
      ),
    );
  }

  ElevatedButton submitButton(BuildContext context) {
    return ElevatedButton(
      // 💡 تصميم الزر مطابق لـ NewPasswordView
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.primaryColor,
      ),
      onPressed:
          isLoading
              ? null
              : () async {
                if (formkey.currentState!.validate()) {
                  formkey.currentState!.save();

                  if (!mounted) return;
                  setState(() {
                    isLoading = true; // ⏳ يبدأ اللودينج
                  });

                  try {
                    await changePasswordService.changePassword(
                      _oldPasswordController.text,
                      _newPasswordController.text,
                      _confirmController.text,
                    );

                    if (!mounted) return;
                    setState(() {
                      isLoading = false; // ✅ وقف اللودينج
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Password Changed Successfully"),
                      ),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    if (!mounted) return;
                    setState(() {
                      isLoading = false; // ❌ وقف اللودينج برضه
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                } else {
                  if (!mounted) return;
                  setState(() {
                    autovalidateMode = AutovalidateMode.always;
                  });
                }
              },
      child: const Text(
                "تأكيد",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.mainFont,
                ),
              ),
    );
  }
}
