import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/interview_session.dart';
import 'interview_groq_service.dart';

class InterviewStorageService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static const String _interviewCollection = 'interview_sessions';
  
  /// Create a new interview session
  static Future<String> createInterviewSession({
    Map<String, dynamic>? settings,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ User not authenticated. Please login first.');
        throw Exception('User not authenticated. Please login first.');
      }
      
      print('✅ User authenticated: ${user.uid}');
      
      final sessionId = _firestore.collection(_interviewCollection).doc().id;
      
      final session = InterviewSession(
        id: sessionId,
        userId: user.uid,
        createdAt: DateTime.now(),
        status: 'ongoing',
        messages: [],
        settings: settings,
      );
      
      await _firestore
          .collection(_interviewCollection)
          .doc(sessionId)
          .set(session.toJson());
      
      print('✅ Interview session created: $sessionId');
      return sessionId;
    } catch (e) {
      print('❌ Error creating interview session: $e');
      throw Exception('Failed to create interview session: $e');
    }
  }
  
  /// Add a user message (from speech-to-text) to the session
  static Future<void> addUserMessage({
    required String sessionId,
    required String content,
    String? originalSpeechText,
    double? speechConfidence,
  }) async {
    try {
      final messageId = _firestore.collection(_interviewCollection).doc().id;
      
      final message = ChatMessage(
        id: messageId,
        type: 'user',
        content: content,
        timestamp: DateTime.now(),
        originalSpeechText: originalSpeechText,
        speechConfidence: speechConfidence,
      );
      
      await _firestore
          .collection(_interviewCollection)
          .doc(sessionId)
          .update({
        'messages': FieldValue.arrayUnion([message.toJson()]),
      });
      
      print('✅ User message added to session: $sessionId');
    } catch (e) {
      print('❌ Error adding user message: $e');
      throw Exception('Failed to add user message: $e');
    }
  }
  
  /// Add an AI response to the session
  static Future<void> addAIMessage({
    required String sessionId,
    required String content,
  }) async {
    try {
      final messageId = _firestore.collection(_interviewCollection).doc().id;
      
      final message = ChatMessage(
        id: messageId,
        type: 'ai',
        content: content,
        timestamp: DateTime.now(),
      );
      
      await _firestore
          .collection(_interviewCollection)
          .doc(sessionId)
          .update({
        'messages': FieldValue.arrayUnion([message.toJson()]),
      });
      
      print('✅ AI message added to session: $sessionId');
    } catch (e) {
      print('❌ Error adding AI message: $e');
      throw Exception('Failed to add AI message: $e');
    }
  }
  
  /// Complete the interview session and save feedback
  static Future<void> completeInterviewSession({
    required String sessionId,
    required InterviewFeedback feedback,
  }) async {
    try {
      await _firestore
          .collection(_interviewCollection)
          .doc(sessionId)
          .update({
        'status': 'completed',
        'feedback': feedback.toJson(),
        'completedAt': DateTime.now().toIso8601String(), // ✅ Set completion timestamp
      });
      
      print('✅ Interview session completed: $sessionId');
    } catch (e) {
      print('❌ Error completing interview session: $e');
      throw Exception('Failed to complete interview session: $e');
    }
  }
  
  /// Cancel an ongoing interview session
  static Future<void> cancelInterviewSession(String sessionId) async {
    try {
      await _firestore
          .collection(_interviewCollection)
          .doc(sessionId)
          .update({
        'status': 'cancelled',
        'completedAt': DateTime.now().toIso8601String(),
      });
      
      print('✅ Interview session cancelled: $sessionId');
    } catch (e) {
      print('❌ Error cancelling interview session: $e');
      throw Exception('Failed to cancel interview session: $e');
    }
  }
  
  /// Get a specific interview session
  static Future<InterviewSession?> getInterviewSession(String sessionId) async {
    try {
      final doc = await _firestore
          .collection(_interviewCollection)
          .doc(sessionId)
          .get();
      
      if (!doc.exists) return null;
      
      return InterviewSession.fromJson(doc.data()!);
    } catch (e) {
      print('❌ Error getting interview session: $e');
      throw Exception('Failed to get interview session: $e');
    }
  }
  
  /// Get all interview sessions for current user
  static Future<List<InterviewSession>> getUserInterviewSessions() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      final querySnapshot = await _firestore
          .collection(_interviewCollection)
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => InterviewSession.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error getting user interview sessions: $e');
      throw Exception('Failed to get user interview sessions: $e');
    }
  }
  
  /// Get completed interview sessions with feedback
  static Future<List<InterviewSession>> getCompletedInterviewSessions() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      final querySnapshot = await _firestore
          .collection(_interviewCollection)
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'completed')
          .orderBy('completedAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => InterviewSession.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error getting completed interview sessions: $e');
      throw Exception('Failed to get completed interview sessions: $e');
    }
  }
  
  /// Delete an interview session
  static Future<void> deleteInterviewSession(String sessionId) async {
    try {
      await _firestore
          .collection(_interviewCollection)
          .doc(sessionId)
          .delete();
      
      print('✅ Interview session deleted: $sessionId');
    } catch (e) {
      print('❌ Error deleting interview session: $e');
      throw Exception('Failed to delete interview session: $e');
    }
  }
  
  /// Generate AI-powered feedback using Groq API
  static Future<InterviewFeedback> generateAIFeedback({
    required String sessionId,
    required List<ChatMessage> messages,
    required String difficulty,
    required String style,
    String? additionalPrompt,
  }) async {
    try {
      print('🤖 Generating AI feedback for session: $sessionId');
      
      // Convert ChatMessage to conversation history format
      List<Map<String, String>> conversationHistory = messages.map((message) {
        return {
          'role': message.type == 'user' ? 'user' : 'assistant',
          'content': message.content,
        };
      }).toList();
      
      // Generate feedback using Groq API
      final aiFeeback = await InterviewGroqService.generateInterviewFeedback(
        conversationHistory: conversationHistory,
        difficulty: difficulty,
        style: style,
        additionalPrompt: additionalPrompt,
      );
      
      final feedbackId = _firestore.collection(_interviewCollection).doc().id;
      
      print('✅ AI feedback generated successfully');
      
      return InterviewFeedback(
        id: feedbackId,
        overallScore: aiFeeback['overallScore'] ?? 75,
        detailedScores: Map<String, int>.from(aiFeeback['detailedScores'] ?? {
          'fluency': 75,
          'confidence': 75,
          'structure': 75,
          'content': 75,
          'communication': 75,
        }),
        strengths: List<String>.from(aiFeeback['strengths'] ?? [
          'Menunjukkan antusiasme dalam menjawab pertanyaan',
          'Mampu memberikan contoh yang relevan',
          'Komunikasi cukup jelas dan terstruktur'
        ]),
        improvements: List<String>.from(aiFeeback['improvements'] ?? [
          'Tingkatkan kepercayaan diri saat berbicara',
          'Berikan detail lebih spesifik dalam jawaban',
          'Latih struktur jawaban yang lebih sistematis'
        ]),
        performanceBreakdown: Map<String, double>.from(aiFeeback['performanceBreakdown'] ?? {
          'Excellent': 30.0,
          'Good': 45.0,
          'Needs Improvement': 25.0,
        }),
        generatedAt: DateTime.now(),
        // Add new AI-specific fields
        detailedAnalysis: aiFeeback['detailedAnalysis'],
        recommendedActions: List<String>.from(aiFeeback['recommendedActions'] ?? []),
      );
      
    } catch (e) {
      print('❌ Error generating AI feedback: $e');
      // Fallback to basic feedback if AI generation fails
      return generateSampleFeedback(sessionId, messages);
    }
  }

  /// Generate sample feedback (fallback when AI fails)
  static InterviewFeedback generateSampleFeedback(String sessionId, List<ChatMessage> messages) {
    // Fallback feedback generation when AI is not available
    final feedbackId = _firestore.collection(_interviewCollection).doc().id;
    
    return InterviewFeedback(
      id: feedbackId,
      overallScore: 75,
      detailedScores: {
        'fluency': 80,
        'confidence': 70,
        'structure': 75,
        'content': 75,
        'communication': 75,
      },
      strengths: [
        'Durasi berbicara sudah optimal dan tidak terlalu panjang',
        'Struktur jawaban cukup terorganisir dengan baik',
        'Penggunaan bahasa formal sudah tepat',
      ],
      improvements: [
        'Tingkatkan kepercayaan diri dengan berlatih lebih sering',
        'Gunakan lebih banyak power words untuk memperkuat jawaban',
        'Latih struktur jawaban yang lebih sistematis'
      ],
      performanceBreakdown: {
        'Excellent': 35.0,
        'Good': 40.0,
        'Needs Improvement': 25.0,
      },
      generatedAt: DateTime.now(),
    );
  }
}
