import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class JSONFile {
  File jsonFile = File("todo-app-data.json");

  Future<void> save(String data) async {
    jsonFile.writeAsString(data);
  }

  void saveSync(String data) {
    jsonFile.writeAsStringSync(data);
  }

  Future<String> read() async {
    return jsonFile.readAsString();
  }

  String readSync() {
    return jsonFile.readAsStringSync();
  }

  Future<bool> exists() async {
    return jsonFile.exists();
  }

  bool existsSync() {
    return jsonFile.existsSync();
  }
}
