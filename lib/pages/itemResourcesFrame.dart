import 'package:factorio_calculator/classes/protoItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import '../widgets/itemCard.dart';

class ItemResourcesFrame extends StatelessWidget {
  const ItemResourcesFrame({Key? key, required this.itemName})
      : super(key: key);
  final String itemName;

  @override
  Widget build(BuildContext context) {
    Future<List<ProtoItem>> futureItemList = fetchCraftResources(itemName);
    return FutureBuilder(
      future: futureItemList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<ProtoItem> itemList = snapshot.data;
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
    );
  }
}
