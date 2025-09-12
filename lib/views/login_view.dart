import 'package:flutter/material.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/models/authentication/auth_response_model.dart';
import 'package:study_platform/models/authentication/login_model.dart';
import 'package:study_platform/services/authentication/login_service.dart';
import 'package:study_platform/services/authentication/refresh_token_service.dart';
import 'package:study_platform/services/settings/reset_password_request_service.dart';
import 'package:study_platform/views/Drawer_views/new_password_view.dart';
import 'package:study_platform/views/home_view.dart';
import 'package:study_platform/views/parent_views/parent_dashboard_view.dart';
import 'package:study_platform/views/register_view.dart';
import 'package:study_platform/views/student_views/student_bottom_nav.dart';
import 'package:study_platform/views/teacher_views/teacher_dashboard_view.dart';
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
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: Form(
              key: formkey,
              autovalidateMode: autovalidateMode,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  CustomTextField(
                    labelText: "Username or Email",
                    validator: AppValidators.requiredField,
                    onsaved: (newValue) {
                      usernameOrEmail = newValue;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Password',
                    controller: _passwordController,
                    validator: AppValidators.passwordValidator,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  loginButton(context),
                  const SizedBox(height: 20),
                  goToRegisterView(context),
                  // requestResetPassword(context),
                ],
              ),
            )
          ),
        ),
        if (isLoading) const LoadingIndicator(),
      ],
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



  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          formkey.currentState!.save();

          // ✨ نكوّن الموديل
          final loginModel = LoginModel(
            usernameOrEmail: usernameOrEmail!,
            password: _passwordController.text.trim(),
          );

          setState(() {
            isLoading = true; // ⏳ يبدأ اللودينج
          });

          try {
            // ✨ ننده السيرفيس ونبعت الموديل.toJson()
            AuthResponseModel response = await LoginService().login(loginModel);

            setState(() {
              isLoading = false; // ✅ وقف اللودينج
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Login Successful")),
            );

            final userType = response.user.userType; // 👈 استخرج الـ userType من الموديل

            Widget dashboardPage;
            switch (userType) {
              case "student":
                dashboardPage = const StudentBottomNav();
                break;
              case "teacher":
                dashboardPage = const TeacherDashboardView();
                break;
              case "parent":
                dashboardPage = const ParentDashboardView();
                break;
              default:
                dashboardPage = const HomeView(); // fallback لو حاجة مش متوقعة
            }

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => dashboardPage),
              (route) => false,
            );

            print("Response: $response");
          } catch (e) {
            setState(() {
              isLoading = false; // ❌ وقف اللودينج برضه
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("❌ Error: $e"),
                duration: const Duration(seconds: 15),
              ),
            );
          }
        } else {
          setState(() {
            autovalidateMode = AutovalidateMode.always;
          });
        }
      },
      child: const Text("Login"),
    );
  }

  TextButton requestResetPassword(BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() {
          isLoading = true; // ⏳ يبدأ اللودينج
        });

        try {
          await passwordResetService.requestPasswordReset();
          setState(() {
            isLoading = false; // ⏳ ينتهي اللودينج
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("📩 رابط إعادة التعيين اتبعت لبريدك")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPasswordView()),
          );
        } catch (e) {
          setState(() {
            isLoading = false; // ⏳ ينتهي اللودينج
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("❌ حصل خطأ، حاول تاني")));
          print("Error requesting password reset: $e");
        }
      },
      child: const Text("نسيت كلمة المرور؟"),
    );
  }
}