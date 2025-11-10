import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

/// Debug screen to check user data and authentication state
/// This helps diagnose login and data loading issues
class DebugUserScreen extends StatelessWidget {
  const DebugUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug: User Info'),
        backgroundColor: AppTheme.primaryRed,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authentication Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoCard('Firebase Auth User', currentUser?.email ?? 'Not logged in'),
            _buildInfoCard('User ID', currentUser?.uid ?? 'N/A'),
            _buildInfoCard('Email Verified', currentUser?.emailVerified.toString() ?? 'N/A'),

            const SizedBox(height: 24),
            const Text(
              'Firestore User Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (currentUser != null)
              FutureBuilder(
                future: authService.getUserData(currentUser.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return _buildErrorCard('Error loading user data', snapshot.error.toString());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return _buildErrorCard(
                      'User document not found',
                      'The user document does not exist in Firestore. Try signing up again.',
                    );
                  }

                  final user = snapshot.data!;
                  return Column(
                    children: [
                      _buildInfoCard('Name', user.name),
                      _buildInfoCard('Email', user.email),
                      _buildInfoCard('Role', user.role),
                      _buildInfoCard('UID', user.uid),
                    ],
                  );
                },
              )
            else
              _buildErrorCard('Not logged in', 'Please login first'),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String title, String message) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(message),
          ],
        ),
      ),
    );
  }
}

