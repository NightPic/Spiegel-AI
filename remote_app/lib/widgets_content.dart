import 'package:flutter/material.dart';
import 'package:remote_app/drawer.dart';
import 'package:remote_app/websocket_manager.dart';

class WidgetsContent extends StatefulWidget {
  final WebSocketManager webSocketManager;

  const WidgetsContent({super.key, required this.webSocketManager});

  static const List<String> widgetNames = [
    'Kalender',
    'Uhr',
    'Wetter',
    'Notizen',
    'Termine',
    'Verkehr',
    'Nachrichten',
    'Tanken',
    'Profil',
    'TestWidget'
  ];

  @override
  // ignore: library_private_types_in_public_api
  _WidgetsContentState createState() => _WidgetsContentState();
}

class _WidgetsContentState extends State<WidgetsContent> {
  List<bool> widgetSelected = List.filled(WidgetsContent.widgetNames.length, false);

  void _handleSelection(int index) {
    setState(() {
      if (widgetSelected[index]) {
        widgetSelected[index] = false;
      } else {
        // Check if already 8 widgets selected
        if (widgetSelected.where((selected) => selected).length >= 8) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Only up to 8 widgets can be selected')),
          );
          return;
        }
        widgetSelected[index] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Widgets'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black,
        )
      ),
      endDrawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: WidgetsContent.widgetNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(
                  WidgetsContent.widgetNames[index],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Switch(
                  value: widgetSelected[index],
                  onChanged: (value) {
                    _handleSelection(index);
                  },
                  activeColor: Colors.indigoAccent,
                ),
                onTap: () {
                  _handleSelection(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
