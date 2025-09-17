class InterviewSession {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String status; // 'ongoing', 'completed', 'cancelled'
  final List<ChatMessage> messages;
  final InterviewFeedback? feedback;
  final Map<String, dynamic>? settings; // difficulty, style, etc.

  InterviewSession({
    required this.id,
    required this.userId,
    required this.createdAt,
    this.completedAt,
    required this.status,
    required this.messages,
    this.feedback,
    this.settings,
  });

  factory InterviewSession.fromJson(Map<String, dynamic> json) {
    return InterviewSession(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      status: json['status'] ?? 'ongoing',
      messages: (json['messages'] as List<dynamic>?)
          ?.map((msg) => ChatMessage.fromJson(msg))
          .toList() ?? [],
      feedback: json['feedback'] != null 
          ? InterviewFeedback.fromJson(json['feedback']) 
          : null,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'status': status,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'feedback': feedback?.toJson(),
      'settings': settings,
    };
  }

  // ✅ Presisi duration calculation (round to nearest minute)
  int get durationMinutes {
    if (completedAt == null) return 0;
    final totalSeconds = completedAt!.difference(createdAt).inSeconds;
    return (totalSeconds / 60).round(); // Round ke menit terdekat
  }
  
  // ✅ Clean format tanpa detik
  String get formattedDuration {
    final minutes = durationMinutes;
    
    if (minutes == 0) return '0 menit';
    if (minutes < 60) return '$minutes menit';
    
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    return remainingMinutes == 0 
        ? '$hours jam' 
        : '$hours jam $remainingMinutes menit';
  }

  InterviewSession copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    DateTime? completedAt,
    String? status,
    List<ChatMessage>? messages,
    InterviewFeedback? feedback,
    Map<String, dynamic>? settings,
  }) {
    return InterviewSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      messages: messages ?? this.messages,
      feedback: feedback ?? this.feedback,
      settings: settings ?? this.settings,
    );
  }
}

class ChatMessage {
  final String id;
  final String type; // 'user' or 'ai'
  final String content;
  final DateTime timestamp;
  final String? originalSpeechText; // For user messages from speech-to-text
  final double? speechConfidence; // Confidence score from speech recognition

  ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.originalSpeechText,
    this.speechConfidence,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      type: json['type'] ?? 'user',
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      originalSpeechText: json['originalSpeechText'],
      speechConfidence: json['speechConfidence']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'originalSpeechText': originalSpeechText,
      'speechConfidence': speechConfidence,
    };
  }
}

class InterviewFeedback {
  final String id;
  final int overallScore; // 0-100
  final Map<String, int> detailedScores; // e.g., {'fluency': 80, 'confidence': 70}
  final List<String> strengths;
  final List<String> improvements;
  final Map<String, double> performanceBreakdown; // For pie chart
  final DateTime generatedAt;
  final String? detailedAnalysis; // AI-generated detailed analysis
  final List<String>? recommendedActions; // AI-generated action items

  InterviewFeedback({
    required this.id,
    required this.overallScore,
    required this.detailedScores,
    required this.strengths,
    required this.improvements,
    required this.performanceBreakdown,
    required this.generatedAt,
    this.detailedAnalysis,
    this.recommendedActions,
  });

  factory InterviewFeedback.fromJson(Map<String, dynamic> json) {
    return InterviewFeedback(
      id: json['id'] ?? '',
      overallScore: json['overallScore'] ?? 0,
      detailedScores: Map<String, int>.from(json['detailedScores'] ?? {}),
      strengths: List<String>.from(json['strengths'] ?? []),
      improvements: List<String>.from(json['improvements'] ?? []),
      performanceBreakdown: Map<String, double>.from(json['performanceBreakdown'] ?? {}),
      generatedAt: DateTime.parse(json['generatedAt']),
      detailedAnalysis: json['detailedAnalysis'],
      recommendedActions: json['recommendedActions'] != null 
          ? List<String>.from(json['recommendedActions']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'overallScore': overallScore,
      'detailedScores': detailedScores,
      'strengths': strengths,
      'improvements': improvements,
      'performanceBreakdown': performanceBreakdown,
      'generatedAt': generatedAt.toIso8601String(),
      'detailedAnalysis': detailedAnalysis,
      'recommendedActions': recommendedActions,
    };
  }
}
