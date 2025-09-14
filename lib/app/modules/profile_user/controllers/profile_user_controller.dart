import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/firebase_auth_service.dart';
import '../../../services/firestore_service.dart';
import '../../../routes/app_pages.dart';
import '../../homepage/controllers/homepage_controller.dart';

class ProfileUserController extends GetxController {
  final count = 0.obs;
  
  // Firebase Services
  final FirebaseAuthService _authService = Get.find<FirebaseAuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  
  // User data observables
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString profileImageUrl = ''.obs;
  final RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
  }
  
  // Load user data from Firebase
  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      
      final userData = await _firestoreService.getUserProfile();
      if (userData != null) {
        userName.value = userData['name'] ?? '';
        userEmail.value = userData['email'] ?? '';
        profileImageUrl.value = userData['profileImageUrl'] ?? '';
      }
    } catch (e) {
      print('Error loading user data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data profil',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  
  // Show logout confirmation dialog
  void showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Konfirmasi Logout',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              logout(); // Perform logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Perform logout
  Future<void> logout() async {
    try {
      // Sign out from Firebase
      await _authService.signOut();
      
      // Reset popup session state
      HomepageController.resetPopupSession();
      
      // Navigate to login page and clear navigation stack
      Get.offAllNamed(Routes.LOGIN);
      
      // Show success message
      Get.snackbar(
        'Berhasil',
        'Anda telah berhasil logout',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Gagal logout: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
