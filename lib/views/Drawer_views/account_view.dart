import 'package:flutter/material.dart';
import 'package:study_platform/services/account/profile_repository.dart';
import 'package:study_platform/views/Drawer_views/profile_view.dart';
import 'package:study_platform/widgets/loading_indecator.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

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
                profileButton(context),
                // const SizedBox(height: 20),
                // editProfileButton(context),
              ],
            ),
          ),
        ),
        if (isLoading) const LoadingIndicator(),
      ],
    );
  }

  ElevatedButton profileButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() => isLoading = true);

        try {
          final profile = await ProfileRepository().getUserProfile();

          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileView(profile: profile),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("فشل تحميل البيانات: $e")));
        } finally {
          if (mounted) setState(() => isLoading = false);
        }
      },
      child: const Text("بيانات الحساب"),
    );
  }


  // ElevatedButton  editProfileButton(BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: () async {
  //     },
  //     child: const Text("تعديل بيانات الحساب"),
  //   );
  // }
}
