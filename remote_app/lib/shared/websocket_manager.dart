import 'dart:convert';
import 'package:remote_app/modules/profile/profile.dart';
import 'package:remote_app/services/profile_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  late WebSocketChannel channel;
  Function(String)? onMessageReceived;
  bool _isInitialized = false;

  factory WebSocketManager() {
    return _instance;
  }

  WebSocketManager._internal();

  Future<void> initialize(Function(String) onMessageReceived) async {
    if (_isInitialized) return;

    this.onMessageReceived = onMessageReceived;
    try {
      print("websocket opened");
      channel = IOWebSocketChannel.connect(
        Uri.parse('ws://192.168.178.42:8000'),
      );

      // Listen for incoming messages
      channel.stream.listen((message) {
        if (message == 'fetch') return;
        if (message is String && this.onMessageReceived != null) {
          Map<String, dynamic> messageM = jsonDecode(message);
          if (messageM['sender'] == 'mirror') {
            List<Profile> profiles = (messageM['profiles'] as List<dynamic>)
                .map((profileJson) =>
                    Profile.fromJson(profileJson as Map<String, dynamic>))
                .toList();
            ProfileService().saveProfiles(profiles);
            // Refresh current view
            this.onMessageReceived!(message);
          }
        } else {
          print('Received a non-string message: $message');
        }
      });
      sendMessage('fetch');
      _isInitialized = true;
    } catch (e) {
      print('WebSocket initialization error: $e');
      rethrow;
    }
  }

  void sendMessage(String message) {
    try {
      channel.sink.add(message);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void dispose() {
    try {
      channel.sink.close();
      _isInitialized = false;
      print("websocket closed");
    } catch (e) {
      print('Error closing WebSocket channel: $e');
    }
  }
}
