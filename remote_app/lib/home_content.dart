import 'dart:convert';

import 'package:flutter/material.dart';
import 'web_socket_manager.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late List<int> _buttonIndexes;
  late List<String> _buttonLabels;
  late List<bool> _buttonClicked;
  late WebSocketManager _webSocketManager;

  @override
  void initState() {
    super.initState();
    _buttonIndexes = List.generate(9, (index) => index);
    _buttonLabels = [
      'Kalender',
      'Uhr',
      'Wetter',
      'Notizen',
      'Name des Profils',
      'Termine',
      'Verkehr',
      'Nachrichten',
      'Tanken'
    ];
    _buttonClicked = List.generate(9, (index) => false);

    _webSocketManager = WebSocketManager(_handleMessage);
    _webSocketManager.initialize();
  }

  void _handleMessage(String message) {
    print('Received: $message');
    if (message.startsWith('swap')) {
      List<String> parts = message.split(' ');
      int oldIndex = int.parse(parts[1]);
      int newIndex = int.parse(parts[2]);
      _swapWidgets(oldIndex, newIndex);
    } else if (message.startsWith('disable')) {
      int index = int.parse(message.split(' ')[1]);
      _disableWidget(index, true);
    } else if (message.startsWith('enable')) {
      int index = int.parse(message.split(' ')[1]);
      _disableWidget(index, false);
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
    _webSocketManager.sendMessage(jsonEncode({
      'action': 'swap',
      'old_index': oldIndex,
      'new_index': newIndex,
    }));
  }

  void _disableWidget(int index, bool disable) {
    setState(() {
      _buttonClicked[index] = disable;
    });
    _webSocketManager.sendMessage(jsonEncode({
      'action': disable ? 'disable' : 'enable',
      'index': index,
    }));
  }

  @override
  void dispose() {
    _webSocketManager.dispose();
    super.dispose();
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
      ),
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
                  child: const Text(
                    'Name des Profils',
                    style: TextStyle(
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
          setState(() {
            _buttonClicked[index] = !_buttonClicked[index];
          });
          _disableWidget(index, _buttonClicked[index]);
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
          _buttonLabels[_buttonIndexes[index]],
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
