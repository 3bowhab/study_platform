import 'package:flutter/material.dart';
import 'package:study_platform/services/auth_services.dart';
import 'package:study_platform/views/Drawer_views/change_password_view.dart';
import 'package:study_platform/views/Drawer_views/new_password_view.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class AccountView extends StatefulWidget {
  AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final PasswordResetService passwordResetService = PasswordResetService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("الحساب")),
          body: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => const ChangePasswordView()
                      )
                    );
                  },
                  child: const Text("تغيير كلمة السر"),
                ),
              ]
            )
          ),
        ),
        if (isLoading) const LoadingIndicator(),
      ]
    );
  }

  ElevatedButton newMethod(BuildContext context) {
    return ElevatedButton(
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
                const SnackBar(
                  content: Text("📩 رابط إعادة التعيين اتبعت لبريدك"),
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewPasswordView()),
              );
            } catch (e) {
              setState(() {
                isLoading = false; // ⏳ ينتهي اللودينج
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ حصل خطأ، حاول تاني")),
              );
            }
          },
          child: const Text("إرسال رابط إعادة التعيين"),
        );
  }
}
