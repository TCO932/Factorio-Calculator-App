class Item {
  final String name;
  final double productionTime;
  final int quantity;
  final Map<String, dynamic> recipe;

  // ????
  Item(
      {required this.name,
      required this.productionTime,
      required this.quantity,
      required this.recipe});

  static List<Item> itemListFromJson(Map<String, dynamic> json) {
    List<Item> itemList = [];
    for (String key in json.keys) {
      print(key);
      itemList.add(Item(
          name: key,
          productionTime: json[key]["production_time"].toDouble(),
          quantity: json[key]["quantity"],
          recipe: json[key]["recipe"]));
    }
    return itemList;
  }
}
