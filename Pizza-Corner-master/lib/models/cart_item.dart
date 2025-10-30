class CartItem {
  final int id;
  final int pizzaId;
  final String size;
  final int quantity;
  final double totalPrice;

  CartItem({
    required this.id,
    required this.pizzaId,
    required this.size,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      pizzaId: map['pizza_id'],
      size: map['size'],
      quantity: map['quantity'],
      totalPrice: map['total_price'],
    );
  }
}
