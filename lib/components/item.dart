import 'package:flutter/material.dart';

class ItemBuilder {
  String? __name;
  bool? __isFinished;
  DateTime? __createdAt;
  DateTime? __finishedAt;

  ItemBuilder setName(String name) {
    __name = name;
    return this;
  }

  ItemBuilder setIsFinished(bool? isFinished) {
    __isFinished = isFinished;
    return this;
  }

  ItemBuilder setCreatedAt(DateTime createdAt) {
    __createdAt = createdAt;
    return this;
  }

  ItemBuilder setFinishedAt(DateTime? finishedAt) {
    __finishedAt = finishedAt;
    return this;
  }

  Item build() {
    if (__name == null && __createdAt == null) {
      throw ErrorDescription("Invalid Item! Missing name and/or creation date");
    }
    var i = Item(name: __name!, createdAt: __createdAt!);
    i.finishedAt = __finishedAt;
    i.isFinished = __isFinished == null ? false : (__isFinished as bool);
    return i;
  }
}

class Item {
  String name;
  bool isFinished = false;
  DateTime createdAt;
  DateTime? finishedAt;

  Item({required this.name, required this.createdAt});

  factory Item.fromJson(Map<String, dynamic> data) {
    return ItemBuilder()
        .setName(data["name"])
        .setCreatedAt(DateTime.parse(data["createdAt"]))
        .setIsFinished(data["isFinished"])
        .setFinishedAt(
          data["finishedAt"] != null
              ? DateTime.parse(data["finishedAt"])
              : null,
        )
        .build();
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "isFinished": isFinished,
      "createdAt": createdAt.toIso8601String(),
      "finishedAt": finishedAt?.toIso8601String(),
    };
  }

  bool isValid() {
    return name != "";
  }

  ListTile build(VoidCallback onTap, VoidCallback? onLongPress) {
    return ListTile(
      leading: Icon(isFinished ? Icons.circle : Icons.circle_outlined),
      title: Text(
        name,
        style: TextStyle(
          color: Colors.black,
          decoration: isFinished ? TextDecoration.lineThrough : null,
        ),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
