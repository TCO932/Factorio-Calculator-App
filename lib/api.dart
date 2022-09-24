import 'dart:convert';

import 'package:factorio_calculator/classes/protoItem.dart';
import 'package:http/http.dart' as http;

import 'classes/item.dart';

const route = 'https://factorio.vasyapupkin8.repl.co';
const imgRoute = 'https://factorio.vasyapupkin8.repl.co';

Future<Map<String, dynamic>> fetchDetailedCraft(String itemName, double speed,
    String assemblingMachine, bool productivity) async {
  final response = await http.get(Uri.parse(route +
      '/detailedCraft?item=$itemName&speed=$speed&assembling_machine=$assemblingMachine&productivity=$productivity'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to detailed craft');
  }
}

Future<Map<String, dynamic>> fetchCraftTree(String itemName, double speed,
    String assemblingMachine, bool productivity) async {
  final response = await http.get(Uri.parse(route +
      '/craftTree?item=$itemName&speed=$speed&assembling_machine=$assemblingMachine&productivity=$productivity'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to detailed craft');
  }
}

Future<List<Item>> fetchItemList() async {
  final response = await http.get(Uri.parse(route + '/recipes'));

  if (response.statusCode == 200) {
    return Item.listFromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load items');
  }
}

Future<List<ProtoItem>> fetchCraftResources(String itemName) async {
  final response =
      await http.get(Uri.parse(route + '/resources?item=$itemName'));

  if (response.statusCode == 200) {
    List<ProtoItem> craftResources = [];
    //todo: fix
    Map<String, double>.from(jsonDecode(response.body)).forEach((key, value) {
      craftResources
          .add(ProtoItem(name: key, quantity: value, elementary: false));
    });
    return craftResources;
  } else {
    throw Exception('Failed to load craft resources');
  }
}

Future<Map<String, dynamic>> fetchAssemblingMachines() async {
  final response = await http.get(Uri.parse(route + '/assemblingMachines'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load assembling machines');
  }
}
