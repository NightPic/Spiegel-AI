import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:remote_app/modules/profile/profile.dart';

class ProfileService {
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
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);

      final updatedJsonList = jsonList.map((json) {
        final profile = Profile.fromJson(json);
        final updatedProfile = profiles.firstWhere((p) => p.id == profile.id,
            orElse: () => profile);
        return updatedProfile.toJson();
      }).toList();

      await file.writeAsString(json.encode(updatedJsonList));
    } catch (e) {
      print('Error saving profiles to file: $e');
    }
  }
}
