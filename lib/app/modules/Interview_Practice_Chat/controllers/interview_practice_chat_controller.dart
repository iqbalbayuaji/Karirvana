import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/speech_service.dart';
import '../../../services/interview_groq_service.dart';
import '../../../services/text_to_speech_service.dart';
import '../../../services/interview_storage_service.dart';
import '../../../services/debug_interview_service.dart';
import '../../Interview_Practice/controllers/interview_practice_controller.dart';

class InterviewPracticeChatController extends GetxController with GetTickerProviderStateMixin {
  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _scaleController;
  late Animation<double> pulseAnimation;
  late Animation<double> rippleAnimation;
  late Animation<double> scaleAnimation;

  // Speech and chat state
  final isListening = false.obs;
  final isAISpeaking = false.obs;
  final currentAIResponse = ''.obs;
  final previousAIResponse = ''.obs;
  final isInterviewActive = false.obs;
  final interviewQuestion = ''.obs;
  final responseCount = 0.obs;
  final isLoading = false.obs;
  final partialSpeechResult = ''.obs;
  final isSpeechAvailable = false.obs;

  // Conversation history
  final List<Map<String, String>> conversationHistory = [];

  // Interview session storage
  String? _currentSessionId;

  // Interview settings
  String _difficulty = 'Medium';
  String _style = 'Friendly';
  String? _additionalPrompts;

  // Animation getters
  AnimationController get pulseController => _pulseController;
  AnimationController get rippleController => _rippleController;
  AnimationController get scaleController => _scaleController;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _initializeServices();
    _loadInterviewSettings();
    
    // Start the interview automatically
    Future.delayed(const Duration(milliseconds: 500), () {
      _startInterview();
    });
  }

  Future<void> _initializeServices() async {
    try {
      print('Initializing speech recognition...');
      final speechAvailable = await SpeechService.initialize();
      isSpeechAvailable.value = speechAvailable;
      print('Speech recognition available: $speechAvailable');
    } catch (e) {
      print('Error initializing services: $e');
      isSpeechAvailable.value = false;
    }
  }

  void _loadInterviewSettings() {
    // Try to get settings from Interview Practice Setup
    try {
      final setupController = Get.find<InterviewPracticeController>();
      final settings = setupController.getInterviewSettings();
      _difficulty = settings['difficulty'] ?? 'Medium';
      _style = settings['style'] ?? 'Friendly';
      _additionalPrompts = settings['additionalPrompts'];
    } catch (e) {
      // Use default settings if setup controller not found
      print('Using default interview settings: $e');
    }
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

    // Scale animation for listening state
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Start continuous pulse animation
    _pulseController.repeat(reverse: true);
  }

  Future<void> _startInterview() async {
    isInterviewActive.value = true;
    
    try {
      // Create new interview session in Firebase
      _currentSessionId = await InterviewStorageService.createInterviewSession(
        settings: {
          'difficulty': _difficulty,
          'style': _style,
          'additionalPrompts': _additionalPrompts,
        },
      );
      
      // Get initial interview question from Groq API
      final response = await InterviewGroqService.startInterview(
        difficulty: _difficulty,
        style: _style,
        additionalPrompt: _additionalPrompts,
      );
      
      conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });
      
      // Save AI message to Firebase (async, non-blocking)
      if (_currentSessionId != null) {
        InterviewStorageService.addAIMessage(
          sessionId: _currentSessionId!,
          content: response,
        ).catchError((e) => print('Background save error: $e'));
      }
      
      await _processAIResponse(response);
    } catch (e) {
      print('Error starting interview: $e');
      currentAIResponse.value = "Halo! Saya HR Assistant. Mari kita mulai sesi interview. Perkenalkan diri Anda terlebih dahulu.";
      await _speakAIResponse(currentAIResponse.value);
    }
  }

  Future<void> startListening() async {
    if (isAISpeaking.value || isLoading.value) return;
    
    isListening.value = true;
    partialSpeechResult.value = '';
    _rippleController.repeat();
    _scaleController.forward();
    
    try {
      await SpeechService.startListening(
        onResult: (result) {
          _processUserSpeech(result);
        },
        onPartialResult: (partial) {
          partialSpeechResult.value = partial;
        },
      );
    } catch (e) {
      print('Error starting speech recognition: $e');
      stopListening();
    }
  }

  Future<void> stopListening() async {
    isListening.value = false;
    partialSpeechResult.value = '';
    _rippleController.stop();
    _rippleController.reset();
    _scaleController.reverse();
    
    try {
      await SpeechService.stopListening();
    } catch (e) {
      print('Error stopping speech recognition: $e');
    }
  }

  Future<void> _processUserSpeech(String userInput) async {
    if (userInput.trim().isEmpty) return;
    
    // Stop listening first
    await stopListening();
    
    // Ensure listening state is completely off before processing
    await Future.delayed(const Duration(milliseconds: 100));
    
    isLoading.value = true;
    
    try {
      // Add user message to conversation history
      conversationHistory.add({
        'role': 'user',
        'content': userInput,
      });
      
      // Save user message to Firebase (async, non-blocking)
      if (_currentSessionId != null) {
        InterviewStorageService.addUserMessage(
          sessionId: _currentSessionId!,
          content: userInput,
          originalSpeechText: userInput, // This is the speech-to-text result
          speechConfidence: 0.9, // You can get this from SpeechService if available
        ).catchError((e) => print('Background save error: $e'));
      }
      
      // Get AI response
      final response = await InterviewGroqService.generateResponse(
        conversationHistory: conversationHistory,
        difficulty: _difficulty,
        style: _style,
        additionalPrompt: _additionalPrompts,
      );
      
      // Add AI response to conversation history
      conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });
      
      // Save AI response to Firebase (async, non-blocking)
      if (_currentSessionId != null) {
        InterviewStorageService.addAIMessage(
          sessionId: _currentSessionId!,
          content: response,
        ).catchError((e) => print('Background save error: $e'));
      }
      
      // Process response - split if multiple paragraphs
      await _processAIResponse(response);
      
    } catch (e) {
      print('Error processing user speech: $e');
      previousAIResponse.value = currentAIResponse.value;
      currentAIResponse.value = "Maaf, saya tidak dapat memproses jawaban Anda. Silakan coba lagi.";
      responseCount.value++;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _processAIResponse(String response) async {
    // Check if AI wants to end the interview
    if (response.contains('[END_INTERVIEW]')) {
      // Remove the end interview marker and display the message
      String cleanResponse = response.replaceAll('[END_INTERVIEW]', '').trim();
      
      previousAIResponse.value = currentAIResponse.value;
      currentAIResponse.value = cleanResponse;
      responseCount.value++;
      
      // Speak the final message
      await _speakAIResponse(cleanResponse);
      
      // Wait a moment then complete interview session
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // Complete interview session with AI-generated feedback
      if (_currentSessionId != null) {
        // Get session data to extract messages
        final session = await InterviewStorageService.getInterviewSession(_currentSessionId!);
        
        if (session != null) {
          // Generate AI feedback based on conversation
          final feedback = await InterviewStorageService.generateAIFeedback(
            sessionId: _currentSessionId!,
            messages: session.messages,
            difficulty: _difficulty,
            style: _style,
            additionalPrompt: _additionalPrompts,
          );
          
          await InterviewStorageService.completeInterviewSession(
            sessionId: _currentSessionId!,
            feedback: feedback,
          );
          
          print('🎯 Interview completed by AI with AI-generated feedback. Session ID: $_currentSessionId');
        } else {
          print('❌ Could not retrieve session data for feedback generation');
        }
        
        // Debug: Print session details
        await DebugInterviewService.printLatestSession();
      }
      
      // Update states
      isInterviewActive.value = false;
      isListening.value = false;
      isAISpeaking.value = false;
      isLoading.value = false;
      
      // Navigate to feedback page
      Get.offNamed('/interview-practice-feedback', arguments: {
        'sessionId': _currentSessionId,
      });
      return;
    }
    
    // Split response by paragraphs (double line breaks or single line breaks)
    List<String> paragraphs = response
        .split(RegExp(r'\n\s*\n|\n'))
        .where((p) => p.trim().isNotEmpty)
        .map((p) => p.trim())
        .toList();
    
    // If only one paragraph, display normally
    if (paragraphs.length <= 1) {
      previousAIResponse.value = currentAIResponse.value;
      currentAIResponse.value = response;
      responseCount.value++;
      await _speakAIResponse(response);
      return;
    }
    
    // If multiple paragraphs, display them sequentially
    for (int i = 0; i < paragraphs.length; i++) {
      // Update UI with current paragraph
      previousAIResponse.value = currentAIResponse.value;
      currentAIResponse.value = paragraphs[i];
      responseCount.value++;
      
      // Wait for TTS to complete before showing next paragraph
      await _speakAIResponse(paragraphs[i]);
      
      // Add small delay between paragraphs for better UX (except for the last one)
      if (i < paragraphs.length - 1) {
        await Future.delayed(const Duration(milliseconds: 800));
      }
    }
  }

  Future<void> _speakAIResponse(String text) async {
    isAISpeaking.value = true;
    
    try {
      await TextToSpeechService.speak(text);
    } catch (e) {
      print('Error speaking AI response: $e');
    } finally {
      isAISpeaking.value = false;
    }
  }

  Future<void> endInterview() async {
    // Stop any ongoing speech or listening
    if (isListening.value) {
      await stopListening();
    }
    
    if (isAISpeaking.value) {
      await TextToSpeechService.stop();
      isAISpeaking.value = false;
    }
    
    // Update states
    isInterviewActive.value = false;
    isListening.value = false;
    isAISpeaking.value = false;
    isLoading.value = false;
    
    // Complete interview session with AI-generated feedback (manual end)
    if (_currentSessionId != null) {
      // Get session data to extract messages
      final session = await InterviewStorageService.getInterviewSession(_currentSessionId!);
      
      if (session != null) {
        // Generate AI feedback based on conversation
        final feedback = await InterviewStorageService.generateAIFeedback(
          sessionId: _currentSessionId!,
          messages: session.messages,
          difficulty: _difficulty,
          style: _style,
          additionalPrompt: _additionalPrompts,
        );
        
        await InterviewStorageService.completeInterviewSession(
          sessionId: _currentSessionId!,
          feedback: feedback,
        );
        
        print('🎯 Interview completed manually with AI-generated feedback. Session ID: $_currentSessionId');
      } else {
        print('❌ Could not retrieve session data for feedback generation');
      }
    }
    
    // Show end message
    previousAIResponse.value = currentAIResponse.value;
    currentAIResponse.value = "Interview telah berakhir. Terima kasih atas partisipasi Anda!";
    responseCount.value++;
    
    // Speak the end message
    try {
      await _speakAIResponse("Interview telah berakhir. Terima kasih atas partisipasi Anda!");
    } catch (e) {
      print('Error speaking end message: $e');
    }
    
    // Navigate to feedback page after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      Get.offNamed('/interview-practice-feedback', arguments: {
        'sessionId': _currentSessionId,
      });
    });
  }

  @override
  void onClose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.onClose();
  }
}
