import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  final UserService _userService = UserService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authState => _auth.userChanges();

  Future<User?> signUp(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.user!.sendEmailVerification();

    if (result.user != null) {
      final userProfile = UserProfile(
        uid: result.user!.uid,
        email: email,
        displayName: email.split('@')[0],
        createdAt: DateTime.now(),
      );
      await _userService.createUserProfile(userProfile);
    }

    return result.user;
  }

  Future<User?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  Future logout() async {
    await _auth.signOut();
  }
}
