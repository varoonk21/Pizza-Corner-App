import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== PRODUCTS ==========

  // Get all products
  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get products by category
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Add product (Admin)
  Future<void> addProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
    } catch (e) {
      print('Add product error: $e');
      rethrow;
    }
  }

  // Update product (Admin)
  Future<void> updateProduct(String productId, ProductModel product) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .update(product.toMap());
    } catch (e) {
      print('Update product error: $e');
      rethrow;
    }
  }

  // Delete product (Admin)
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print('Delete product error: $e');
      rethrow;
    }
  }

  // ========== ORDERS ==========

  // Create order
  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      print('Create order error: $e');
      rethrow;
    }
  }

  // Get user orders
  Stream<List<OrderModel>> getUserOrders(String userId) {
    // We'll attempt to use an indexed query with server-side ordering first.
    // If Firestore rejects the query because a composite index is required,
    // fall back to an unordered query and perform client-side sorting.

    final controller = StreamController<List<OrderModel>>.broadcast();

    StreamSubscription? primarySub;
    StreamSubscription? fallbackSub;

    // Primary query: where + orderBy (may require composite index)
    final primaryQuery = _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true);

    void startFallback([Object? error]) {
      if (error != null) {
        // Log the error and try to extract an index creation URL if present
        try {
          print('Order query failed (will fallback to client-side sort): $error');
          final msg = error.toString();
          final indexUrlMarker = 'create it here:';
          final idx = msg.indexOf(indexUrlMarker);
          if (idx != -1) {
            final url = msg.substring(idx + indexUrlMarker.length).trim();
            print('Firestore requires a composite index for this query. Create it here:\n${url}');
          }
        } catch (_) {}
      }

      // Cancel primary subscription if still active
      primarySub?.cancel();
      primarySub = null;

      // Start fallback: fetch unordered snapshots and sort locally
      final fallbackQuery = _firestore.collection('orders').where('userId', isEqualTo: userId);
      fallbackSub = fallbackQuery.snapshots().listen(
        (snapshot) {
          try {
            final list = snapshot.docs
                .map((doc) => OrderModel.fromFirestore(doc))
                .toList();
            // Sort client-side by timestamp descending
            list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
            controller.add(list);
          } catch (e) {
            controller.addError(e);
          }
        },
        onError: (e) {
          controller.addError(e);
        },
      );
    }

    // Start primary subscription
    primarySub = primaryQuery.snapshots().listen(
      (snapshot) {
        try {
          final list = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
          controller.add(list);
        } catch (e) {
          controller.addError(e);
        }
      },
      onError: (e) {
        // If Firestore signals that a composite index is required (FAILED_PRECONDITION),
        // switch to fallback mode and continue streaming sorted results client-side.
        startFallback(e);
      },
    );

    controller.onCancel = () async {
      await primarySub?.cancel();
      await fallbackSub?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  // Get all orders (Admin)
  Stream<List<OrderModel>> getAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Update order status (Admin)
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });
    } catch (e) {
      print('Update order status error: $e');
      rethrow;
    }
  }
}
