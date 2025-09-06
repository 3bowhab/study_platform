// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/models/authentication/register_model.dart';
import 'package:study_platform/services/authentication/link_child_service.dart';
import 'package:study_platform/services/authentication/register_service.dart';
import 'package:study_platform/views/confirm_email_view.dart';
import 'package:study_platform/views/login_view.dart';
import 'package:study_platform/widgets/birthday_input.dart';
import 'package:study_platform/widgets/custom_text_field.dart';
import 'package:study_platform/widgets/loading_indecator.dart';
import 'package:study_platform/widgets/register_user_type.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String? firstName, lastName, phoneNumber, userType, childUsername, dateOfBirth;

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
                    controller: _usernameController,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Email',
                    validator: AppValidators.emailValidator,
                    controller: _emailController,
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
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'phone number',
                    validator: AppValidators.phoneValidator,
                    onsaved: (newValue) {
                      phoneNumber = newValue;
                    },
                  ),
                  SizedBox(height: 16),
                  // CustomTextField(
                  //   labelText: 'user type',
                  //   validator: AppValidators.requiredField,
                  //   onsaved: (newValue) {
                  //     userType = newValue;
                  //   },
                  // ),
                  SizedBox(height: 16),
                  BirthDateField(
                    initialDate: dateOfBirth,
                    onChanged: (value) {
                      dateOfBirth = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  RegisterUserType(
                    onUserTypeSelected: (selectedType, child) {
                      userType = selectedType;
                      childUsername = child;
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
      if (isLoading) const LoadingIndicator(),  
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

          final registerModel = RegisterModel(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            confirmPassword: _confirmController.text.trim(),
            firstname: firstName!,
            lastname: lastName!,
            phoneNumber: phoneNumber!,
            userType: userType!,
            dateOfBirth: dateOfBirth!,
          );

          setState(() {
            isLoading = true;
          });

          try {
            // ✨ Step 1: Register
            final response = await RegisterService().register(registerModel);
            print("✅ Register response: $response");

            // ✨ Step 2: Link child (only if parent)
            if (userType == "parent" &&
                childUsername != null &&
                childUsername!.isNotEmpty) {
              try {
                await LinkChildService().linkChild(childUsername!);
                print("✅ Child linked successfully");
              } catch (e) {
                print("❌ Error linking child: $e");
                // تقدر هنا تختار: توقف الفلو ولا تكمل عادي
              }
            }

            setState(() {
              isLoading = false;
            });

            // ✨ Step 3: Navigate to confirm email
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Registration Successful")),
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ConfirmEmailView()),
            );
          } catch (e) {
            setState(() {
              isLoading = false;
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
      child: const Text("Submit"),
    );
  }
}
