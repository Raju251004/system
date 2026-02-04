enum ItemType { BADGE, CONSUMABLE, EQUIPMENT }

class Item {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final String iconPath; // Asset path or IconData name
  final int quantity;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.iconPath,
    this.quantity = 1,
  });
}
