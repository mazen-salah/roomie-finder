import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roomie_finder/models/UserModel.dart';

class RFAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Sign up with email and password
  Future<Map<String, dynamic>> signUp(
      UserModel userData, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: userData.email,
        password: password,
      );
      final user = userCredential.user;
      userData.id = user!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData.toJson());

      // Save user data to secure storage
      await _saveUserDataToSecureStorage(userData);

      return {
        'success': true,
        'message': 'Account created successfully.',
      };
    } catch (e) {
      return {'success': false, 'message': _handleAuthError(e)};
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      // Fetch user data from Firestore
      UserModel userData = UserModel.fromJson(
        (await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get())
            .data()!,
      );

      // Save user data to secure storage
      await _saveUserDataToSecureStorage(userData);

      return {
        'success': true,
        'message': 'Signed in successfully.',
      };
    } catch (e) {
      return {'success': false, 'message': _handleAuthError(e)};
    }
  }

  // Sign out
  Future<Map<String, dynamic>> signOut() async {
    try {
      await _auth.signOut();

      // Clear user data from secure storage
      await _secureStorage.deleteAll();

      return {'success': true, 'message': 'Signed out successfully.'};
    } catch (e) {
      return {'success': false, 'message': _handleAuthError(e)};
    }
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {'success': true, 'message': 'Password reset email sent.'};
    } catch (e) {
      return {'success': false, 'message': _handleAuthError(e)};
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserModel?> getCurrentUserData() async {
    if (isSignedIn()) {
      return await _readUserDataFromSecureStorage();
    }
    return null;
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  // Save user data to secure storage
  Future<void> _saveUserDataToSecureStorage(UserModel userData) async {
    await _secureStorage.write(key: 'userId', value: userData.id);
    await _secureStorage.write(key: 'fullName', value: userData.fullName);
    await _secureStorage.write(key: 'email', value: userData.email);
    await _secureStorage.write(key: 'role', value: userData.role);
  }

  // Read user data from secure storage
  Future<UserModel?> _readUserDataFromSecureStorage() async {
    String? id = await _secureStorage.read(key: 'userId');
    String? fullName = await _secureStorage.read(key: 'fullName');
    String? email = await _secureStorage.read(key: 'email');
    String? role = await _secureStorage.read(key: 'role');

    if (id != null && fullName != null && email != null && role != null) {
      return UserModel(
        id: id,
        fullName: fullName,
        email: email,
        role: role,
      );
    }
    return null;
  }

  // Handle errors
  String _handleAuthError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'The email is already in use by another account.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled.';
        case 'weak-password':
          return 'The password is too weak.';
        case 'user-disabled':
          return 'The user has been disabled.';
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided for that user.';
        default:
          return 'An undefined error occurred.';
      }
    } else {
      return 'An unknown error occurred.';
    }
  }
}
