import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  late WebSocketChannel channel;
  final Function(String) onMessageReceived;

  WebSocketManager(this.onMessageReceived);

  Future<void> initialize() async {
    try {
      // Load the self-signed certificate
      SecurityContext securityContext = await loadCertificate();

      // Create the custom HttpClient with the security context
      HttpClient client = HttpClient(context: securityContext)
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) =>
                true; // Disable hostname verification

      // Connect to WebSocket with custom HttpClient
      channel = WebSocketChannel.connect(
        Uri.parse('ws://raspberrypi.local:8000'),
      );

      // Listen for incoming messages
      channel.stream.listen((message) {
        if (message is String) {
          onMessageReceived(message);
        } else {
          print('Received a non-string message: $message');
        }
      });
    } catch (e) {
      print('WebSocket initialization error: $e');
      // Handle initialization error as needed
      rethrow; // Propagate the error further if needed
    }
  }

  Future<SecurityContext> loadCertificate() async {
    try {
      ByteData data = await rootBundle.load('certificates/cert.pem');
      SecurityContext context = SecurityContext.defaultContext;
      context.setTrustedCertificatesBytes(data.buffer.asUint8List());
      return context;
    } catch (e) {
      print('Error loading certificate: $e');
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
    } catch (e) {
      print('Error closing WebSocket channel: $e');
    }
  }
}
