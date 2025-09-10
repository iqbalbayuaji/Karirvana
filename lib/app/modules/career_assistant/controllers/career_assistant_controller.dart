import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../../../services/groq_service.dart';
import '../../../services/speech_service.dart';

class CareerAssistantController extends GetxController {
  // View state management
  final RxBool isWelcomeView = true.obs;
  
  // Chat functionality
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Speech recognition functionality
  final RxBool isListening = false.obs;
  final RxBool isSpeechAvailable = false.obs;
  final RxString partialSpeechResult = ''.obs;

  // Quick action topics
  final List<String> quickActions = [
    '💼 Panduan Karir',
    '📄 Review CV',
    '🎯 Interview Tips',
    '📊 Skill Assessment',
    '💰 Negosiasi Gaji',
    '🚀 Career Switch',
  ];

  @override
  void onInit() {
    super.onInit();
    // Don't initialize chat on startup, only when transitioning to chat view
    _initializeSpeech();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _initializeChat() {
    // No welcome message - start with empty chat
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Transition to chat view if this is the first message
    if (isWelcomeView.value) {
      isWelcomeView.value = false;
      _initializeChat();
    }

    // Add user message
    final userMessage = ChatMessage.user(text.trim());
    messages.add(userMessage);
    messageController.clear();

    // Show typing indicator
    isTyping.value = true;
    _scrollToBottom();

    try {
      // Get response from Groq API
      final response = await GroqService.sendMessage(messages.toList());
      
      // Add bot response
      messages.add(ChatMessage.bot(response));
    } catch (e) {
      // Add error message
      messages.add(ChatMessage.bot(
        'Maaf, terjadi kesalahan saat memproses pesan Anda. Silakan coba lagi.'
      ));
    } finally {
      isTyping.value = false;
      _scrollToBottom();
    }
  }

  void sendQuickAction(String action) {
    String message = '';
    
    switch (action) {
      case '💼 Panduan Karir':
        message = 'Saya ingin mendapatkan panduan pengembangan karir. Bisa bantu saya?';
        break;
      case '📄 Review CV':
        message = 'Saya ingin tips untuk membuat CV yang menarik. Apa saja yang harus diperhatikan?';
        break;
      case '🎯 Interview Tips':
        message = 'Saya akan menghadapi interview kerja. Bisa berikan tips untuk sukses interview?';
        break;
      case '📊 Skill Assessment':
        message = 'Bagaimana cara menilai skill dan kompetensi saya untuk karir yang diinginkan?';
        break;
      case '💰 Negosiasi Gaji':
        message = 'Saya ingin belajar cara negosiasi gaji yang efektif. Bisa bantu?';
        break;
      case '🚀 Career Switch':
        message = 'Saya ingin berganti karir. Apa langkah-langkah yang harus saya lakukan?';
        break;
      default:
        message = action;
    }
    
    sendMessage(message);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void clearChat() {
    messages.clear();
    _initializeChat();
  }

  void backToWelcome() {
    isWelcomeView.value = true;
    messages.clear();
    messageController.clear();
  }

  // Initialize speech recognition
  Future<void> _initializeSpeech() async {
    try {
      final available = await SpeechService.initialize();
      isSpeechAvailable.value = available;
    } catch (e) {
      print('Error initializing speech: $e');
      isSpeechAvailable.value = false;
    }
  }

  // Start speech recognition
  Future<void> startListening() async {
    if (!isSpeechAvailable.value) {
      await _initializeSpeech();
    }

    if (isSpeechAvailable.value && !isListening.value) {
      isListening.value = true;
      partialSpeechResult.value = '';

      await SpeechService.startListening(
        onResult: (result) {
          isListening.value = false;
          partialSpeechResult.value = '';
          if (result.isNotEmpty) {
            messageController.text = result;
            sendMessage(result);
          }
        },
        onPartialResult: (partialResult) {
          partialSpeechResult.value = partialResult;
        },
      );
    }
  }

  // Stop speech recognition
  Future<void> stopListening() async {
    if (isListening.value) {
      isListening.value = false;
      partialSpeechResult.value = '';
      await SpeechService.stopListening();
    }
  }

  // Toggle speech recognition
  Future<void> toggleListening() async {
    if (isListening.value) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  // Test connection to Groq API
  Future<bool> testConnection() async {
    isLoading.value = true;
    try {
      final result = await GroqService.testConnection();
      return result;
    } finally {
      isLoading.value = false;
    }
  }
}
