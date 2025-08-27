import 'package:flutter/material.dart';
import 'package:study_platform/services/auth_services.dart';

class AccountView extends StatelessWidget {
  AccountView({super.key});

  final PasswordResetService passwordResetService = PasswordResetService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الحساب")),
      body: Center(child: ElevatedButton(
          onPressed: () async {
            try {
              await passwordResetService.requestPasswordReset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("📩 رابط إعادة التعيين اتبعت لبريدك"),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ حصل خطأ، حاول تاني")),
              );
            }
          },
          child: const Text("إرسال رابط إعادة التعيين"),
        ),
      ),
    );
  }
}
