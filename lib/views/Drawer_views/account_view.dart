import 'package:flutter/material.dart';
import 'package:study_platform/views/Drawer_views/change_password_view.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class AccountView extends StatefulWidget {
  AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
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
}
