import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class CheckoutScreen extends StatefulWidget {
  final double total;
  const CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final db = DatabaseHelper.instance;
    final cartItems = await db.getCartItems();

    final order = {
      'customer_name': nameController.text,
      'address': addressController.text,
      'phone': phoneController.text,
      'total_amount': widget.total,
      'order_date': DateTime.now().toIso8601String(),
    };

    await db.insertOrder(order, cartItems);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v!.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (v) => v!.isEmpty ? 'Enter address' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (v) => v!.isEmpty ? 'Enter phone number' : null,
                keyboardType: TextInputType.phone,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: Text('Place Order (Rs. ${widget.total.toStringAsFixed(2)})'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
