import 'package:cloud_firestore/cloud_firestore.dart';

/// Script to populate sample menu data to Firestore
/// Run this once to add sample products to your database
class SampleDataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedMenuData() async {
    try {
      print('Starting to seed sample menu data...');

      // Sample Pizza Products
      final pizzas = [
        {
          'name': 'Margherita Pizza',
          'description': 'Classic cheese pizza with tomato sauce and fresh basil',
          'price': 12.99,
          'category': 'Pizza',
          'imageUrl': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
          'available': true,
          'sizes': ['Small', 'Medium', 'Large'],
          'toppings': [
            {'name': 'Extra Cheese', 'price': 2.00},
            {'name': 'Olives', 'price': 1.50},
            {'name': 'Mushrooms', 'price': 1.50},
            {'name': 'Pepperoni', 'price': 2.50},
            {'name': 'Bell Peppers', 'price': 1.50},
          ],
        },
        {
          'name': 'Pepperoni Pizza',
          'description': 'Loaded with pepperoni and mozzarella cheese',
          'price': 14.99,
          'category': 'Pizza',
          'imageUrl': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
          'available': true,
          'sizes': ['Small', 'Medium', 'Large'],
          'toppings': [
            {'name': 'Extra Cheese', 'price': 2.00},
            {'name': 'Extra Pepperoni', 'price': 3.00},
            {'name': 'Jalapeños', 'price': 1.50},
            {'name': 'Onions', 'price': 1.00},
          ],
        },
        {
          'name': 'Veggie Supreme',
          'description': 'Loaded with fresh vegetables and cheese',
          'price': 13.99,
          'category': 'Pizza',
          'imageUrl': 'https://images.unsplash.com/photo-1511689660979-10d2b1aada49?w=400',
          'available': true,
          'sizes': ['Small', 'Medium', 'Large'],
          'toppings': [
            {'name': 'Extra Veggies', 'price': 2.00},
            {'name': 'Olives', 'price': 1.50},
            {'name': 'Mushrooms', 'price': 1.50},
            {'name': 'Spinach', 'price': 1.50},
          ],
        },
        {
          'name': 'BBQ Chicken Pizza',
          'description': 'Grilled chicken with BBQ sauce and red onions',
          'price': 15.99,
          'category': 'Pizza',
          'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
          'available': true,
          'sizes': ['Small', 'Medium', 'Large'],
          'toppings': [
            {'name': 'Extra Chicken', 'price': 3.00},
            {'name': 'Bacon', 'price': 2.50},
            {'name': 'Pineapple', 'price': 1.50},
          ],
        },
      ];

      // Sample Sides
      final sides = [
        {
          'name': 'Garlic Bread',
          'description': 'Crispy bread with garlic butter',
          'price': 5.99,
          'category': 'Sides',
          'imageUrl': 'https://images.unsplash.com/photo-1573140401552-388e259e0e3c?w=400',
          'available': true,
          'sizes': [],
          'toppings': [],
        },
        {
          'name': 'Chicken Wings',
          'description': 'Spicy buffalo wings with ranch dip',
          'price': 8.99,
          'category': 'Sides',
          'imageUrl': 'https://images.unsplash.com/photo-1608039755401-742074f0548d?w=400',
          'available': true,
          'sizes': ['6 pieces', '12 pieces'],
          'toppings': [],
        },
        {
          'name': 'French Fries',
          'description': 'Crispy golden fries',
          'price': 4.99,
          'category': 'Sides',
          'imageUrl': 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
          'available': true,
          'sizes': ['Regular', 'Large'],
          'toppings': [],
        },
      ];

      // Sample Drinks
      final drinks = [
        {
          'name': 'Coca Cola',
          'description': 'Classic refreshing soda',
          'price': 2.99,
          'category': 'Drinks',
          'imageUrl': 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400',
          'available': true,
          'sizes': ['Regular', 'Large'],
          'toppings': [],
        },
        {
          'name': 'Lemonade',
          'description': 'Fresh squeezed lemonade',
          'price': 3.49,
          'category': 'Drinks',
          'imageUrl': 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f4e?w=400',
          'available': true,
          'sizes': ['Regular', 'Large'],
          'toppings': [],
        },
        {
          'name': 'Iced Tea',
          'description': 'Refreshing iced tea',
          'price': 2.79,
          'category': 'Drinks',
          'imageUrl': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
          'available': true,
          'sizes': ['Regular', 'Large'],
          'toppings': [],
        },
      ];

      // Sample Desserts
      final desserts = [
        {
          'name': 'Chocolate Brownie',
          'description': 'Warm chocolate brownie with ice cream',
          'price': 6.99,
          'category': 'Desserts',
          'imageUrl': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
          'available': true,
          'sizes': [],
          'toppings': [],
        },
        {
          'name': 'Cheesecake',
          'description': 'Classic New York style cheesecake',
          'price': 7.99,
          'category': 'Desserts',
          'imageUrl': 'https://images.unsplash.com/photo-1533134486753-c833f0ed4866?w=400',
          'available': true,
          'sizes': [],
          'toppings': [],
        },
      ];

      // Combine all products
      final allProducts = [...pizzas, ...sides, ...drinks, ...desserts];

      // Add products to Firestore
      for (var product in allProducts) {
        await _firestore.collection('products').add(product);
        print('Added: ${product['name']}');
      }

      print('✅ Successfully seeded ${allProducts.length} products!');
    } catch (e) {
      print('❌ Error seeding data: $e');
    }
  }
}

