class DetailedCraft {
  final String itemName;
  final bool elementary;
  final double speed;
  final double? assemblingMachinesAmount;
  final List<dynamic>? components;

  DetailedCraft({
    required this.itemName,
    required this.elementary,
    required this.speed,
    this.assemblingMachinesAmount,
    this.components,
  });

  static DetailedCraft FromJson(Map<String, dynamic> json) {
    return DetailedCraft(
      itemName: json['item_name'] ?? '',
      elementary: json['elementary'],
      speed: json['speed'],
      assemblingMachinesAmount:
          json['elementary'] ? null : json['assembling_machine_amount'],
      components: json['elementary'] ? null : json['components'],
    );
  }
}
