import 'package:flutter/material.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/views/home_view.dart';
import 'package:study_platform/views/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final loggedIn = await StorageService().isLoggedIn();

  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Platform',
      home: loggedIn ? const HomeView() : const RegisterView(),
    );
  }
}
