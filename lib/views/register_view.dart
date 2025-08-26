// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/models/register_model.dart';
import 'package:study_platform/services/auth_services.dart';
import 'package:study_platform/views/confirm_email_view.dart';
import 'package:study_platform/views/login_view.dart';
import 'package:study_platform/widgets/custom_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String? email, username, firstName, lastName;

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
          appBar: AppBar(title: const Text('Register')),
          body: Form(
            key: formkey,
            autovalidateMode: autovalidateMode,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  SizedBox(height: 8),
                  CustomTextField(
                    labelText: 'Username',
                    validator: AppValidators.usernameValidator,
                    onsaved: (newValue) {
                      username = newValue;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Email',
                    validator: AppValidators.emailValidator,
                    onsaved: (newValue) {
                      email = newValue;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Password',
                    controller: _passwordController,
                    validator: AppValidators.passwordValidator,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Confirm Password',
                    controller: _confirmController,
                    obscureText: true,
                    validator:
                        (value) => AppValidators.confirmPasswordValidator(
                          value,
                          _passwordController.text,
                        ),
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'First Name',
                    validator: AppValidators.usernameValidator,
                    onsaved: (newValue) {
                      firstName = newValue;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Last Name',
                    validator: AppValidators.usernameValidator,
                    onsaved: (newValue) {
                      lastName = newValue;
                    },
                  ),
                  const SizedBox(height: 20),
                  submitButton(context),
                  const SizedBox(height: 20),
                  goToLoginView(context)
                ],
              ),
            ),
          ),
        ),
      ),

       if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
      ],
    );
  }



  Row goToLoginView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          child: const Text("Login"),
        ),
      ],
    );
  }



  ElevatedButton submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          formkey.currentState!.save();

          // ✨ نكوّن الموديل
          final registerModel = RegisterModel(
            username: username!,
            email: email!,
            password: _passwordController.text.trim(),
            confirmPassword: _confirmController.text.trim(),
            firstname: firstName!,
            lastname: lastName!,
          );

          setState(() {
            isLoading = true; // ⏳ يبدأ اللودينج
          });

          try {
            // ✨ ننده السيرفيس ونبعت الموديل.toJson()
            final response = await RegisterService().register(registerModel);

            setState(() {
              isLoading = false; // ✅ وقف اللودينج
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Registration Successful")),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ConfirmEmailView()),
              (route) => false, // false = ميخليش أي صفحة قديمة
            );

            print("Response: $response");
          } catch (e) {
            setState(() {
              isLoading = false; // ❌ وقف اللودينج برضه
            });
            
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
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
      child: const Text("Submit"),
    );
  }
}
