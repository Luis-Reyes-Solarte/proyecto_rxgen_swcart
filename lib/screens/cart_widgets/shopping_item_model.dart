class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final String unit;
  bool isDone;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'isDone': isDone,
    };
  }

  factory ShoppingItem.fromMap(Map<dynamic, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: (map['quantity'] as num).toInt(),
      unit: map['unit'] as String,
      isDone: map['isDone'] as bool? ?? false,
    );
  }
}
