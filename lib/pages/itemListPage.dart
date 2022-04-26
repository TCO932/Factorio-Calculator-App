import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../classes/item.dart';
import '../widgets/itemCard.dart';

Future<List<Item>> fetchItemList() async {
  final response = await http
      .get(Uri.parse('https://factorio.vasyapupkin8.repl.co/recipes'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Item.itemListFromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load items');
  }
}

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  late Future<List<Item>> futureItemList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureItemList = fetchItemList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: futureItemList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Item> itemList = snapshot.data;
            return ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemCard(
                  item: itemList[index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
