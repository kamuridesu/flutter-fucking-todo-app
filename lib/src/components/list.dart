import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_todo_app/src/components/buttons.dart';
import 'package:my_todo_app/src/components/item.dart';
import 'package:my_todo_app/src/components/snack.dart';
import 'package:my_todo_app/src/storage/json.dart';

class ItemList extends StatefulWidget {
  final List<Item> items;
  static final Storage storage = Storage();

  const ItemList({super.key, required this.items});

  @override
  State<ItemList> createState() => _ItemListState();

  static ItemList load() {
    if (!storage.exists()) {
      return ItemList(items: []);
    }
    List<dynamic> data = jsonDecode(storage.read());
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
    await storage.save(data);
  }
}

class _ItemListState extends State<ItemList> {
  late List<Item> items;
  var showCompletedOnly = false;
  var searchTerm = "";

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  Future<void> toggleItemStatus(Item item) async {
    setState(() {
      item.isFinished = !item.isFinished;
      item.finishedAt = item.isFinished ? DateTime.now() : null;
    });
    if (context.mounted) {
      showSnackBar(
        context,
        "'${item.name}' marked as ${item.isFinished ? "done" : "undone"}!",
      );
    }
    await widget.save();
  }

  Future<void> editItemDialog(Item item) async {
    final TextEditingController controller = TextEditingController(
      text: item.name,
    );

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
                showSnackBar(context, "'${item.name}' deleted!");
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
            saveButton(context, () async {
              setState(() {
                item.name = controller.text;
              });
              Navigator.of(context).pop();
              await widget.save();
              if (context.mounted) {
                showSnackBar(context, "'${item.name}' Saved!");
              }
            }),
            cancelButton(context),
          ],
        );
      },
    );
  }

  List<Item> filter() {
    var localItems =
        (showCompletedOnly ? items.where((s) => s.isFinished).toList() : items);
    localItems =
        (searchTerm != ""
            ? localItems.where((s) => s.name.contains(searchTerm)).toList()
            : localItems);
    return localItems;
  }

  @override
  Widget build(BuildContext context) {
    var localItems = filter();
    var list = ListView.separated(
      itemCount: localItems.length,
      itemBuilder: (context, index) {
        return localItems[index].build(
          () => toggleItemStatus(localItems[index]),
          () => editItemDialog(localItems[index]),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
    var row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 20,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(),
          child: Row(
            children: [
              Tooltip(
                message: "Show completed only",
                child: Switch(
                  value: showCompletedOnly,
                  onChanged: ((value) {
                    setState(() {
                      showCompletedOnly = value;
                    });
                  }),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            decoration: InputDecoration(
              labelText: "Search",
              suffixIcon: Icon(Icons.search),
            ),
            autofocus: true,
            onChanged: (value) {
              setState(() {
                searchTerm = value;
              });
            },
          ),
        ),
      ],
    );
    // final searchController = TextEditingController();
    return Column(children: [row, Expanded(child: list)]);
  }
}
