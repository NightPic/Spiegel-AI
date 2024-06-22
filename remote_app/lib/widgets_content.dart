import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remote_app/drawer.dart';
import 'package:remote_app/websocket_manager.dart';
import 'package:remote_app/profile_content.dart';

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
  String _selectedProfileTitle = 'Widgets';
  Profile? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _loadSelectedProfileName();
  }

  Future<void> _loadSelectedProfileName() async {
    try {
      final file = await _localFile;
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);

      final selectedProfile = jsonList
          .map((json) => Profile.fromJson(json))
          .firstWhere((profile) => profile.isSelected, orElse: () => Profile(id: '', name: ''));

      setState(() {
        _selectedProfileTitle = selectedProfile.name.isEmpty ? 'Widgets' : 'Widgets von ${selectedProfile.name}';
        _selectedProfile = selectedProfile.name.isEmpty ? null : selectedProfile;
        if (selectedProfile.name.isNotEmpty) {
          _loadWidgetSelections(selectedProfile);
        }
      });
    } catch (e) {
      print('Error loading profiles from file: $e');
    }
  }

  void _loadWidgetSelections(Profile selectedProfile) {
  final selectedWidgetIds = selectedProfile.selectedWidgetIds;
  
  if (selectedWidgetIds != null) {
    setState(() {
      widgetSelected = List.generate(WidgetsContent.widgetNames.length, (index) {
        return selectedWidgetIds.contains(index);
      });
    });
  } else {
    print('Selected widget IDs is null');
  }
}


  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/profiles.json');
  }

  void _handleSelection(int index) async {
    setState(() {
      if (widgetSelected[index]) {
        widgetSelected[index] = false;
      } else {
        if (widgetSelected.where((selected) => selected).length >= 8) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Es können nur bis zu 8 Widgets ausgewählt werden.')),
          );
          return;
        }
        widgetSelected[index] = true;
      }
    });
    
    if (_selectedProfile != null) {
      final updatedWidgetIds = List.generate(widgetSelected.length, (i) => widgetSelected[i] ? i : null).whereType<int>().toList();
      _selectedProfile!.selectedWidgetIds = updatedWidgetIds;
      await _saveProfileSelections();
    }
  }

  Future<void> _saveProfileSelections() async {
    try {
      final file = await _localFile;
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      final updatedJsonList = jsonList.map((json) {
        final profile = Profile.fromJson(json);
        if (profile.id == _selectedProfile!.id) {
          return _selectedProfile!.toJson();
        }
        return json;
      }).toList();
      await file.writeAsString(json.encode(updatedJsonList));
    } catch (e) {
      print('Error saving profiles to file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(_selectedProfileTitle),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black,
        ),
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
