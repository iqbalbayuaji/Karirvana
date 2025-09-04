import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  void register() {
    // Basic validation
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // if (birthDateController.text.isEmpty) {
    //   Get.snackbar(
    //     'Error',
    //     'Tanggal lahir tidak boleh kosong',
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return;
    // }
    
    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Password tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Password dan konfirmasi password tidak sama',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // TODO: Implement actual register logic
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      
      // For demo purposes, accept any valid input
      Get.snackbar(
        'Success',
        'Registrasi berhasil!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to login page after successful registration
      Get.offAllNamed('/login');
    });
  }
}
