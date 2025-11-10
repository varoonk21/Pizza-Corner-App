import 'package:cloud_firestore/cloud_firestore.dart';

class Topping {
  final String name;
  final double price;

  Topping({required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price};
  }

  factory Topping.fromMap(Map<String, dynamic> map) {
    return Topping(
      name: map['name']?.toString() ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price; // Base price
  final String category;
  final String imageUrl;
  final bool available;
  final List<String> sizes; // e.g., ["Small", "Medium", "Large"]
  final List<Topping> toppings; // Available toppings

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.available,
    this.sizes = const [],
    this.toppings = const [],
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Product document has no data');
    }

    // Parse sizes
    List<String> sizesList = [];
    if (data['sizes'] != null) {
      sizesList = (data['sizes'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    }

    // Parse toppings
    List<Topping> toppingsList = [];
    if (data['toppings'] != null) {
      toppingsList = (data['toppings'] as List<dynamic>)
          .map((e) {
            if (e is Map) {
              return Topping.fromMap(Map<String, dynamic>.from(e));
            }
            return null;
          })
          .whereType<Topping>()
          .toList();
    }

    return ProductModel(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      price: _parseDouble(data['price']),
      category: data['category']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      available: data['available'] == true,
      sizes: sizesList,
      toppings: toppingsList,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'available': available,
      'sizes': sizes,
      'toppings': toppings.map((t) => t.toMap()).toList(),
    };
  }
}

