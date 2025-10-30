import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final data = await DatabaseHelper.instance.getOrders();
    setState(() {
      orders = data;
    });
  }

  Future<void> _deleteOrder(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('orders', where: 'id = ?', whereArgs: [id]);
    await db.delete('order_items', where: 'order_id = ?', whereArgs: [id]);
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
            tooltip: 'Refresh Orders',
          ),
        ],
      ),
      body: orders.isEmpty
          ? const Center(
        child: Text(
          'No orders found',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.separated(
        itemCount: orders.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final order = orders[index];

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row (Name + Date)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          order['customer_name'] != null
                              ? 'Customer: ${order['customer_name']}'
                              : 'Customer: Unknown',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        order['order_date'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Details
                  Text('Address: ${order['address'] ?? 'N/A'}'),
                  const SizedBox(height: 2),
                  Text('Phone: ${order['phone'] ?? 'N/A'}'),
                  const SizedBox(height: 2),
                  Text(
                    'Total: Rs. ${order['total_amount'] ?? 0}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Complete button
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Mark as Complete'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Mark as Complete?'),
                            content: const Text(
                              'Are you sure you want to mark this order as completed?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(ctx, true),
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _deleteOrder(order['id']);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                Text('Order marked as complete.'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
