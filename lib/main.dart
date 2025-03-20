import 'package:flutter/material.dart';
import "package:my_todo_app/components/item.dart";
import "package:my_todo_app/components/snack.dart";
import "consts/consts.dart" as consts;
import "components/list.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: consts.myTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ItemList itemList;

  @override
  void initState() {
    super.initState();
    itemList = ItemList.load();
  }

  void _addItem(Item item) {
    setState(() {
      itemList.add(item);
      itemList = ItemList(items: itemList.items);
    });
  }


  // void buildItemList() {
  //   setState(() {
  //     itemList.build();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: itemList.items.isEmpty ? Center(child: Text("Create new item"),) : itemList,
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add New Item"),
                content: TextField(
                  controller: textController,
                  decoration: InputDecoration(labelText: "Item Name"),
                  autofocus: true,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      var item = ItemBuilder()
                      .setName(textController.text)
                      .setIsFinished(false)
                      .setCreatedAt(DateTime.now())
                      .build();
                      if (!item.isValid()) {
                        showSnackBar(context, "Invalid name!");
                        return Navigator.of(context).pop();  
                      }
                      _addItem(item);
                      Navigator.of(context).pop();
                      showSnackBar(context, "Item ${item.name} saved!");
                    },
                    child: Text("Save"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel")
                  ),
                ],
              );
            }
          );
        },
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
