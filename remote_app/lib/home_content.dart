import 'package:flutter/material.dart';
import 'package:remote_app/drawer.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late List<int> _buttonIndexes;
  final List<String> _buttonLabels = List.generate(9, (index) => 'Widget ${index + 1}');
  final List<bool> _buttonClicked = List.generate(9, (index) => false);

  @override
  void initState() {
    super.initState();
    _buttonIndexes = List.generate(9, (index) => index);
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
            return DragTarget<int>(
              builder: (context, candidateData, rejectedData) {
                return Draggable<int>(
                  data: _buttonIndexes[index],
                  feedback: _buildButton(index, buttonWidth, buttonHeight),
                  childWhenDragging: Container(),
                  child: _buildButton(index, buttonWidth, buttonHeight),
                );
              },
              onWillAcceptWithDetails: (data) => true,
              onAcceptWithDetails: (details) {
                final oldIndex = _buttonIndexes.indexOf(details.data);
                final newIndex = index;
                if (oldIndex != newIndex) {
                  setState(() {
                    final temp = _buttonIndexes[oldIndex];
                    _buttonIndexes[oldIndex] = _buttonIndexes[newIndex];
                    _buttonIndexes[newIndex] = temp;
                  });
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
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonClicked[index] ? Colors.grey.withOpacity(0.5) : Colors.orangeAccent, // Change color when clicked
          foregroundColor: Colors.black, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(
              color: Colors.orangeAccent, // Border color
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
