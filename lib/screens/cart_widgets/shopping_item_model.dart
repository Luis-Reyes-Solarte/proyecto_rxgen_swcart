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
}
