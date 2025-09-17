import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/interview_session.dart';

class DebugInterviewService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// Debug: Print all interview sessions for current user
  static Future<void> printAllUserSessions() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        return;
      }
      
      print('🔍 Fetching interview sessions for user: ${user.uid}');
      
      final querySnapshot = await _firestore
          .collection('interview_sessions')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();
      
      print('📊 Found ${querySnapshot.docs.length} interview sessions');
      
      for (var doc in querySnapshot.docs) {
        final session = InterviewSession.fromJson(doc.data());
        print('');
        print('🎯 Session ID: ${session.id}');
        print('📅 Created: ${session.createdAt}');
        print('📊 Status: ${session.status}');
        print('💬 Messages: ${session.messages.length}');
        print('⚙️ Settings: ${session.settings}');
        
        // Print messages
        for (int i = 0; i < session.messages.length; i++) {
          final msg = session.messages[i];
          print('  ${i + 1}. [${msg.type.toUpperCase()}] ${msg.content.substring(0, msg.content.length > 50 ? 50 : msg.content.length)}${msg.content.length > 50 ? "..." : ""}');
        }
        
        if (session.feedback != null) {
          print('📈 Feedback Score: ${session.feedback!.overallScore}');
        }
        print('─' * 50);
      }
    } catch (e) {
      print('❌ Error fetching sessions: $e');
    }
  }
  
  /// Debug: Print latest session details
  static Future<void> printLatestSession() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        return;
      }
      
      final querySnapshot = await _firestore
          .collection('interview_sessions')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        print('📭 No interview sessions found');
        return;
      }
      
      final session = InterviewSession.fromJson(querySnapshot.docs.first.data());
      
      print('🎯 LATEST SESSION DETAILS:');
      print('ID: ${session.id}');
      print('Created: ${session.createdAt}');
      print('Status: ${session.status}');
      print('Messages Count: ${session.messages.length}');
      print('');
      print('💬 CONVERSATION:');
      
      for (int i = 0; i < session.messages.length; i++) {
        final msg = session.messages[i];
        final speaker = msg.type == 'user' ? '👤 USER' : '🤖 AI';
        print('$speaker: ${msg.content}');
        if (msg.originalSpeechText != null) {
          print('   🎤 Speech: ${msg.originalSpeechText}');
          print('   📊 Confidence: ${msg.speechConfidence}');
        }
        print('');
      }
      
      if (session.feedback != null) {
        print('📈 FEEDBACK:');
        print('Overall Score: ${session.feedback!.overallScore}');
        print('Strengths: ${session.feedback!.strengths}');
        print('Improvements: ${session.feedback!.improvements}');
      }
    } catch (e) {
      print('❌ Error: $e');
    }
  }
  
  /// Debug: Count total sessions
  static Future<void> printSessionCount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        return;
      }
      
      final querySnapshot = await _firestore
          .collection('interview_sessions')
          .where('userId', isEqualTo: user.uid)
          .get();
      
      print('📊 Total interview sessions: ${querySnapshot.docs.length}');
      
      final completed = querySnapshot.docs.where((doc) => doc.data()['status'] == 'completed').length;
      final ongoing = querySnapshot.docs.where((doc) => doc.data()['status'] == 'ongoing').length;
      
      print('✅ Completed: $completed');
      print('⏳ Ongoing: $ongoing');
    } catch (e) {
      print('❌ Error: $e');
    }
  }
}
