import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 212, 230, 25),
            ),
            child: Text(
              'Spiegel AI',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Einstellungen'),
            onTap: () {
              // Update UI based on item selected
            },
          ),
          ListTile(
            title: const Text('Account'),
            onTap: () {
              // Update UI based on item selected
            },
          ),
        ],
      ),
    );
  }
}
