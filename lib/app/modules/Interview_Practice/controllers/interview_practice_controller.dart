import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterviewPracticeController extends GetxController {
  // Reactive variables for UI state
  final selectedDifficulty = 'Medium'.obs;
  final selectedStyle = 'Friendly'.obs;
  
  // Text controller for additional prompts
  final additionalPromptsController = TextEditingController();
  
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
    additionalPromptsController.dispose();
    super.onClose();
  }

  // Methods to update selections
  void setDifficulty(String difficulty) {
    selectedDifficulty.value = difficulty;
  }
  
  void setStyle(String style) {
    selectedStyle.value = style;
  }
  
  // Method to get current settings
  Map<String, dynamic> getInterviewSettings() {
    return {
      'difficulty': selectedDifficulty.value,
      'style': selectedStyle.value,
      'additionalPrompts': additionalPromptsController.text,
    };
  }
}
