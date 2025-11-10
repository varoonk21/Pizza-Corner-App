import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  String? selectedSize;
  List<Topping> selectedToppings;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedToppings = const [],
  });

  // Calculate item total price including size multiplier and toppings
  double get totalPrice {
    double basePrice = product.price;

    // Size multiplier (optional - you can customize this)
    if (selectedSize != null) {
      if (selectedSize == 'Medium') {
        basePrice *= 1.3;
      } else if (selectedSize == 'Large') {
        basePrice *= 1.6;
      }
    }

    // Add toppings price
    double toppingsPrice = selectedToppings.fold(0.0, (sum, topping) => sum + topping.price);

    return (basePrice + toppingsPrice) * quantity;
  }

  // Generate unique key for cart item with customizations
  String get uniqueKey {
    String key = product.id;
    if (selectedSize != null) key += '_$selectedSize';
    if (selectedToppings.isNotEmpty) {
      key += '_${selectedToppings.map((t) => t.name).join('_')}';
    }
    return key;
  }
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void addItem(ProductModel product, {String? size, List<Topping>? toppings}) {
    final cartItem = CartItem(
      product: product,
      quantity: 1,
      selectedSize: size,
      selectedToppings: toppings ?? [],
    );

    final key = cartItem.uniqueKey;

    if (_items.containsKey(key)) {
      _items[key]!.quantity++;
    } else {
      _items[key] = cartItem;
    }
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void increaseQuantity(String key) {
    if (_items.containsKey(key)) {
      _items[key]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String key) {
    if (_items.containsKey(key)) {
      if (_items[key]!.quantity > 1) {
        _items[key]!.quantity--;
      } else {
        _items.remove(key);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  List<OrderItem> getOrderItems() {
    return _items.values.map((cartItem) {
      return OrderItem(
        productId: cartItem.product.id,
        productName: cartItem.product.name,
        price: cartItem.totalPrice / cartItem.quantity, // Unit price with customizations
        quantity: cartItem.quantity,
        size: cartItem.selectedSize,
        toppings: cartItem.selectedToppings.map((t) => t.name).toList(),
      );
    }).toList();
  }
}

