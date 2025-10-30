import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/pizza.dart';
import '../widgets/pizza_card.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pizza> pizzas = [];

  @override
  void initState() {
    super.initState();
    _loadPizzas();
  }

  Future<void> _loadPizzas() async {
    final data = await DatabaseHelper.instance.getPizzas();
    setState(() {
      pizzas = data.map((e) => Pizza.fromMap(e)).toList();
    });
  }

  void _openAdminPanel(BuildContext context) async {
    const adminPassword = 'admin123';

    final enteredPassword = await showDialog<String>(
      context: context,
      builder: (context) {
        String password = '';
        return AlertDialog(
          title: const Text('Admin Login'),
          content: TextField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Enter Admin Password',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => password = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, password),
              child: const Text('Login'),
            ),
          ],
        );
      },
    );

    if (enteredPassword == adminPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminScreen()),
      );
    } else if (enteredPassword != null && enteredPassword.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Incorrect password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Menu'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Admin Panel',
            onPressed: () => _openAdminPanel(context),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'View Cart',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: pizzas.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 🟢 Two items per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75, // 🟢 Taller cards
              ),
              itemCount: pizzas.length,
              itemBuilder: (context, index) {
                final pizza = pizzas[index];
                return PizzaCard(pizza: pizza);
              },
            ),
    );
  }
}
