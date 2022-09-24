import 'package:factorio_calculator/utils.dart';
import 'package:flutter/material.dart';

import '../classes/protoItem.dart';
import '../pages/itemCraft.dart';

class ItemCard extends StatelessWidget {
  final ProtoItem item;
  final num? amAmount;

  const ItemCard({Key? key, required this.item, this.amAmount})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if (!item.elementary)
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ItemCraft(title: 'Craft', itemName: item.name),
              ),
            )
          }
      },
      child: Card(
        child: Row(
          children: [
            Image.asset('images/' + item.name + '.png'),
            const SizedBox(
              width: 5,
            ),
            Text(prettify(item.name)),
            const Spacer(),
            Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'x'),
                      TextSpan(
                          text: cutZeros(item.quantity),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                if (amAmount != null)
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'x'),
                        TextSpan(
                          text: cutZeros(amAmount!),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: 'ams'),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }
}
