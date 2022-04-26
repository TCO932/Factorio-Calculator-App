import 'package:flutter/material.dart';
import 'dart:io';
import 'classes/myHttpOverrides.dart';
import 'pages/itemListPage.dart';
import 'pages/itemCraftPage.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
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
        '/itemList': (context) =>
            const ItemListPage(title: 'Factorio Calculator'),
        // '/itemCraft': (context) => const ItemCraftPage(title: 'Craft', itemName: '',),
      },
    );
  }
}
