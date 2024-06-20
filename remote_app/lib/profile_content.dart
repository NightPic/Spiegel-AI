import 'package:flutter/material.dart';
import 'package:remote_app/drawer.dart';
import 'package:remote_app/websocket_manager.dart';


class ProfileContent extends StatelessWidget {
  final WebSocketManager webSocketManager;

  const ProfileContent({super.key, required this.webSocketManager});

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