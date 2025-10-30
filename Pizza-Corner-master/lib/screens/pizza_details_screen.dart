import 'package:flutter/material.dart';
import '../models/pizza.dart';
import '../db/database_helper.dart';

class PizzaDetailsScreen extends StatefulWidget {
  final Pizza pizza;
  const PizzaDetailsScreen({super.key, required this.pizza});

  @override
  State<PizzaDetailsScreen> createState() => _PizzaDetailsScreenState();
}

class _PizzaDetailsScreenState extends State<PizzaDetailsScreen> {
  String selectedSize = 'Medium';
  int quantity = 1;

  double get totalPrice {
    double base = widget.pizza.price;
    if (selectedSize == 'Small') base -= 200.0;
    if (selectedSize == 'Large') base += 400.0;
    return base * quantity;
  }

  Future<void> addToCart() async {
    await DatabaseHelper.instance.addToCart(
      widget.pizza.id!,
      selectedSize,
      quantity,
      totalPrice,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pizza.name),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(widget.pizza.image, height: 200),
            const SizedBox(height: 20),
            Text(
              widget.pizza.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.pizza.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedSize,
                  items: ['Small', 'Medium', 'Large']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedSize = v!),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: quantity > 1
                      ? () => setState(() => quantity--)
                      : null,
                ),
                Text('$quantity', style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => quantity++),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Total: Rs. ${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: addToCart,
              icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
              label: const Text('Add to Cart',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
