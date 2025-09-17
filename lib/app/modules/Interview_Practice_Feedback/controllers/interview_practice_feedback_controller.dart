import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/interview_storage_service.dart';

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
  final detailedAnalysis = ''.obs;
  final recommendedActions = <String>[].obs;

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
      
      // Try to load real data from Firebase
      final session = await InterviewStorageService.getInterviewSession(sessionId.value);
      
      if (session != null && session.feedback != null) {
        // Load real feedback data
        _loadRealFeedbackData(session.feedback!);
        print('✅ Loaded real feedback data for session: ${sessionId.value}');
      } else {
        // Fallback to sample data if no real data available
        print('📝 No feedback found for session ${sessionId.value}, using sample data');
        _loadSampleData();
      }
    } catch (e) {
      print('❌ Error loading feedback data: $e');
      _loadSampleData();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load real feedback data from Firebase
  void _loadRealFeedbackData(dynamic feedback) {
    // Handle both InterviewFeedback object and Map
    Map<String, dynamic> feedbackData;
    
    if (feedback is Map<String, dynamic>) {
      feedbackData = feedback;
    } else {
      // Assume it's InterviewFeedback object with toJson method
      feedbackData = feedback.toJson();
    }
    
    overallScore.value = feedbackData['overallScore'] ?? 75;
    
    // Convert detailed scores to performance breakdown
    final breakdown = feedbackData['performanceBreakdown'] as Map<String, dynamic>?;
    if (breakdown != null) {
      performanceData.value = Map<String, double>.from(breakdown);
    } else {
      performanceData.value = {
        'Good': 60.0,
        'Needs Improvement': 40.0,
      };
    }
    
    detailedScores.value = Map<String, int>.from(feedbackData['detailedScores'] ?? {
      'Komunikasi': 75,
      'Kepercayaan Diri': 70,
      'Struktur Jawaban': 75,
      'Relevansi': 80,
    });
    
    strengths.value = List<String>.from(feedbackData['strengths'] ?? [
      'Menunjukkan antusiasme dalam menjawab pertanyaan',
      'Mampu memberikan contoh yang relevan',
    ]);
    
    improvements.value = List<String>.from(feedbackData['improvements'] ?? [
      'Tingkatkan kepercayaan diri saat berbicara',
      'Berikan detail lebih spesifik dalam jawaban',
    ]);
    
    // Load AI-specific fields
    detailedAnalysis.value = feedbackData['detailedAnalysis'] ?? '';
    recommendedActions.value = List<String>.from(feedbackData['recommendedActions'] ?? []);
    
    feedbackText.value = detailedAnalysis.value.isNotEmpty 
        ? detailedAnalysis.value 
        : 'Feedback berhasil dimuat dari AI analysis.';
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
    
    detailedAnalysis.value = 'Kandidat menunjukkan kemampuan komunikasi yang baik dengan struktur jawaban yang terorganisir. Namun, masih perlu meningkatkan kepercayaan diri dan mengurangi penggunaan filler words untuk mencapai performa yang optimal.';
    
    recommendedActions.value = [
      'Latih presentasi diri di depan cermin untuk meningkatkan kepercayaan diri',
      'Pelajari teknik STAR (Situation, Task, Action, Result) untuk menjawab pertanyaan behavioral',
      'Berlatih berbicara tanpa filler words dengan merekam diri sendiri',
    ];
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
