import 'package:flutter/material.dart';
import 'package:study_platform/widgets/custom_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: CustomDrawer(),
      body: const Center(child: Text('Welcome to the Home Page!')),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:study_platform/widgets/custom_drawer.dart';
// import 'package:study_platform/helper/storage_service.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   String? accessToken;

//   @override
//   void initState() {
//     super.initState();
//     _loadToken();
//   }

//   Future<void> _loadToken() async {
//     final token = await StorageService().getAccessToken();
//     setState(() {
//       accessToken = token;
//     });

//     print("🔑 Access Token: $token"); // يطبع في الـ Debug Console
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home')),
//       drawer: const CustomDrawer(),
//       body: Center(
//         child: Text(
//           accessToken != null ? "🔑 Token: $accessToken" : "⏳ Loading token...",
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
