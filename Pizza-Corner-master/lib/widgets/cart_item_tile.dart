import 'package:flutter/material.dart';

class CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;

  const CartItemTile({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left section (pizza info)
            Row(
              children: [
                const Icon(Icons.local_pizza, color: Colors.red),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pizza #${item['pizza_id']} (${item['size']})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Qty: ${item['quantity']}'),
                  ],
                ),
              ],
            ),

            // Right section (price + delete)
            Column(
              mainAxisSize: MainAxisSize.min, // ✅ prevents overflow
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'PKR ${(item['total_price'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: onRemove,
                  visualDensity: VisualDensity.compact, // ✅ makes button smaller
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
