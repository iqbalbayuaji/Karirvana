import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../career_assistant/models/chat_message.dart';
import '../../../services/interview_storage_service.dart';

class InterviewPracticeHistoryChatController extends GetxController {
  // Chat history data
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = true.obs;
  final ScrollController scrollController = ScrollController();
  
  // Interview session info
  final RxString sessionTitle = ''.obs;
  final RxString sessionDate = ''.obs;
  final RxString sessionId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _loadChatHistory() {
    // Get session data from arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    
    if (arguments != null) {
      sessionId.value = arguments['sessionId'] ?? '';
      sessionTitle.value = arguments['sessionTitle'] ?? 'Interview Practice';
      sessionDate.value = arguments['sessionDate'] ?? '';
      
      // Load conversation history from the interview practice chat controller
      // This would typically come from Firebase or local storage
      _loadMessagesFromSession();
    } else {
      // Load sample data for demonstration
      _loadSampleData();
    }
  }

  Future<void> _loadMessagesFromSession() async {
    try {
      if (sessionId.value.isNotEmpty) {
        // Load actual session data from Firebase
        final session = await InterviewStorageService.getInterviewSession(sessionId.value);
        
        if (session != null && session.messages.isNotEmpty) {
          // Convert Firebase messages to ChatMessage format
          final chatMessages = session.messages.map((message) {
            return ChatMessage(
              content: message.content,
              isUser: message.type == 'user',
              timestamp: message.timestamp,
            );
          }).toList();
          
          messages.addAll(chatMessages);
          isLoading.value = false;
          
          // Auto scroll to bottom after loading
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          
          return;
        }
      }
      
      // Fallback to sample data if no session found or no messages
      _loadSampleData();
    } catch (e) {
      print('Error loading session messages: $e');
      // Fallback to sample data on error
      _loadSampleData();
    }
  }

  void _loadSampleData() {
    // Sample interview conversation history
    final sampleMessages = [
      ChatMessage.bot("Halo! Selamat datang di sesi interview practice. Saya akan berperan sebagai HR interviewer. Mari kita mulai dengan perkenalan diri. Bisa Anda ceritakan tentang diri Anda?"),
      ChatMessage.user("Halo, nama saya John Doe. Saya adalah seorang software developer dengan pengalaman 3 tahun di bidang mobile development, khususnya Flutter dan React Native."),
      ChatMessage.bot("Terima kasih atas perkenalan Anda, John. Pengalaman 3 tahun di mobile development cukup menarik. Bisa Anda ceritakan tentang proyek terbesar yang pernah Anda kerjakan?"),
      ChatMessage.user("Proyek terbesar saya adalah mengembangkan aplikasi e-commerce untuk sebuah startup. Aplikasi ini memiliki fitur lengkap seperti payment gateway, real-time chat, dan push notification. Saya bertanggung jawab untuk seluruh development dari frontend hingga integrasi API."),
      ChatMessage.bot("Impressive! Dalam proyek e-commerce tersebut, tantangan teknis apa yang paling sulit Anda hadapi dan bagaimana cara Anda mengatasinya?"),
      ChatMessage.user("Tantangan terbesar adalah mengoptimalkan performa aplikasi ketika menangani data produk yang sangat banyak. Saya mengatasi ini dengan implementasi lazy loading, caching strategy, dan pagination untuk mengurangi memory usage."),
      ChatMessage.bot("Solusi yang sangat baik! Sekarang, mengapa Anda tertarik untuk bergabung dengan perusahaan kami?"),
      ChatMessage.user("Saya tertarik karena perusahaan ini memiliki visi yang sejalan dengan passion saya dalam teknologi. Selain itu, saya melihat banyak opportunity untuk growth dan learning di sini, terutama dalam mengembangkan produk yang berdampak besar."),
    ];

    messages.addAll(sampleMessages);
    isLoading.value = false;
    
    // Auto scroll to bottom after loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
