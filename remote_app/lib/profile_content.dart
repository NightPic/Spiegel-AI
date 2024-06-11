import 'package:flutter/material.dart';
import 'package:remote_app/drawer.dart';


class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Profile'),
      ),
      endDrawer: const AppDrawer(),
      body: const Center(
        child: Text('Profile Content'),
      ),
    );
  }
}