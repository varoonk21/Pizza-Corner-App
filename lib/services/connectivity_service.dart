import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<dynamic>? _subscription;
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityService() {
    _initConnectivity();
    // onConnectivityChanged may emit either a single ConnectivityResult or a List<ConnectivityResult>
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      // Keep print for debugging; not fatal
      print('Connectivity check error: $e');
    }
  }

  void _updateConnectionStatus(dynamic result) {
    try {
      if (result is List) {
        // Some platforms (web) may return a list of results; consider online if any entry is not none
        _isOnline = result.any((r) => r != ConnectivityResult.none);
      } else if (result is ConnectivityResult) {
        _isOnline = result != ConnectivityResult.none;
      } else {
        // Fallback: assume online
        _isOnline = true;
      }
    } catch (e) {
      _isOnline = true;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
