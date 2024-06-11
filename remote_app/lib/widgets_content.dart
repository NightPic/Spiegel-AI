import 'package:flutter/material.dart';
import 'package:remote_app/drawer.dart';

class WidgetsContent extends StatelessWidget {
  const WidgetsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Widgets'),
      ),
      endDrawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: ListTile(
              title: Text('Widget ${index + 1}'),
              onTap: () {
                // Handle onTap event here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Widget ${index + 1} clicked')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
