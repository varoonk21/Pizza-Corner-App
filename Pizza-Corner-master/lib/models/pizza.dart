class Pizza {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String image;

  Pizza({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Pizza.fromMap(Map<String, dynamic> map) {
    return Pizza(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      image: map['image'],
    );
  }
}
