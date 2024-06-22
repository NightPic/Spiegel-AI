import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:remote_app/modules/profile/profile.dart';
import 'package:remote_app/services/profile_service.dart';
import 'package:remote_app/shared/drawer.dart';
import 'package:remote_app/shared/websocket_manager.dart';

class RemoteContent extends StatefulWidget {
  final WebSocketManager webSocketManager;

  const RemoteContent({required this.webSocketManager, super.key});

  @override
  RemoteContentState createState() => RemoteContentState();
}

class RemoteContentState extends State<RemoteContent> {
  late List<int> _buttonIndexes;
  late List<int> _buttonLabels;
  late List<bool> _buttonClicked;
  String _selectedProfileName = '';
  Profile? _selectedProfile;
  List<Profile> profiles = [];
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _buttonIndexes = List.generate(9, (index) => index);
    _buttonLabels = [0, 1, 2, 3, 4, 5, 6, 7, 8];
    _buttonClicked = List.generate(9, (index) => false);
    _loadSelectedProfileName();
  }

  Future<void> _loadSelectedProfileName() async {
    profiles = await _profileService.loadProfiles();
    final selectedProfile = profiles.firstWhere((profile) => profile.isSelected,
        orElse: () => Profile(id: '', name: ''));

    setState(() {
      _selectedProfileName = selectedProfile.name;
      _selectedProfile = selectedProfile.name.isEmpty ? null : selectedProfile;

      if (_selectedProfile != null &&
          _selectedProfile!.selectedRemoteContent != null) {
        _buttonIndexes = _selectedProfile!.selectedRemoteContent!
            .map<int>((item) => item['index'])
            .toList();
        _buttonLabels = _selectedProfile!.selectedRemoteContent!
            .map<int>((item) => item['id'])
            .toList();
        _buttonClicked = _selectedProfile!.selectedRemoteContent!
            .map<bool>((item) => !item['enabled'])
            .toList();
      }
    });

    _sendState();
  }

  Future<void> _sendState() async {
    List<Map<String, dynamic>> state = [];
    for (int i = 0; i < _buttonIndexes.length; i++) {
      state.add({
        'index': i,
        'id': _buttonLabels[_buttonIndexes[i]],
        'enabled': !_buttonClicked[i],
      });
    }

    widget.webSocketManager
        .sendMessage(jsonEncode({'action': 'update_state', 'state': state}));

    if (_selectedProfile != null) {
      _selectedProfile!.selectedRemoteContent = state;
      await _profileService.saveProfiles(profiles);
    }
  }

  void _swapWidgets(int oldIndex, int newIndex) {
    setState(() {
      final temp = _buttonIndexes[oldIndex];
      _buttonIndexes[oldIndex] = _buttonIndexes[newIndex];
      _buttonIndexes[newIndex] = temp;

      final tempClicked = _buttonClicked[oldIndex];
      _buttonClicked[oldIndex] = _buttonClicked[newIndex];
      _buttonClicked[newIndex] = tempClicked;
    });

    _sendState();
  }

  void _disableWidget(int index, bool disable) {
    setState(() {
      _buttonClicked[index] = disable;
    });

    _sendState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const appBarHeight = kToolbarHeight;
    final totalVerticalPadding = 32.0 + statusBarHeight + appBarHeight;

    final buttonHeight = (screenSize.height - totalVerticalPadding) / 3;
    final buttonWidth = screenSize.width / 3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Spiegel AI Remote'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black,
        ),
      ),
      endDrawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: buttonWidth / buttonHeight,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            if (index == 4) {
              return SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                    ),
                  ),
                  child: Text(
                    _selectedProfileName.isEmpty
                        ? 'Kein Profil geladen'
                        : _selectedProfileName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return DragTarget<int>(
              builder: (context, candidateData, rejectedData) {
                return Draggable<int>(
                  data: _buttonIndexes[index],
                  feedback: _buildButton(index, buttonWidth, buttonHeight),
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    // Handle drag end here if needed
                  },
                  child: _buildButton(index, buttonWidth, buttonHeight),
                );
              },
              onWillAcceptWithDetails: (data) => true,
              onAcceptWithDetails: (details) {
                final oldIndex = _buttonIndexes.indexOf(details.data);
                final newIndex = index;
                if (oldIndex != newIndex) {
                  _swapWidgets(oldIndex, newIndex);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildButton(int index, double buttonWidth, double buttonHeight) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          _disableWidget(
              index, !_buttonClicked[index]); // Toggle the clicked state
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonClicked[index]
              ? Colors.grey.withOpacity(0.5)
              : Colors.orangeAccent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(
              color: Colors.orangeAccent,
              width: 1.0,
            ),
          ),
        ),
        child: Text(
          _buttonLabels[_buttonIndexes[index]].toString(),
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
