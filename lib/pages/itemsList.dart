import 'package:flutter/material.dart';

import '../api.dart';
import '../classes/item.dart';
import '../widgets/itemCard.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  late Future<List<Item>> futureItemList;

  @override
  void initState() {
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
