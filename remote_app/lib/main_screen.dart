import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:remote_app/modules/remote/remote_content.dart';
import 'package:remote_app/modules/widgets/widgets_content.dart';
import 'package:remote_app/modules/profile/profile_content.dart';
import 'package:remote_app/shared/websocket_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final WebSocketManager _webSocketManager = WebSocketManager();

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
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
      RemoteContent(webSocketManager: _webSocketManager),
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
