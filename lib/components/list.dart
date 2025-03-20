import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_todo_app/components/item.dart';
import 'package:my_todo_app/components/snack.dart';
import 'package:my_todo_app/storage/json.dart';


class ItemList extends StatefulWidget {
  final List<Item> items;
  static final JSONFile json = JSONFile();

  const ItemList({super.key, required this.items});

  @override
  State<ItemList> createState() => _ItemListState();

  static ItemList load() {
    if (!json.existsSync()) {
      return ItemList(items: []);
    }
    var input = json.readSync();
    List<dynamic> data = jsonDecode(input);
    return ItemList(items: data.map((e) => Item.fromJson(e)).toList());
  }

  void add(Item item) {
    items.add(item);
    save();
  }
  
  void remove(Item item) {
    items.remove(item);
    save();
  }

  Future<void> save() async {
    var jsonItems = items.map((e) => e.toJson()).toList();
    var data = jsonEncode(jsonItems);
    await json.save(data);
  }
}

class _ItemListState extends State<ItemList> {

  late List<Item> items;

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  Future<void> toggleItemStatus(int index) async {
    var item = items[index];
    setState(() {
      item.isFinished = !item.isFinished;
      item.finishedAt = item.isFinished ? DateTime.now() : null;
    });
    if (context.mounted) {
      showSnackBar(context, "Item ${item.name} marked as ${item.isFinished ? "done" : "undone"}!");
    }
    await widget.save();
  }

  Future<void> editItemDialog(int index) async {
    var item = items[index];

    final TextEditingController controller = TextEditingController(text: item.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Item"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Item Name"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  widget.remove(item);
                });
                Navigator.of(context).pop();
                showSnackBar(context, "Item ${item.name} deleted!");
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  item.name = controller.text;
                });
                Navigator.of(context).pop();
                await widget.save();
                if (context.mounted) {
                  showSnackBar(context, "Item ${item.name} Saved!");
                }
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index].build(
          () => toggleItemStatus(index),
          () => editItemDialog(index),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

}
