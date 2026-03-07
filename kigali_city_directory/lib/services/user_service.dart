import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';

class UserService {
  FirebaseFirestore? get _db =>
      Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null;

  CollectionReference<Map<String, dynamic>>? get users =>
      _db?.collection("users");

  /// Create user profile in Firestore
  Future<void> createUserProfile(UserProfile userProfile) async {
    if (users != null) {
      await users!.doc(userProfile.uid).set(userProfile.toMap());
    }
  }

  /// Get user profile from Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    if (users == null) return null;

    final doc = await users!.doc(uid).get();
    if (!doc.exists) return null;

    return UserProfile.fromMap(doc.data()!, uid);
  }

  /// Update user profile
  Future<void> updateUserProfile(UserProfile userProfile) async {
    if (users != null) {
      await users!.doc(userProfile.uid).update(userProfile.toMap());
    }
  }
}
