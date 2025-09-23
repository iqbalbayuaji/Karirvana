import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/pdf_analysis_service.dart';
import '../../../services/cv_template_service.dart';
import '../../../widgets/cv_template_popup.dart';

class CvAssistantController extends GetxController {
  // Observable variables
  final isUploading = false.obs;
  final uploadedFile = Rxn<Map<String, dynamic>>();
  final uploadProgress = 0.0.obs;
  
  // Template generation variables
  final isGeneratingTemplate = false.obs;
  final templatePromptController = TextEditingController();
  final generatedTemplate = Rxn<Map<String, dynamic>>();
  
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
    templatePromptController.dispose();
    super.onClose();
  }

  // Pick and process PDF file (UI unchanged, logic updated)
  Future<void> pickAndUploadFile() async {
    try {
      // Pick PDF file only
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Only PDF files
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        isUploading.value = true;
        uploadProgress.value = 0.0;
        
        File file = File(result.files.single.path!);
        
        // Validate PDF file
        try {
          await PDFAnalysisService.validatePDFFile(file);
        } catch (e) {
          Get.snackbar(
            'Error',
            e.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
        
        // Simulate "upload" progress for UI consistency
        for (int i = 0; i <= 100; i += 20) {
          uploadProgress.value = i / 100;
          await Future.delayed(const Duration(milliseconds: 200));
        }
        
        // Store file info (same structure as before for UI compatibility)
        int fileSizeInBytes = await file.length();
        uploadedFile.value = {
          'fileName': file.path.split('/').last,
          'fileType': 'pdf',
          'fileSize': fileSizeInBytes,
          'filePath': file.path, // Store local path instead of URL
          'uploadedAt': DateTime.now().toIso8601String(),
        };
        
        Get.snackbar(
          'Berhasil',
          'File PDF berhasil dipilih!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }
  
  // Navigate to CV analysis page
  void navigateToScanPage() {
    if (uploadedFile.value != null) {
      Get.toNamed('/cv-analysis', arguments: uploadedFile.value);
    } else {
      Get.snackbar(
        'Info',
        'Silakan pilih file PDF terlebih dahulu.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
  
  // Generate CV template using Groq API
  Future<void> generateCVTemplate() async {
    if (templatePromptController.text.trim().isEmpty) {
      Get.snackbar(
        'Info',
        'Silakan masukkan deskripsi untuk template CV Anda.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      isGeneratingTemplate.value = true;
      
      // Generate CV content using Groq API
      Map<String, dynamic> cvData = await CVTemplateService.generateCVContent(
        templatePromptController.text.trim()
      );
      
      generatedTemplate.value = cvData;
      
      // Generate PDF file
      File pdfFile = await CVTemplateService.generateCVPDF(cvData);
      
      // Show success dialog with download options
      CVTemplatePopup.show(pdfFile.path, cvData);
      
      // Clear the input
      templatePromptController.clear();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuat template CV: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isGeneratingTemplate.value = false;
    }
  }
}
