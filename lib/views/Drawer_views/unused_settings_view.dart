// import 'package:flutter/material.dart';
// import 'package:study_platform/helper/app_colors_fonts.dart';
// import 'package:study_platform/helper/storage_service.dart';
// import 'package:study_platform/services/settings/delete_account_service.dart';
// import 'package:study_platform/views/Drawer_views/change_password_view.dart';
// import 'package:study_platform/views/register_view.dart';
// import 'package:study_platform/widgets/app_bar.dart'; // 💡 استيراد GradientAppBar
// import 'package:study_platform/widgets/loading_indecator.dart';

// class SettingsView extends StatefulWidget {
//   const SettingsView({super.key});

//   @override
//   State<SettingsView> createState() => _SettingsViewState();
// }

// class _SettingsViewState extends State<SettingsView> {
//   DeleteAccountService deleteAccountService = DeleteAccountService();
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Stack(
//         children: [
//           Scaffold(
//             appBar: GradientAppBar(title: "الإعدادات", hasDrawer: false),
//             // 💡 تغيير الـ body ليتناسب مع شكل الدرور
//             body: ListView(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16.0,
//                 vertical: 8.0,
//               ),
//               children: [
//                 _buildSettingsTile(
//                   title: "تغيير كلمة السر",
//                   icon: Icons.lock_outline,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ChangePasswordView(),
//                       ),
//                     );
//                   },
//                 ),
//                 const Divider(height: 1),
//                 _buildDeleteAccountTile(),
//               ],
//             ),
//           ),
//           if (isLoading) const LoadingIndicator(),
//         ],
//       ),
//     );
//   }

//   // 💡 دالة جديدة لبناء Tile الإعدادات
//   Widget _buildSettingsTile({
//     required String title,
//     required IconData icon,
//     required VoidCallback onTap,
//     Color color = AppColors.primaryColor,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontFamily: AppFonts.mainFont,
//           fontSize: 16,
//           color: color,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }

//   // 💡 دالة خاصة بزر حذف الحساب
//   Widget _buildDeleteAccountTile() {
//     return ListTile(
//       leading: Icon(Icons.delete_outline, color: Colors.red.shade700),
//       title: Text(
//         "حذف الحساب",
//         style: TextStyle(
//           fontFamily: AppFonts.mainFont,
//           fontSize: 16,
//           color: Colors.red.shade700,
//         ),
//       ),
//       onTap:
//           isLoading
//               ? null
//               : () async {
//                 final confirm = await showDialog<bool>(
//                   context: context,
//                   builder:
//                       (dialogContext) => Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: AlertDialog(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           title: Text(
//                             "تأكيد الحذف",
//                             style: TextStyle(
//                               fontFamily: AppFonts.mainFont,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red.shade700,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           content: const Text(
//                             "هل أنت متأكد أنك تريد حذف الحساب؟ لا يمكن التراجع بعد ذلك.",
//                             style: TextStyle(
//                               fontFamily: AppFonts.mainFont,
//                               fontSize: 16,
//                               color: Colors.black87,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           actionsAlignment: MainAxisAlignment.center,
//                           actions: [
//                             TextButton(
//                               onPressed:
//                                   () => Navigator.pop(dialogContext, false),
//                               child: Text(
//                                 "إلغاء",
//                                 style: TextStyle(
//                                   fontFamily: AppFonts.mainFont,
//                                   color: AppColors.primaryColor,
//                                 ),
//                               ),
//                             ),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red.shade700,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               onPressed:
//                                   () => Navigator.pop(dialogContext, true),
//                               child: const Text(
//                                 "حذف",
//                                 style: TextStyle(fontFamily: AppFonts.mainFont),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                 );

//                 if (confirm != true) return;

//                 if (!mounted) return;
//                 setState(() => isLoading = true);

//                 try {
//                   await deleteAccountService.deleteAccount();
//                   await StorageService().logout();

//                   if (!mounted) return;
//                   setState(() => isLoading = false);

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("✅ Account deleted successfully"),
//                     ),
//                   );

//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const RegisterView(),
//                     ),
//                     (route) => false,
//                   );
//                 } catch (e) {
//                   if (!mounted) return;
//                   setState(() => isLoading = false);
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text(e.toString())));
//                 }
//               },
//     );
//   }
// }
