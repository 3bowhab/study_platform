import 'package:flutter/material.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/services/password/reset_password_request_service.dart';
import 'package:study_platform/widgets/custom_text_field.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  String? otp;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final PasswordResetService passwordResetConfirmService = PasswordResetService();

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
            appBar: AppBar(title: const Text('كلمة مرور جديدة')),
            body: Form(
              key: formkey,
              autovalidateMode: autovalidateMode,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  CustomTextField(
                    labelText: 'OTP',
                    validator: AppValidators.requiredField,
                    onsaved: (newValue) {
                      otp = newValue;
                    },
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 20),
                  submitButton(context),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) const LoadingIndicator(),
      ],
    );
  }

  ElevatedButton submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          formkey.currentState!.save();

          setState(() {
            isLoading = true; // ⏳ يبدأ اللودينج
          });

          try {
            await passwordResetConfirmService.confirmPasswordReset(
              otp!,
              _passwordController.text,
              _confirmController.text,
            );

            setState(() {
              isLoading = false; // ✅ وقف اللودينج
            });

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("✅ Password Reset Successful")));

            Navigator.pop(context);

            // print("Response: $response");
          } catch (e) {
            setState(() {
              isLoading = false; // ❌ وقف اللودينج برضه
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
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
      child: const Text("تأكيد"),
    );
  }
}
