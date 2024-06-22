import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'profile.dart';

class FileOperations {
  static Future<List<Profile>> loadProfiles() async {
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

  static Future<void> saveProfiles(List<Profile> profiles) async {
    try {
      final jsonString =
          json.encode(profiles.map((profile) => profile.toJson()).toList());
      final file = await _localFile;
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving profiles to file: $e');
    }
  }

  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/profiles.json');
  }
}
