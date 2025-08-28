import 'package:flutter/material.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/services/auth_services.dart';
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
  ChangePasswordService changePasswordService = ChangePasswordService();
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
            appBar: AppBar(title: const Text('تغيير كلمة المرور')),
            body: Form(
              key: formkey,
              autovalidateMode: autovalidateMode,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  CustomTextField(
                    labelText: 'Old Password',
                    controller: _oldPasswordController,
                    validator: AppValidators.passwordValidator,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'New Password',
                    controller: _newPasswordController,
                    validator: AppValidators.passwordValidator,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Confirm New Password',
                    controller: _confirmController,
                    obscureText: true,
                    validator:
                        (value) => AppValidators.confirmPasswordValidator(
                          value,
                          _newPasswordController.text,
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
            await changePasswordService.changePassword(
              _oldPasswordController.text,
              _newPasswordController.text,
              _confirmController.text,
            );

            setState(() {
              isLoading = false; // ✅ وقف اللودينج
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Password Reset Successful")),
            );

            Navigator.pop(context);
          } catch (e) {
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
          setState(() {
            autovalidateMode = AutovalidateMode.always;
          });
        }
      },
      child: const Text("تأكيد"),
    );
  }
}