import 'package:firebase_auth/firebase_auth.dart';

/// Mock User for demo mode when Firebase is not available
class MockUser implements User {
  final String _uid;
  final String? _email;
  final String? _displayName;

  MockUser({
    String? uid,
    String? email,
    String? displayName,
  })  : _uid = uid ?? 'demo-user-123',
        _email = email ?? 'demo@kigali.rw',
        _displayName = displayName ?? 'User';

  @override
  String get uid => _uid;

  @override
  String? get email => _email;

  @override
  bool get emailVerified => true;

  @override
  String? get displayName => _displayName;

  @override
  String? get photoURL => null;

  @override
  bool get isAnonymous => false;

  @override
  String? get phoneNumber => null;

  @override
  String? get tenantId => null;

  @override
  String? get refreshToken => null;

  @override
  UserMetadata get metadata => MockUserMetadata();

  @override
  List<UserInfo> get providerData => [];

  // Implement other User interface methods as no-ops
  @override
  Future<void> delete() async {}

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'mock-token';

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) async =>
      throw UnimplementedError();

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(
    String phoneNumber, [
    RecaptchaVerifier? verifier,
  ]) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithCredential(
      AuthCredential credential) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithProvider(
      AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) async {}

  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<void> linkWithRedirect(AuthProvider provider) async {}

  @override
  Future<void> reload() async {}

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}

  @override
  Future<User> unlink(String providerId) async => this;

  @override
  Future<void> updateEmail(String newEmail) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) async {}

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {}

  @override
  Future<void> updateDisplayName(String? displayName) async {}

  @override
  Future<void> updatePhotoURL(String? photoURL) async {}

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail,
      [ActionCodeSettings? actionCodeSettings]) async {}

  @override
  MultiFactor get multiFactor => throw UnimplementedError();
}

class MockUserMetadata implements UserMetadata {
  @override
  DateTime? get creationTime => DateTime.now();

  @override
  DateTime? get lastSignInTime => DateTime.now();
}
