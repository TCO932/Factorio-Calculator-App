import 'package:flutter/material.dart';

import 'pages/itemsList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Factorio Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/itemList',
      routes: {
        '/itemList': (context) => const ItemsList(title: 'Factorio Calculator'),
        // '/itemCraft': (context) => const ItemCraft(title: 'Craft', itemName: itemName),
        // '/itemResources': (context) => const ItemResources(title: 'Resources'),
        // '/itemDetailedCraft': (context) =>
        //     const ItemDetailedCraft(title: 'Detailed Craft'),
        // '/itemCraft': (context) => const ItemCraftPage(
        //       title: 'Craft',
        //       itemName: '',
        //     ),
      },
    );
  }
}
