import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/models/authentication/auth_response_model.dart';
import 'package:study_platform/models/authentication/login_model.dart';
import 'package:study_platform/services/authentication/login_service.dart';
import 'package:study_platform/services/settings/reset_password_request_service.dart';
import 'package:study_platform/views/Drawer_views/new_password_view.dart';
import 'package:study_platform/views/home_view.dart';
import 'package:study_platform/views/parent_views/parent_dashboard_view.dart';
import 'package:study_platform/views/register_view.dart';
import 'package:study_platform/views/student_views/student_bottom_nav.dart';
import 'package:study_platform/views/teacher_views/teacher_home_view.dart';
import 'package:study_platform/widgets/custom_text_field.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController _passwordController = TextEditingController();
  final PasswordResetService passwordResetService = PasswordResetService();
  String? usernameOrEmail;

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
                          top: 100,
                          width: 240,
                          height: 270,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Image.asset(
                              "assets/images/Studying-bro.png",
                            ),
                          ),
                        ),
                        Positioned(
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
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

                  // 🔹 الجزء السفلي (الفورم الحقيقي بتاعك + logic)
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: formkey,
                      autovalidateMode: autovalidateMode,
                      child: Column(
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1800),
                            child: Column(
                              children: [
                                CustomTextField(
                                  labelText: "Username or Email",
                                  validator: AppValidators.requiredField,
                                  onsaved: (newValue) {
                                    usernameOrEmail = newValue;
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  labelText: "Password",
                                  controller: _passwordController,
                                  validator: AppValidators.passwordValidator,
                                  obscureText: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 🔹 زرار اللوجين
                          FadeInUp(
                            duration: const Duration(milliseconds: 1900),
                            child: loginButton(context),
                          ),
                          const SizedBox(height: 20),

                          // 🔹 Register link
                          FadeInUp(
                            duration: const Duration(milliseconds: 2000),
                            child: goToRegisterView(context),
                          ),

                          const SizedBox(height: 20),

                          // 🔹 Forgot password
                          FadeInUp(
                            duration: const Duration(milliseconds: 2100),
                            child: requestResetPassword(context),
                          ),
                        ],
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

  // ✅ زرار Login زي ما هو (بس بستايل أحلى)
  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.primaryColor,
      ),
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          formkey.currentState!.save();

          final loginModel = LoginModel(
            usernameOrEmail: usernameOrEmail!,
            password: _passwordController.text.trim(),
          );

          setState(() => isLoading = true);

          try {
            AuthResponseModel response = await LoginService().login(loginModel);
            setState(() => isLoading = false);

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("✅ Login Successful")));

            final userType = response.user.userType;

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
          } catch (e) {
            setState(() => isLoading = false);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
          }
        } else {
          setState(() => autovalidateMode = AutovalidateMode.always);
        }
      },
      child: const Text("Login", style: TextStyle(color: AppColors.whiteColor)),
    );
  }

  Row goToRegisterView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegisterView()),
            );
          },
          child: const Text("Register"),
        ),
      ],
    );
  }

  TextButton requestResetPassword(BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() => isLoading = true);
        try {
          await passwordResetService.requestPasswordReset();
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
          ).showSnackBar(const SnackBar(content: Text("❌ حصل خطأ، حاول تاني")));
        }
      },
      child: const Text("نسيت كلمة المرور؟"),
    );
  }
}
