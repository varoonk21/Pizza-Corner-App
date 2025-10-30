import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB('pizza_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE pizzas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      description TEXT,
      price REAL,
      image TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE cart (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pizza_id INTEGER,
      size TEXT,
      quantity INTEGER,
      total_price REAL
    )
  ''');

    await db.execute('''
    CREATE TABLE orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_name TEXT,
      address TEXT,
      phone TEXT,
      total_amount REAL,
      order_date TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE order_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      order_id INTEGER,
      pizza_name TEXT,
      size TEXT,
      quantity INTEGER,
      price REAL
    )
  ''');

    // 🍕 Insert sample pizzas
    final samplePizzas = [
      {
        'name': 'Margherita',
        'description': 'Classic cheese and tomato pizza.',
        'price': 499,
        'image': 'assets/pizzas/margherita.png'
      },
      {
        'name': 'Pepperoni',
        'description': 'Spicy pepperoni with mozzarella cheese.',
        'price': 599,
        'image': 'assets/pizzas/pepperoni.png'
      },
      {
        'name': 'Veggie Delight',
        'description': 'Loaded with mushrooms, peppers, and olives.',
        'price': 549,
        'image': 'assets/pizzas/veggie.png'
      },
      {
        'name': 'BBQ Chicken',
        'description': 'Tangy BBQ sauce with grilled chicken and onions.',
        'price': 649,
        'image': 'assets/pizzas/bbq_chicken.png'
      },
      {
        'name': 'Four Cheese',
        'description': 'Mozzarella, cheddar, gouda, and parmesan blend.',
        'price': 699,
        'image': 'assets/pizzas/four_cheese.png'
      },
      {
        'name': 'Spicy Paneer',
        'description': 'Indian cottage cheese cubes with hot masala sauce.',
        'price': 579,
        'image': 'assets/pizzas/paneer.png'
      },
      {
        'name': 'Hawaiian',
        'description': 'Tropical pineapple and ham for a sweet-salty combo.',
        'price': 629,
        'image': 'assets/pizzas/hawaiian.png'
      },
      {
        'name': 'Tandoori Chicken',
        'description': 'Smoky tandoori-flavored chicken with onions.',
        'price': 699,
        'image': 'assets/pizzas/tandoori.png'
      },
      {
        'name': 'Mexican Green Wave',
        'description': 'Spicy jalapeños, capsicum, and Mexican herbs.',
        'price': 589,
        'image': 'assets/pizzas/mexican.png'
      },
      {
        'name': 'Meat Feast',
        'description': 'Loaded with pepperoni, sausage, and chicken chunks.',
        'price': 749,
        'image': 'assets/pizzas/meat_feast.png'
      },
      {
        'name': 'Cheesy Garlic',
        'description': 'Garlic base topped with mozzarella and herbs.',
        'price': 499,
        'image': 'assets/pizzas/garlic.png'
      },
      {
        'name': 'Peri Peri Veg',
        'description': 'Peri-peri sauce with onions, peppers, and sweet corn.',
        'price': 569,
        'image': 'assets/pizzas/peri_peri.png'
      },
    ];

    for (final pizza in samplePizzas) {
      await db.insert('pizzas', pizza);
    }
  }
  Future<List<Map<String, dynamic>>> getPizzas() async {
    final db = await instance.database;
    return await db.query('pizzas');
  }

  Future<void> addToCart(int pizzaId, String size, int quantity, double total) async {
    final db = await instance.database;
    await db.insert('cart', {
      'pizza_id': pizzaId,
      'size': size,
      'quantity': quantity,
      'total_price': total
    });
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await instance.database;
    return await db.query('cart');
  }

  Future<void> clearCart() async {
    final db = await instance.database;
    await db.delete('cart');
  }

  Future<void> removeCartItem(int id) async {
    final db = await instance.database;
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertOrder(Map<String, dynamic> order, List<Map<String, dynamic>> items) async {
    final db = await instance.database;
    final orderId = await db.insert('orders', order);

    for (var item in items) {
      await db.insert('order_items', {
        'order_id': orderId,
        'pizza_name': item['pizza_name'],
        'size': item['size'],
        'quantity': item['quantity'],
        'price': item['total_price']
      });
    }

    await clearCart();
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await instance.database;
    return await db.query('orders', orderBy: 'id DESC');
  }
}
