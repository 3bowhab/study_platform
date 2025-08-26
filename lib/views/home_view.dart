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