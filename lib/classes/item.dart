import 'package:factorio_calculator/classes/protoItem.dart';

class Item extends ProtoItem {
  final double productionTime;
  final Map<String, dynamic> recipe;
  final String image;

  // ????
  const Item({
    name,
    quantity,
    elementary,
    required this.productionTime,
    required this.recipe,
    required this.image,
  }) : super(name: name, quantity: quantity, elementary: elementary);

  static List<Item> listFromJson(Map<String, dynamic> json) {
    List<Item> itemList = [];
    for (String key in json.keys) {
      itemList.add(Item(
        name: key,
        productionTime: json[key]["production_time"].toDouble(),
        quantity: json[key]["quantity"],
        elementary: json[key]["elementary"],
        recipe: json[key]["recipe"],
        image: json[key]["image"],
      ));
    }
    return itemList;
  }
}
