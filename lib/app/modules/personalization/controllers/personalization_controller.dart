import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalizationController extends GetxController {
  // Form controllers
  final usernameController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  
  // Gender selection
  final selectedGender = ''.obs;
  
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
    usernameController.dispose();
    locationController.dispose();
    bioController.dispose();
    super.onClose();
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }
  
  void saveProfile() {
    // TODO: Implement save functionality
    print('Username: ${usernameController.text}');
    print('Gender: ${selectedGender.value}');
    print('Location: ${locationController.text}');
    print('Bio: ${bioController.text}');
  }
}
