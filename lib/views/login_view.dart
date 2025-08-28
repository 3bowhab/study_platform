import 'package:flutter/material.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/models/authentication/auth_response_model.dart';
import 'package:study_platform/models/authentication/login_model.dart';
import 'package:study_platform/services/authentication/login_service.dart';
import 'package:study_platform/views/home_view.dart';
import 'package:study_platform/views/register_view.dart';
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

            await StorageService().saveTokens(
              response.tokens.access,
              response.tokens.refresh,
              response.user.fullName,
              response.user.email,
            );

            setState(() {
              isLoading = false; // ✅ وقف اللودينج
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Login Successful")),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false, // false = ميخليش أي صفحة قديمة
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
}