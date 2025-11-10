import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        role: 'user', // Default role is user
      );

      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      return user;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Check if user document exists
      if (!userDoc.exists) {
        // If user document doesn't exist, create it with default values
        final newUser = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'User',
          email: email,
          role: 'user',
        );
        await _firestore
            .collection('users')
            .doc(newUser.uid)
            .set(newUser.toMap());
        return newUser;
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc);
      }
      // If user document doesn't exist, create it with default values
      final user = _auth.currentUser;
      if (user != null) {
        final newUser = UserModel(
          uid: uid,
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          role: 'user',
        );
        await _firestore.collection('users').doc(uid).set(newUser.toMap());
        return newUser;
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

