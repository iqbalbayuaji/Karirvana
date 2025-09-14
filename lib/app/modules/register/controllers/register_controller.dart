import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/firebase_auth_service.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  // final birthDateController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;
  final selectedDate = Rx<DateTime?>(null);
  
  // Firebase Auth Service
  final FirebaseAuthService _authService = Get.find<FirebaseAuthService>();
  
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    // birthDateController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  
  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }
  
  // Select birth date
  // Future<void> selectBirthDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate.value ?? DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //   );
    
  //   if (picked != null && picked != selectedDate.value) {
  //     selectedDate.value = picked;
  //     birthDateController.text = "${picked.day}/${picked.month}/${picked.year}";
  //   }
  // }
  
  // Register method
  Future<void> register() async {
    print('🔍 DEBUG: Register method called');
    
    // Basic validation
    if (nameController.text.isEmpty) {
      print('❌ DEBUG: Name is empty');
      Get.snackbar(
        'Error',
        'Nama tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (emailController.text.isEmpty) {
      print('❌ DEBUG: Email is empty');
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (passwordController.text.isEmpty) {
      print('❌ DEBUG: Password is empty');
      Get.snackbar(
        'Error',
        'Password tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      print('❌ DEBUG: Passwords do not match');
      Get.snackbar(
        'Error',
        'Password dan konfirmasi password tidak sama',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (passwordController.text.length < 6) {
      print('❌ DEBUG: Password too short');
      Get.snackbar(
        'Error',
        'Password minimal 6 karakter',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    print('✅ DEBUG: All validations passed, starting registration...');
    isLoading.value = true;
    
    try {
      print('🔄 DEBUG: Calling Firebase registerWithEmailAndPassword...');
      final userCredential = await _authService.registerWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
      );
      
      print('🔍 DEBUG: Firebase response: ${userCredential != null ? "SUCCESS" : "NULL"}');
      
      if (userCredential != null) {
        print('✅ DEBUG: Registration successful, showing success message...');
        Get.snackbar(
          'Success',
          'Registrasi berhasil!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        print('✅ DEBUG: Registration completed - waiting for AuthWrapper to detect auth state...');
        // Give a small delay to ensure Firebase Auth state propagates
        await Future.delayed(const Duration(milliseconds: 500));
        
        // If AuthWrapper hasn't navigated yet, force navigation as fallback
        if (Get.currentRoute == '/register') {
          print('🔄 DEBUG: AuthWrapper hasn\'t navigated yet, forcing navigation to homepage');
          Get.offAllNamed(Routes.HOMEPAGE);
        }
      } else {
        print('❌ DEBUG: UserCredential is null, registration failed');
      }
    } catch (e) {
      print('❌ DEBUG: Exception in register method: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      print('🔄 DEBUG: Setting loading to false');
      isLoading.value = false;
    }
  }
}
