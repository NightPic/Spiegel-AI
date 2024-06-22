import 'package:flutter/material.dart';
import 'package:remote_app/modules/profile/profile.dart';
import 'package:remote_app/shared/drawer.dart';
import 'package:remote_app/shared/websocket_manager.dart';
import 'package:remote_app/services/profile_service.dart'; // Import your profile service

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
  WidgetsContentState createState() => WidgetsContentState();
}

class WidgetsContentState extends State<WidgetsContent> {
  List<Profile> profiles = [];
  final ProfileService _profileService =
      ProfileService(); // Initialize profile service
  List<bool> widgetSelected =
      List.filled(WidgetsContent.widgetNames.length, false);
  String _selectedProfileTitle = 'Widgets';
  Profile? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _loadSelectedProfileName();
  }

  Future<void> _loadSelectedProfileName() async {
    try {
      profiles = await _profileService.loadProfiles();

      final selectedProfile = profiles.firstWhere(
          (profile) => profile.isSelected,
          orElse: () => Profile(id: '', name: ''));

      setState(() {
        _selectedProfileTitle = selectedProfile.name.isEmpty
            ? 'Widgets'
            : 'Widgets von ${selectedProfile.name}';
        _selectedProfile =
            selectedProfile.name.isEmpty ? null : selectedProfile;
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
        widgetSelected =
            List.generate(WidgetsContent.widgetNames.length, (index) {
          return selectedWidgetIds.contains(index);
        });
      });
    } else {
      print('Selected widget IDs is null');
    }
  }

  void _handleSelection(int index) async {
    setState(() {
      if (widgetSelected[index]) {
        widgetSelected[index] = false;
      } else {
        if (widgetSelected.where((selected) => selected).length >= 8) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Es können nur bis zu 8 Widgets ausgewählt werden.')),
          );
          return;
        }
        widgetSelected[index] = true;
      }
    });

    if (_selectedProfile != null) {
      final updatedWidgetIds = List.generate(
              widgetSelected.length, (i) => widgetSelected[i] ? i : null)
          .whereType<int>()
          .toList();
      _selectedProfile!.selectedWidgetIds = updatedWidgetIds;
      await _saveProfileSelections();
    }
  }

  Future<void> _saveProfileSelections() async {
    await _profileService.saveProfiles(
        profiles); // Pass the profile wrapped in a list
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
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
