import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? size; // Optional size selection
  final List<String> toppings; // Selected toppings

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.size,
    this.toppings = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'size': size,
      'toppings': toppings,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    // Parse toppings
    List<String> toppingsList = [];
    if (map['toppings'] != null) {
      if (map['toppings'] is List) {
        toppingsList = (map['toppings'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      }
    }

    return OrderItem(
      productId: map['productId']?.toString() ?? '',
      productName: map['productName']?.toString() ?? '',
      price: _parseDouble(map['price']),
      quantity: _parseInt(map['quantity']),
      size: map['size']?.toString(),
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

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;
  final String status; // "Pending", "Preparing", "On the Way", "Delivered"
  final DateTime timestamp;
  final String deliveryAddress;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.timestamp,
    this.deliveryAddress = '',
    this.paymentMethod = 'COD',
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Order document does not exist or has no data');
    }

    // Handle items array - check if each item is a Map
    final itemsData = data['items'] as List<dynamic>?;
    final itemsList = <OrderItem>[];

    if (itemsData != null) {
      for (var item in itemsData) {
        try {
          if (item is Map<String, dynamic>) {
            itemsList.add(OrderItem.fromMap(item));
          } else if (item is Map) {
            // Convert Map<dynamic, dynamic> to Map<String, dynamic>
            final convertedMap = Map<String, dynamic>.from(item);
            itemsList.add(OrderItem.fromMap(convertedMap));
          } else if (item is String) {
            // Handle case where item might be stored as string
            print('Warning: Order item is string, skipping: $item');
          } else {
            print('Warning: Skipping non-map item in order: $item');
          }
        } catch (e) {
          print('Error parsing order item: $e');
        }
      }
    }

    return OrderModel(
      id: doc.id,
      userId: data['userId']?.toString() ?? '',
      items: itemsList,
      totalPrice: OrderItem._parseDouble(data['totalPrice']),
      deliveryAddress: data['deliveryAddress']?.toString() ?? '',
      paymentMethod: data['paymentMethod']?.toString() ?? 'COD',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

