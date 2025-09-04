import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/firebase_auth_service.dart';

class LoginController extends GetxController {
  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Observable variables
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  
  // Login method
  Future<void> login() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Password tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      if (userCredential != null) {
        Get.snackbar(
          'Success',
          'Login berhasil!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to home page after successful login
        Get.offAllNamed('/homepage');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
