import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterviewPracticeFeedbackController extends GetxController {
  // Reactive variables for feedback data
  final isLoading = true.obs;
  final sessionId = ''.obs;
  final overallScore = 0.obs;
  final performanceData = <String, double>{}.obs;
  final detailedScores = <String, int>{}.obs;
  final strengths = <String>[].obs;
  final improvements = <String>[].obs;
  final feedbackText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get session ID from route arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['sessionId'] != null) {
      sessionId.value = args['sessionId'];
      loadFeedbackData();
    }
  }

  /// Load feedback data from Firebase
  Future<void> loadFeedbackData() async {
    try {
      isLoading.value = true;
      
      // For now, use sample data until Firebase integration is complete
      _loadSampleData();
    } catch (e) {
      print('Error loading feedback data: $e');
      _loadSampleData();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load sample data for testing
  void _loadSampleData() {
    overallScore.value = 75;
    
    performanceData.value = {
      'Good': 40.0,
      'Needs Improvement': 25.0,
    };
    
    detailedScores.value = {
      'Komunikasi': 80,
      'Kepercayaan Diri': 70,
      'Struktur Jawaban': 75,
      'Relevansi': 85,
    };
    
    strengths.value = [
      'Durasi berbicara sudah optimal dan tidak terlalu panjang',
      'Struktur jawaban cukup terorganisir dengan baik',
      'Penggunaan bahasa formal sudah tepat',
    ];
    
    improvements.value = [
      'Tingkatkan kepercayaan diri dengan berlatih lebih sering',
      'Gunakan lebih banyak power words untuk memperkuat jawaban',
      'Kurangi penggunaan filler words seperti "ehm", "anu"',
    ];
    
    feedbackText.value = 'Secara keseluruhan, performa interview Anda cukup baik dengan beberapa area yang perlu diperbaiki.';
  }

  /// Get color for performance category
  List<Color> getPerformanceColors() {
    return [
      const Color(0xFF6366F1), // Primary color
      const Color(0xFFE0E7FF), // Primary container
    ];
  }

  /// Get color for detailed score bars
  Color getScoreColor(int score) {
    if (score >= 80) return Colors.green.shade400;
    if (score >= 60) return Colors.orange.shade400;
    return Colors.red.shade400;
  }
}
