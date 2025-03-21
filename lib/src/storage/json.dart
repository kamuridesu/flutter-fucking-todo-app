import "package:my_todo_app/globals.dart";

class Storage {
  String key = "todo-app-data";

  Future<void> save(String data) async {
    await App.localStorage.setString(key, data);
  }

  String read() {
    var data = App.localStorage.getString(key);
    if (data == null) {
      throw Exception("Stored data not found!");
    }
    return data;
  }

  bool exists() {
    return App.localStorage.getKeys().contains(key);
  }
}
