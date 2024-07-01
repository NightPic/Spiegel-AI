import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:remote_app/modules/profile/profile.dart';
import 'package:remote_app/shared/websocket_manager.dart';

class ProfileService {
  final WebSocketManager webSocketManager = WebSocketManager();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/profiles.json');
  }

  Future<List<Profile>> loadProfiles() async {
    try {
      final file = await _localFile;
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList.map((json) => Profile.fromJson(json)).toList();
    } catch (e) {
      print('Error loading profiles from file: $e');
      return [];
    }
  }

  Future<void> saveProfiles(List<Profile> profiles) async {
    try {
      final file = await _localFile;
      final updatedJsonList =
          profiles.map((profile) => profile.toJson()).toList();
      await file.writeAsString(json.encode(updatedJsonList));
      webSocketManager
          .sendMessage(jsonEncode({'sender': 'remote', 'profiles': profiles}));
    } catch (e) {
      print('Error saving profiles to file: $e');
    }
  }
}
