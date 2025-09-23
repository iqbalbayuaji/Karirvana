import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../services/cv_template_service.dart';

class CvTemplateDisplayController extends GetxController {
  // Observable variables
  final cvData = Rxn<Map<String, dynamic>>();
  final pdfPath = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get arguments from navigation
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      cvData.value = arguments['cvData'];
      pdfPath.value = arguments['pdfPath'] ?? '';
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  
  // Open PDF file with default app
  Future<void> openPDF() async {
    try {
      if (pdfPath.value.isNotEmpty) {
        await CVTemplateService.openPDF(pdfPath.value);
      } else {
        Get.snackbar(
          'Error',
          'File PDF tidak ditemukan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Share PDF file
  Future<void> sharePDF() async {
    try {
      if (pdfPath.value.isNotEmpty) {
        await CVTemplateService.sharePDF(pdfPath.value);
      } else {
        Get.snackbar(
          'Error',
          'File PDF tidak ditemukan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Copy file path to clipboard
  Future<void> copyPathToClipboard() async {
    try {
      if (pdfPath.value.isNotEmpty) {
        await Clipboard.setData(ClipboardData(text: pdfPath.value));
        Get.snackbar(
          'Berhasil',
          'Path file berhasil disalin ke clipboard',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyalin path: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Navigate back to CV Assistant
  void backToCvAssistant() {
    Get.back();
  }
  
  // Generate new template
  void generateNewTemplate() {
    Get.back();
  }
}
