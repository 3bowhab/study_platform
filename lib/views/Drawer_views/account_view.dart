import 'package:flutter/material.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/services/account/delete_account_service.dart';
import 'package:study_platform/views/Drawer_views/change_password_view.dart';
import 'package:study_platform/views/register_view.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class AccountView extends StatefulWidget {
  AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  DeleteAccountService deleteAccountService = DeleteAccountService();
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
                changePassword(context),
                SizedBox(height: 20),
                deleteAccount(context),
              ]
            )
          ),
        ),
        if (isLoading) const LoadingIndicator(),
      ]
    );
  }

  ElevatedButton changePassword(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordView()),
        );
      },
      child: const Text("تغيير كلمة السر"),
    );
  }

  ElevatedButton deleteAccount(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("تأكيد الحذف"),
                content: const Text(
                  "هل أنت متأكد أنك تريد حذف الحساب؟ لا يمكن التراجع بعد ذلك.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("إلغاء"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("حذف"),
                  ),
                ],
              ),
        );

        if (confirm != true) return; // المستخدم لغى

        setState(() => isLoading = true);

        try {
          await deleteAccountService.deleteAccount();
          await StorageService().logout();

          setState(() => isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Account deleted successfully")),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RegisterView()),
            (route) => false,
          );
        } catch (e) {
          setState(() => isLoading = false);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
      child: const Text("حذف الحساب"),
    );
  }
}
