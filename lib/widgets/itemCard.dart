import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/item.dart';
import '../pages/itemCraftPage.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  ItemCraftPage(title: 'Craft', itemName: item.name))),
      child: Card(
        child: Row(
          children: [
            Image.asset('images/' + item.name + '.png'),
            const SizedBox(
              width: 5,
            ),
            Text(item.name)
          ],
        ),
      ),
    );
  }
}
