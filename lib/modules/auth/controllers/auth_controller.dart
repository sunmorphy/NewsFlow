import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../data/local/database_helper.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  var isLoading = false.obs;

  late final Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;

  AuthController() {
    _initializeGoogleSignIn();
  }

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed(Routes.HOME);
      });
    }
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
    } catch (e) {
      debugPrint('Failed to initialize Google Sign-In: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _saveUserToLocalDb(user);
        Get.offAllNamed(Routes.HOME);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInAsGuest() async {
    try {
      isLoading.value = true;

      final UserCredential userCredential = await _auth.signInAnonymously();
      final User? user = userCredential.user;

      if (user != null) {
        await _saveUserToLocalDb(user, isGuest: true);
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      Get.snackbar("Guest Login Failed", "Please try again later.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUserToLocalDb(User user, {bool isGuest = false}) async {
    await _dbHelper.saveUser({
      'uid': user.uid,
      'email': user.email ?? 'Guest',
      'displayName': isGuest ? 'Guest User' : (user.displayName ?? 'Unknown'),
      'photoUrl': user.photoURL ?? '',
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _dbHelper.clearUser();
    Get.offAllNamed(Routes.LOGIN);
  }
}
