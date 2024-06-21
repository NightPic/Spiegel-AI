import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remote_app/drawer.dart';
import 'package:remote_app/websocket_manager.dart';

class Profile {
  final String id;
  final String name;
  bool isSelected;

  Profile({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isSelected': isSelected,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      isSelected: json['isSelected'] ?? false,
    );
  }

  void select() {
    isSelected = true;
  }

  void deselect() {
    isSelected = false;
  }
}

class ProfileContent extends StatefulWidget {
  final WebSocketManager webSocketManager;

  const ProfileContent({Key? key, required this.webSocketManager})
      : super(key: key);

  static List<Profile> profiles = [];
  static Profile? selectedProfile;

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final TextEditingController _profileNameController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfiles(); // Load profiles when the widget initializes
  }

  Future<void> _loadProfiles() async {
    try {
      final file = await _localFile;
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        ProfileContent.profiles =
            jsonList.map((json) => Profile.fromJson(json)).toList();

        // Find the selected profile and ensure only one is selected
        Profile? selectedProfile = ProfileContent.profiles.firstWhere(
          (profile) => profile.isSelected,
          orElse: () => Profile(id: '', name: ''),
        );

        // Deselect all profiles first
        for (var profile in ProfileContent.profiles) {
          profile.deselect();
        }

        // Select the loaded selected profile, if any
        ProfileContent.selectedProfile = ProfileContent.profiles.firstWhere(
          (profile) => profile.id == selectedProfile.id,
          orElse: () => Profile(id: '', name: ''),
        );
        if (ProfileContent.selectedProfile != null) {
          ProfileContent.selectedProfile!.select();
        }
      });
    } catch (e) {
      print('Error loading profiles from file: $e');
    }
  }

  Future<void> _saveProfiles() async {
    try {
      final jsonString = json.encode(
          ProfileContent.profiles.map((profile) => profile.toJson()).toList());
      print(jsonString);
      final file = await _localFile;
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving profiles to file: $e');
    }
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/profiles.json');
  }

  void _showAddProfileDialog() {
    setState(() {
      _errorMessage = null;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profil hinzufügen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _profileNameController,
                decoration: InputDecoration(
                  labelText: 'Profilname',
                  errorText: _errorMessage,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                // Clear the text field and dismiss the dialog
                _profileNameController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Bestätigen'),
              onPressed: () {
                setState(() {
                  if (_profileNameController.text.isNotEmpty) {
                    if (ProfileContent.profiles.any((profile) =>
                        profile.name == _profileNameController.text)) {
                      _errorMessage = 'Dieser Name ist bereits vergeben.';
                    } else {
                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      Profile newProfile =
                          Profile(id: id, name: _profileNameController.text);
                      ProfileContent.profiles.add(newProfile);

                      // Deselect previously selected profile if any
                      if (ProfileContent.selectedProfile != null) {
                        ProfileContent.selectedProfile!.deselect();
                      }

                      // Select the newly added profile
                      ProfileContent.selectedProfile = newProfile;
                      newProfile.select();

                      _saveProfiles(); // Save profiles after adding new profile
                      _errorMessage = null;
                      // Clear the text field and dismiss the dialog
                      _profileNameController.clear();
                      Navigator.of(context).pop();
                    }
                  } else {
                    _errorMessage = 'Name darf nicht leer sein.';
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteProfileDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Profil ${ProfileContent.profiles[index].name} wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Nein'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ja'),
              onPressed: () {
                setState(() {
                  Profile profileToDelete = ProfileContent.profiles[index];

                  // Deselect if the profile to delete is selected
                  if (profileToDelete.isSelected) {
                    ProfileContent.selectedProfile = null;
                  }

                  ProfileContent.profiles.removeAt(index);
                  _saveProfiles(); // Save profiles after deleting profile
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.orangeAccent,
      title: const Text('Profile'),
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Colors.black,
      ),
    ),
    endDrawer: const AppDrawer(),
    body: ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final Profile item = ProfileContent.profiles.removeAt(oldIndex);
          ProfileContent.profiles.insert(newIndex, item);
          _saveProfiles(); // Save profiles after reordering
        });
      },
      children: <Widget>[
        for (int index = 0; index < ProfileContent.profiles.length; index++)
          Padding(
            key: Key(ProfileContent.profiles[index].id),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  // Deselect the profile if it is already selected
                  if (ProfileContent.selectedProfile == ProfileContent.profiles[index]) {
                    ProfileContent.selectedProfile!.deselect();
                    ProfileContent.selectedProfile = null;
                  } else {
                    // Deselect the previously selected profile
                    if (ProfileContent.selectedProfile != null) {
                      ProfileContent.selectedProfile!.deselect();
                    }

                    // Select the tapped profile
                    ProfileContent.selectedProfile = ProfileContent.profiles[index];
                    ProfileContent.selectedProfile!.select();
                  }

                  _saveProfiles(); // Save profiles after selecting or deselecting a profile
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ProfileContent.selectedProfile?.id == ProfileContent.profiles[index].id
                      ? Colors.orangeAccent
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(
                    ProfileContent.profiles[index].name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteProfileDialog(index),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
    floatingActionButton: Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
      child: FloatingActionButton(
        onPressed: _showAddProfileDialog,
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}


  @override
  void dispose() {
    _profileNameController.dispose();
    super.dispose();
  }
}
