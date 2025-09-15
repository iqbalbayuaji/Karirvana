import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterviewPracticeChatController extends GetxController with GetTickerProviderStateMixin {
  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> pulseAnimation;
  late Animation<double> rippleAnimation;

  // Speech and chat state
  final isListening = false.obs;
  final isAISpeaking = false.obs;
  final currentAIResponse = ''.obs;
  final previousAIResponse = ''.obs;
  final isInterviewActive = false.obs;
  final interviewQuestion = ''.obs;
  final responseCount = 0.obs;

  // Animation getters
  AnimationController get pulseController => _pulseController;
  AnimationController get rippleController => _rippleController;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startInterview();
  }

  void _initializeAnimations() {
    // Pulse animation for the main circle
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Ripple animation for listening state
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    // Start continuous pulse animation
    _pulseController.repeat(reverse: true);
  }

  void _startInterview() {
    isInterviewActive.value = true;
    currentAIResponse.value = "Halo! Saya HR Assistant. Mari kita mulai sesi interview. Perkenalkan diri Anda terlebih dahulu.";
    _simulateAISpeaking();
  }

  void startListening() {
    if (isAISpeaking.value) return;
    
    isListening.value = true;
    _rippleController.repeat();
    
    // Simulate speech recognition
    Future.delayed(const Duration(seconds: 3), () {
      stopListening();
      _processUserResponse();
    });
  }

  void stopListening() {
    isListening.value = false;
    _rippleController.stop();
    _rippleController.reset();
  }

  void _processUserResponse() {
    // Simulate AI processing and generate new response
    Future.delayed(const Duration(milliseconds: 500), () {
      _generateAIResponse();
    });
  }

  void _generateAIResponse() {
    final responses = [
      "Terima kasih atas perkenalan Anda. Sekarang, ceritakan tentang pengalaman kerja Anda yang paling relevan dengan posisi ini.",
      "Bagus! Apa yang memotivasi Anda untuk melamar posisi di perusahaan kami?",
      "Menarik. Bagaimana Anda menangani situasi di bawah tekanan?",
      "Ceritakan tentang pencapaian terbesar Anda dalam karier.",
      "Apa rencana karier Anda dalam 5 tahun ke depan?",
      "Terima kasih atas jawaban yang luar biasa. Interview telah selesai!"
    ];
    
    // Store previous response before updating
    previousAIResponse.value = currentAIResponse.value;
    
    // Generate new response
    final randomResponse = responses[DateTime.now().millisecond % responses.length];
    currentAIResponse.value = randomResponse;
    
    // Increment response count to trigger animation
    responseCount.value++;
    
    _simulateAISpeaking();
  }

  void _simulateAISpeaking() {
    isAISpeaking.value = true;
    
    // Simulate text-to-speech duration
    Future.delayed(Duration(milliseconds: currentAIResponse.value.length * 50), () {
      isAISpeaking.value = false;
    });
  }

  void endInterview() {
    isInterviewActive.value = false;
    isListening.value = false;
    isAISpeaking.value = false;
    currentAIResponse.value = "Interview telah berakhir. Terima kasih!";
  }

  @override
  void onClose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.onClose();
  }
}
