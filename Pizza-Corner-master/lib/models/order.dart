class Order {
  final int id;
  final String name;
  final String address;
  final String phone;
  final double total;
  final String date;

  Order({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.total,
    required this.date,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      name: map['customer_name'],
      address: map['address'],
      phone: map['phone'],
      total: map['total_amount'],
      date: map['order_date'],
    );
  }
}
