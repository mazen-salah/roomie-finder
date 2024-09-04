import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
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
      await _saveUserDataToFirestore(userData);
      await _createData(user.uid);
      await _saveUserDataToSecureStorage(userData);

      return _successResponse('Account created successfully.');
    } catch (e) {
      return _errorResponse(e);
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
      final userData = await fetchUserDataFromFirestore(user!.uid);
      await _saveUserDataToSecureStorage(userData);

      return _successResponse('Signed in successfully.');
    } catch (e) {
      return _errorResponse(e);
    }
  }

  // Sign out
  Future<Map<String, dynamic>> signOut() async {
    try {
      await _auth.signOut();
      await _secureStorage.deleteAll();
      log('Signed out successfully.');
      return _successResponse('Signed out successfully.');
    } catch (e) {
      return _errorResponse(e);
    }
  }

  Future<String> getUid() async {
    return _auth.currentUser!.uid;
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return _successResponse('Password reset email sent.');
    } catch (e) {
      return _errorResponse(e);
    }
  }

  // Get current user
  User? getCurrentUser() => _auth.currentUser;

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    if (isSignedIn()) {
      return await _readUserDataFromSecureStorage();
    }
    return null;
  }

  // Check if user is signed in
  bool isSignedIn() => _auth.currentUser != null;

  // Update user data in Firestore and secure storage
  Future<Map<String, dynamic>> updateUserData(UserModel updatedUserData) async {
    try {
      await _saveUserDataToFirestore(updatedUserData);
      await _saveUserDataToSecureStorage(updatedUserData);

      return _successResponse('User data updated successfully.');
    } catch (e) {
      return _errorResponse(e);
    }
  }

  // Save user data to Firestore and create an empty notifications array
  Future<void> _saveUserDataToFirestore(UserModel userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.id)
        .set(userData.toJson(), SetOptions(merge: true));
  }

  // Create an empty notifications array in the user document
  Future<void> _createData(String uid) async {
    await FirebaseFirestore.instance.collection('data').doc(uid).set({
      'notifications': [
        {
          'title': 'Welcome',
          'unReadNotification': true,
          'description': 'Your account has been created successfully.',
        }
      ]
    }, SetOptions(merge: true));
  }

  // Update notifications in Firestore
  Future<void> updateNotification(
      String uid, List<dynamic> notifications) async {
    await FirebaseFirestore.instance
        .collection('data')
        .doc(uid)
        .set({'notifications': notifications}, SetOptions(merge: true));
  }

  // Save user data to secure storage
  Future<void> _saveUserDataToSecureStorage(UserModel userData) async {
    await _secureStorage.write(key: 'userId', value: userData.id);
    await _secureStorage.write(key: 'fullName', value: userData.fullName);
    await _secureStorage.write(key: 'email', value: userData.email);
    await _secureStorage.write(key: 'role', value: userData.role);
    await _secureStorage.write(
        key: 'photoUrl', value: userData.profileImageUrl);
    await _secureStorage.write(key: 'phoneNumber', value: userData.phone);
    await _secureStorage.write(key: 'location', value: userData.location);
  }

  // Read user data from secure storage
  Future<UserModel?> _readUserDataFromSecureStorage() async {
    final id = await _secureStorage.read(key: 'userId');
    final fullName = await _secureStorage.read(key: 'fullName');
    final email = await _secureStorage.read(key: 'email');
    final role = await _secureStorage.read(key: 'role');
    final photoUrl = await _secureStorage.read(key: 'photoUrl');
    final phoneNumber = await _secureStorage.read(key: 'phoneNumber');
    final location = await _secureStorage.read(key: 'location');

    if ([id, fullName, email, role, photoUrl, phoneNumber, location]
        .every((element) => element != null)) {
      return UserModel(
        id: id!,
        fullName: fullName!,
        email: email!,
        role: role!,
        profileImageUrl: photoUrl??'',
        phone: phoneNumber!,
        location: location!,
      );
    }
    return null;
  }

  // Fetch user data from Firestore
  Future<UserModel> fetchUserDataFromFirestore(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return UserModel.fromJson(doc.data()!);
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

  // Success response
  Map<String, dynamic> _successResponse(String message) {
    return {'success': true, 'message': message};
  }

  // Error response
  Map<String, dynamic> _errorResponse(Object e) {
    return {'success': false, 'message': _handleAuthError(e)};
  }
}
