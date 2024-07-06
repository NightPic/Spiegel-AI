import 'package:flutter/material.dart';
import 'package:remote_app/modules/profile/profile.dart';
import 'package:remote_app/modules/widgets/widgets_content.dart';
import 'package:remote_app/services/profile_service.dart';
import 'package:remote_app/shared/drawer.dart';

class RemoteContent extends StatefulWidget {
  const RemoteContent({super.key});

  @override
  RemoteContentState createState() => RemoteContentState();
}

class RemoteContentState extends State<RemoteContent> {
  late List<int> _buttonLabels;
  late List<bool> _buttonClicked;
  late List<String> _buttonNames;
  String _selectedProfileName = '';
  Profile? _selectedProfile;
  List<Profile> profiles = [];
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _buttonLabels = List.generate(9, (index) => index);
    _buttonClicked = List.generate(9, (index) => false);
    _buttonNames = List.from(WidgetsContent.widgetNames);
    _loadSelectedProfileName();
  }

  Future<void> _loadSelectedProfileName() async {
    profiles = await _profileService.loadProfiles();
    final selectedProfile = profiles.firstWhere((profile) => profile.isSelected,
        orElse: () => Profile(id: '', name: ''));

    setState(() {
      _selectedProfileName = selectedProfile.name;
      _selectedProfile = selectedProfile.name.isEmpty ? null : selectedProfile;

      if (_selectedProfile != null && _selectedProfile!.state != null) {
        _buttonLabels =
            _selectedProfile!.state!.map<int>((item) => item['id']).toList();
        _buttonClicked = _selectedProfile!.state!
            .map<bool>((item) => !item['enabled'])
            .toList();
      } else if (_selectedProfile != null &&
          _selectedProfile!.selectedWidgetIds != null) {
        _buttonLabels = List.generate(9, (index) => -1);
        _selectedProfile!.selectedWidgetIds!.asMap().forEach((i, id) {
          if (i < 9) _buttonLabels[i] = id;
        });
      }
    });
  }

  Future<void> _sendState() async {
    List<Map<String, dynamic>> state = [];
    for (int i = 0; i < 9; i++) {
      state.add({
        'index': i,
        'id': _buttonLabels[i],
        'enabled': !_buttonClicked[i],
      });
    }

    if (_selectedProfile != null) {
      _selectedProfile!.state = state;
      await _profileService.saveProfiles(profiles);
    }
  }

  void _swapWidgets(int oldIndex, int newIndex) {
    if (_selectedProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Bitte wählen Sie zuerst ein Profil aus.')));
      return;
    }
    setState(() {
      final temp = _buttonLabels[oldIndex];
      _buttonLabels[oldIndex] = _buttonLabels[newIndex];
      _buttonLabels[newIndex] = temp;

      final tempClicked = _buttonClicked[oldIndex];
      _buttonClicked[oldIndex] = _buttonClicked[newIndex];
      _buttonClicked[newIndex] = tempClicked;
    });

    _sendState();
  }

  void _disableWidget(int index, bool disable) {
    if (_selectedProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Bitte wählen Sie zuerst ein Profil aus.')));
      return;
    }
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
                  data: index,
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
                final oldIndex = details.data;
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
          _disableWidget(index, !_buttonClicked[index]);
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
          _buttonLabels[index] == -1 ? '' : _buttonNames[_buttonLabels[index]],
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
