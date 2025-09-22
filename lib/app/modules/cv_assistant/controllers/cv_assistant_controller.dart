import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/cloudinary_service.dart';

class CvAssistantController extends GetxController {
  // Observable variables
  final isUploading = false.obs;
  final uploadedFile = Rxn<Map<String, dynamic>>();
  final uploadProgress = 0.0.obs;
  
  // Services
  final CloudinaryService _cloudinaryService = CloudinaryService.instance;
  
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
    super.onClose();
  }

  // Pick and upload CV file
  Future<void> pickAndUploadFile() async {
    try {
      // Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        isUploading.value = true;
        uploadProgress.value = 0.0;
        
        File file = File(result.files.single.path!);
        
        // Validate file size (max 5MB)
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        
        if (fileSizeInMB > 5) {
          Get.snackbar(
            'Error',
            'File terlalu besar. Maksimal 5MB.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        
        // Simulate upload progress
        for (int i = 0; i <= 50; i += 10) {
          uploadProgress.value = i / 100;
          await Future.delayed(const Duration(milliseconds: 100));
        }
        
        // Upload to Cloudinary
        Map<String, dynamic>? uploadResult = await _cloudinaryService.uploadCVFile(file);
        
        if (uploadResult != null) {
          uploadProgress.value = 1.0;
          uploadedFile.value = uploadResult;
          
          Get.snackbar(
            'Berhasil',
            'File CV berhasil diupload!',
            snackPosition: SnackPosition.BOTTOM,
          );
          
          // Navigate to CV display page after short delay
          await Future.delayed(const Duration(milliseconds: 500));
          Get.toNamed('/cv-display', arguments: uploadResult);
        } else {
          Get.snackbar(
            'Error',
            'Gagal mengupload file. Silakan coba lagi.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }
  
  // Navigate to scan/display page
  void navigateToScanPage() {
    if (uploadedFile.value != null) {
      Get.toNamed('/cv-display', arguments: uploadedFile.value);
    } else {
      Get.snackbar(
        'Info',
        'Silakan upload file CV terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
