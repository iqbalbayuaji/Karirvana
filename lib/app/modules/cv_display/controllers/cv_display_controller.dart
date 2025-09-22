import 'package:get/get.dart';

class CvDisplayController extends GetxController {
  // File data from arguments
  final fileData = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Get file data from arguments
    if (Get.arguments != null) {
      fileData.value = Get.arguments as Map<String, dynamic>;
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
  
  // Get file info
  String get fileName => fileData.value?['fileName'] ?? 'Unknown File';
  String get fileType => fileData.value?['fileType'] ?? '';
  String get fileUrl => fileData.value?['url'] ?? '';
  int get fileSize => fileData.value?['fileSize'] ?? 0;
  String get uploadedAt => fileData.value?['uploadedAt'] ?? '';
  
  // Format file size
  String get formattedFileSize {
    if (fileSize == 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    int i = 0;
    double size = fileSize.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
  
  // Navigate back to CV Assistant
  void goBack() {
    Get.back();
  }
  
  // Start analysis (placeholder for future implementation)
  void startAnalysis() {
    Get.snackbar(
      'Info',
      'Fitur analisis CV akan segera hadir!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
