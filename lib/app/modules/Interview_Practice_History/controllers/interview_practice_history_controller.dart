import 'package:get/get.dart';
import '../../../models/interview_session.dart';
import '../../../services/interview_storage_service.dart';

class InterviewPracticeHistoryController extends GetxController {
  // Reactive variables
  final isLoading = true.obs;
  final interviewSessions = <InterviewSession>[].obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInterviewHistory();
  }

  /// Load interview history from Firebase
  Future<void> loadInterviewHistory() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      print('📚 Loading interview history...');
      
      // Get completed interview sessions from Firebase
      final sessions = await InterviewStorageService.getCompletedInterviewSessions();
      
      interviewSessions.value = sessions;
      
      print('✅ Loaded ${sessions.length} interview sessions');
      
      // If no sessions found, it's not an error - just empty state
      if (sessions.isEmpty) {
        print('📝 No completed interview sessions found');
      }
      
    } catch (e) {
      print('❌ Error loading interview history: $e');
      hasError.value = true;
      errorMessage.value = 'Gagal memuat riwayat interview. Silakan coba lagi.';
      interviewSessions.value = []; // Clear any existing data
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh interview history
  Future<void> refreshHistory() async {
    await loadInterviewHistory();
  }

  /// Delete interview session
  Future<void> deleteInterviewSession(String sessionId) async {
    try {
      print('🗑️ Deleting interview session: $sessionId');
      
      await InterviewStorageService.deleteInterviewSession(sessionId);
      
      // Remove from local list
      interviewSessions.removeWhere((session) => session.id == sessionId);
      
      print('✅ Interview session deleted successfully');
      
      // Show success message
      Get.snackbar(
        'Berhasil',
        'Riwayat interview berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('❌ Error deleting interview session: $e');
      
      // Show error message
      Get.snackbar(
        'Error',
        'Gagal menghapus riwayat interview',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Format date for display
  String formatDate(DateTime date) {
    final months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  /// Get session title with fallback
  String getSessionTitle(InterviewSession session) {
    return session.title?.isNotEmpty == true 
        ? session.title! 
        : 'Interview Practice';
  }

  /// Get session score with fallback
  String getSessionScore(InterviewSession session) {
    return session.feedback?.overallScore.toString() ?? '0';
  }

  /// Navigate to feedback page
  void openFeedbackPage(String sessionId) {
    Get.toNamed('/interview-practice-feedback', arguments: {
      'sessionId': sessionId,
    });
  }

  /// Check if there are any sessions
  bool get hasSessions => interviewSessions.isNotEmpty;
}
