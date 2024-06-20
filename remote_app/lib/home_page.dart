import 'package:flutter/material.dart';
import 'package:remote_app/home_content.dart';
import 'package:remote_app/widgets_content.dart';
import 'package:remote_app/profile_content.dart';
import 'package:remote_app/websocket_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final WebSocketManager _webSocketManager = WebSocketManager();

  @override
  void initState() {
    super.initState();
    _webSocketManager.initialize(_onMessageReceived);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _webSocketManager.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onMessageReceived(String message) {
    // Handle incoming messages if needed (profiles later on)
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _webSocketManager.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _webSocketManager.initialize(_onMessageReceived);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      HomeContent(webSocketManager: _webSocketManager),
      WidgetsContent(webSocketManager: _webSocketManager),
      ProfileContent(webSocketManager: _webSocketManager),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.orangeAccent,
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.connected_tv_rounded),
            label: 'Remote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Widgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
