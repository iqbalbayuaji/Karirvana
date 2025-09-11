import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseAuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      print('🔄 DEBUG: Firebase Auth - Starting createUserWithEmailAndPassword...');
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('✅ DEBUG: Firebase Auth - User created successfully: ${userCredential.user?.uid}');
      
      // Update display name
      print('🔄 DEBUG: Firebase Auth - Updating display name...');
      await userCredential.user?.updateDisplayName(name);
      print('✅ DEBUG: Firebase Auth - Display name updated');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ DEBUG: Firebase Auth Exception: ${e.code} - ${e.message}');
      _handleAuthError(e);
      return null;
    } catch (e) {
      print('❌ DEBUG: Firebase Auth General Exception: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return null;
    }
  }
  
  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return null;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal logout: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
  
  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Success',
        'Email reset password telah dikirim',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
  
  // Handle Firebase Auth errors
  void _handleAuthError(FirebaseAuthException e) {
    String message;
    
    switch (e.code) {
      case 'weak-password':
        message = 'Password terlalu lemah';
        break;
      case 'email-already-in-use':
        message = 'Email sudah terdaftar';
        break;
      case 'user-not-found':
        message = 'User tidak ditemukan';
        break;
      case 'wrong-password':
        message = 'Password salah';
        break;
      case 'invalid-email':
        message = 'Format email tidak valid';
        break;
      case 'user-disabled':
        message = 'Akun telah dinonaktifkan';
        break;
      case 'too-many-requests':
        message = 'Terlalu banyak percobaan. Coba lagi nanti';
        break;
      case 'operation-not-allowed':
        message = 'Operasi tidak diizinkan';
        break;
      case 'invalid-credential':
        message = 'Email atau password salah';
        break;
      default:
        message = 'Terjadi kesalahan: ${e.message}';
    }
    
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }
}
