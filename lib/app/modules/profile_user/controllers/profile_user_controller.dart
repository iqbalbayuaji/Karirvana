import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/firebase_auth_service.dart';
import '../../../services/firestore_service.dart';
import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
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
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Konfirmasi Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.2,
                      )
                    ],
                  ),

                  const SizedBox(height: 10),
                  // Description text
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Apakah Anda yakin ingin keluar dari aplikasi? Anda perlu login kembali untuk mengakses fitur-fitur aplikasi.',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.05,
                      )
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Buttons
              Column(
                children: [
                  // Logout Button (Red)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close dialog
                        logout(); // Perform logout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),
                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.outline),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
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
