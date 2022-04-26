import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../classes/item.dart';

class ItemCraftPage extends StatefulWidget {
  final String title;
  final String itemName;

  const ItemCraftPage({Key? key, required this.title, required this.itemName})
      : super(key: key);

  @override
  State<ItemCraftPage> createState() => _ItemCraftPageState();

  Future<List<Map<String, double>>> fetchItemResources() async {
    final response = await http.get(Uri.parse(
        'https://factorio.vasyapupkin8.repl.co/resources?' + itemName));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Map<String, double>> resources = [];
      Map<String, dynamic> json = jsonDecode(response.body);
      json.forEach((key, value) {
        resources.add({key: value});
      });
      return resources;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load resources');
    }
  }
}

class _ItemCraftPageState extends State<ItemCraftPage> {
  late Future<List<Map<String, double>>> ItemResources;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ItemResources = widget.fetchItemResources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder(
        future: ItemResources,
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
    );
  }
}
