import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote_app/drawer.dart';
import 'package:reorderables/reorderables.dart';

class WidgetsContent extends StatefulWidget {
  const WidgetsContent({super.key});

  @override
  State<WidgetsContent> createState() => _WidgetsContentState();
}

class _WidgetsContentState extends State<WidgetsContent> {
  late List<Widget> _items;

  @override
  void initState() {
    super.initState();
    _setLandscapeOrientation();
    _items = List<Widget>.generate(9, (index) {
      return _buildGridItem(index);
    });
  }

  Widget _buildGridItem(int index) {
    return Card(
      key: ValueKey(index),
      color: Colors.amber,
      child: InkWell(
        onTap: () {
          // Handle the tap event here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item $index clicked')),
          );
        },
        child: Center(
          child: Text('Item $index'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _resetOrientation();
    super.dispose();
  }

  void _setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 212, 230, 25),
        title: const Text('Widgets'),
      ),
      endDrawer: const AppDrawer(),
      body: ReorderableWrap(
        needsLongPressDraggable: false,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },
        children: _items,
      ),
    );
  }
}
