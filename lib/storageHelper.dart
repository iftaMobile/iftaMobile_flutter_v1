
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'appState.dart';

class StorageHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/app_state.json');
  }

  static Future<void> saveCounter() async {
    final file = await _localFile;
    final data = {'sharedCounter': AppState().sharedCounter};
    await file.writeAsString(jsonEncode(data));
  }

  static Future<void> loadCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final data = jsonDecode(contents);
      AppState().sharedCounter = data['sharedCounter'] ?? 0;
    } catch (e) {
      AppState().sharedCounter = 0;
    }
  }
}
