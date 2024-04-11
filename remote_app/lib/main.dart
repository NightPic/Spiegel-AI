import 'package:flutter/material.dart';

void main() {
  runApp(RemoteApp());
}

class RemoteApp extends StatelessWidget {
  const RemoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Spiegel AI Remote')),
      ),
    );
  }
}
