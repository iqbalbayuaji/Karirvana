class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to JSON for Groq API
  Map<String, dynamic> toGroqMessage() {
    return {
      'role': isUser ? 'user' : 'assistant',
      'content': content,
    };
  }

  // Create from Groq API response
  factory ChatMessage.fromGroqResponse(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'] ?? '',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  // Create user message
  factory ChatMessage.user(String content) {
    return ChatMessage(
      content: content,
      isUser: true,
    );
  }

  // Create bot message
  factory ChatMessage.bot(String content) {
    return ChatMessage(
      content: content,
      isUser: false,
    );
  }
}
