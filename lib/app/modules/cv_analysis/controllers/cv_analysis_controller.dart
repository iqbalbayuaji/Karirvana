import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/pdf_analysis_service.dart';

class CvAnalysisController extends GetxController {
  // Observable variables
  final isExtracting = false.obs;
  final isAnalyzing = false.obs;
  final extractedText = ''.obs;
  final analysisResult = Rxn<Map<String, dynamic>>();
  final hasError = false.obs;
  final errorMessage = ''.obs;
  
  // File data from arguments
  File? selectedFile;
  String fileName = '';
  String fileType = '';
  int fileSize = 0;
  
  @override
  void onInit() {
    super.onInit();
    // Get file data from arguments
    if (Get.arguments != null) {
      Map<String, dynamic> fileData = Get.arguments as Map<String, dynamic>;
      fileName = fileData['fileName'] ?? 'Unknown File';
      fileType = fileData['fileType'] ?? '';
      fileSize = fileData['fileSize'] ?? 0;
      
      // Create File object from path
      String filePath = fileData['filePath'] ?? '';
      if (filePath.isNotEmpty) {
        selectedFile = File(filePath);
        // Start analysis automatically
        startAnalysis();
      } else {
        _setError('File path not found');
      }
    } else {
      _setError('No file data received');
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
  
  /// Start the complete CV analysis process
  Future<void> startAnalysis() async {
    if (selectedFile == null) {
      _setError('No file selected');
      return;
    }
    
    hasError.value = false;
    errorMessage.value = '';
    
    try {
      // Step 1: Extract text from PDF
      await _extractTextFromPDF();
      
      // Step 2: Analyze with Groq API
      await _analyzeWithGroq();
      
    } catch (e) {
      _setError('Analysis failed: ${e.toString()}');
    }
  }
  
  /// Extract text from PDF file
  Future<void> _extractTextFromPDF() async {
    try {
      isExtracting.value = true;
      
      String text = await PDFAnalysisService.extractTextFromPDF(selectedFile!);
      extractedText.value = text;
      
      if (text.trim().isEmpty) {
        throw Exception('No readable text found in PDF');
      }
      
    } catch (e) {
      throw Exception('Failed to extract text: ${e.toString()}');
    } finally {
      isExtracting.value = false;
    }
  }
  
  /// Analyze CV text with Groq API
  Future<void> _analyzeWithGroq() async {
    try {
      isAnalyzing.value = true;
      
      Map<String, dynamic> result = await PDFAnalysisService.analyzeCV(extractedText.value);
      analysisResult.value = result;
      
    } catch (e) {
      throw Exception('AI analysis failed: ${e.toString()}');
    } finally {
      isAnalyzing.value = false;
    }
  }
  
  /// Set error state
  void _setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
    isExtracting.value = false;
    isAnalyzing.value = false;
  }
  
  /// Retry analysis
  void retryAnalysis() {
    startAnalysis();
  }
  
  /// Navigate back to CV Assistant
  void goBack() {
    Get.back();
  }
  
  /// Navigate to home page
  void goToHome() {
    Get.offAllNamed('/home');
  }
  
  /// Share analysis results (placeholder)
  void shareResults() {
    Get.snackbar(
      'Info',
      'Fitur berbagi akan segera hadir!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
  
  /// Save analysis results (placeholder)
  void saveResults() {
    Get.snackbar(
      'Info',
      'Hasil analisis tersimpan!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  
  // Getters for formatted data
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
  
  bool get isProcessing => isExtracting.value || isAnalyzing.value;
  bool get isCompleted => analysisResult.value != null && !hasError.value;
  
  String get currentStatus {
    if (hasError.value) return 'Error';
    if (isExtracting.value) return 'Membaca PDF...';
    if (isAnalyzing.value) return 'Menganalisis dengan AI...';
    if (isCompleted) return 'Analisis Selesai';
    return 'Memulai analisis...';
  }
}
