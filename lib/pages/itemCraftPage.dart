import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../classes/item.dart';
import '../widgets/itemCard.dart';

Future<List<Map<String, double>>> fetchDetailedCraft(String itemName,
    double speed, String assemblingMachine, bool productivity) async {
  final response = await http.get(Uri.parse(
      'https://factorio.vasyapupkin8.repl.co/detailedCraft?item=$itemName&speed=$speed&assembling_machine=$assemblingMachine&productivity=$productivity'));

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

Future<List<String>> fetchAssemblingMachines() async {
  final response = await http.get(
      Uri.parse('https://factorio.vasyapupkin8.repl.co/assemblingMachines'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<String> AssemblingMachines = [];
    Map<String, dynamic> json = jsonDecode(response.body);
    json.forEach((key, value) {
      AssemblingMachines.add(key);
    });
    return AssemblingMachines;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load resources');
  }
}

class ItemCraftPage extends StatefulWidget {
  final String title;
  final String itemName;

  const ItemCraftPage({Key? key, required this.title, required this.itemName})
      : super(key: key);

  @override
  State<ItemCraftPage> createState() => _ItemCraftPageState();
}

class _ItemCraftPageState extends State<ItemCraftPage> {
  late Future<List<Map<String, double>>> detailedCraft;
  late Future<List<String>> assemblingMachines;
  late String assemblingMachine;
  double speed = 1;
  bool productivity = false;

  @override
  void initState() {
    super.initState();
    assemblingMachines = fetchAssemblingMachines();
    // assemblingMachine = assemblingMachines[0];
    // detailedCraft = fetchDetailedCraft(speed, assemblingMachine, productivity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Settings(assemblingMachines: assemblingMachines),
          Components(detailedCraft: detailedCraft),
        ],
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
    required this.assemblingMachines,
  }) : super(key: key);

  final Future<List<String>> assemblingMachines;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: assemblingMachines,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List<String> assmMacines = snapshot.data;
          return Container();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class Components extends StatelessWidget {
  const Components({
    Key? key,
    required this.detailedCraft,
  }) : super(key: key);

  final Future<List<Map<String, double>>> detailedCraft;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: detailedCraft,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Item> components = snapshot.data['components'];
          return ListView.builder(
            itemCount: components.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemCard(
                item: components[index],
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
