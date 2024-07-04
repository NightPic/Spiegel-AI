import 'package:flutter/material.dart';
import 'package:remote_app/services/profile_service.dart';
import 'package:remote_app/shared/drawer.dart';
import 'profile.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  ProfileContentState createState() => ProfileContentState();
}

class ProfileContentState extends State<ProfileContent> {
  final TextEditingController _profileNameController = TextEditingController();
  String? _errorMessage;
  List<Profile> profiles = [];
  Profile? selectedProfile;
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final List<Profile> loadedProfiles = await _profileService.loadProfiles();
      setState(() {
        profiles = loadedProfiles;

        // Find the selected profile and ensure only one is selected
        selectedProfile = profiles.firstWhere(
          (profile) => profile.isSelected,
          orElse: () => Profile(id: '', name: ''),
        );

        // Deselect all profiles first
        for (var profile in profiles) {
          profile.deselect();
        }

        // Select the loaded selected profile, if any
        selectedProfile = profiles.firstWhere(
          (profile) => profile.id == selectedProfile!.id,
          orElse: () => Profile(id: '', name: ''),
        );
        if (selectedProfile != null) {
          selectedProfile!.select();
        }
      });
    } catch (e) {
      print('Error loading profiles from file: $e');
    }
  }

  Future<void> _saveProfiles() async {
    try {
      await _profileService.saveProfiles(profiles);
    } catch (e) {
      print('Error saving profiles to file: $e');
    }
  }

  void _showAddProfileDialog() {
    _profileNameController.clear();
    _errorMessage = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profil hinzufügen'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
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
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                _profileNameController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Bestätigen'),
              onPressed: () {
                if (_profileNameController.text.isNotEmpty) {
                  if (profiles.any((profile) =>
                      profile.name == _profileNameController.text)) {
                    setState(() {
                      _errorMessage = 'Dieser Name ist bereits vergeben.';
                    });
                  } else {
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    Profile newProfile =
                        Profile(id: id, name: _profileNameController.text);

                    setState(() {
                      profiles.add(newProfile);
                      if (selectedProfile != null) {
                        selectedProfile!.deselect();
                      }
                      selectedProfile = newProfile;
                      newProfile.select();
                      newProfile.selectedWidgetIds =
                          List.generate(8, (index) => index);
                      newProfile.state ??= [];
                      for (var i = 0; i < 9; i++) {
                        newProfile.state!.add({
                          'index': i,
                          'id': i,
                          'enabled': true,
                        });
                      }
                      _errorMessage = null;
                    });

                    _saveProfiles();
                    _profileNameController.clear();
                    Navigator.of(context).pop();
                  }
                } else {
                  setState(() {
                    _errorMessage = 'Name darf nicht leer sein.';
                  });
                }
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
          title: Text('Profil ${profiles[index].name} wirklich löschen?'),
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
                  if (profiles[index].isSelected) {
                    selectedProfile = null;
                  }
                  profiles.removeAt(index);
                });
                _saveProfiles();
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
            final Profile item = profiles.removeAt(oldIndex);
            profiles.insert(newIndex, item);
          });
          _saveProfiles();
        },
        children: <Widget>[
          for (int index = 0; index < profiles.length; index++)
            Padding(
              key: Key(profiles[index].id),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedProfile == profiles[index]) {
                      selectedProfile!.deselect();
                      selectedProfile = null;
                    } else {
                      if (selectedProfile != null) {
                        selectedProfile!.deselect();
                      }

                      selectedProfile = profiles[index];
                      selectedProfile!.select();
                    }
                  });
                  _saveProfiles();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedProfile?.id == profiles[index].id
                        ? Colors.orangeAccent
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      profiles[index].name,
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
