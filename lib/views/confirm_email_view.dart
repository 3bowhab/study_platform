import 'package:flutter/material.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/services/authentication/register_service.dart';
import 'package:study_platform/services/authentication/resend_ver_code_service.dart';
import 'package:study_platform/views/home_view.dart';
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
  String? otp;
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
            appBar: AppBar(title: const Text('Confirm Email')),
            body: Form(
              key: formkey,
              autovalidateMode: autovalidateMode,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomTextField(
                      labelText: 'OTP',
                      validator: AppValidators.requiredField,
                      onsaved: (newValue) {
                        otp = newValue;
                      },
                    ),
                    const SizedBox(height: 16),
                    confirmButton(context),
                    const SizedBox(height: 16),
                    resendButton(context),
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

  ElevatedButton confirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          formkey.currentState!.save();

          try {
            String response = await RegisterService().confirmEmail(otp!);

            setState(() {
              isLoading = false; // ✅ وقف اللودينج
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Registration Successful")),
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
      child: const Text('Confirm'),
    );
  }

  TextButton resendButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() {
          isLoading = true; // ⏳ يبدأ اللودينج
        });

        try {
          await ResendVerificationEmailService().resendVerificationEmail();

          setState(() {
            isLoading = false; // ✅ وقف اللودينج
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("📩 Verification email sent successfully"),
            ),
          );
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
      },
      child: const Text("Resend Verification Email"),
    );
  }
}
