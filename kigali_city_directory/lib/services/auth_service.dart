import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  final UserService _userService = UserService();

  FirebaseAuth? get _auth =>
      Firebase.apps.isNotEmpty ? FirebaseAuth.instance : null;

  User? get currentUser => _auth?.currentUser;

  Stream<User?> get authState =>
      _auth?.authStateChanges() ?? const Stream<User?>.empty();

  Future<User?> signUp(String email, String password) async {
    if (_auth == null) {
      return null;
    }

    final result = await _auth!.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.user!.sendEmailVerification();

    // Create user profile in Firestore
    if (result.user != null) {
      final userProfile = UserProfile(
        uid: result.user!.uid,
        email: email,
        displayName: email.split('@')[0], // Use email prefix as display name
        createdAt: DateTime.now(),
      );
      await _userService.createUserProfile(userProfile);
    }

    return result.user;
  }

  Future<User?> login(String email, String password) async {
    if (_auth == null) {
      return null;
    }

    final result = await _auth!.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  Future logout() async {
    if (_auth == null) {
      return;
    }

    await _auth!.signOut();
  }
}
