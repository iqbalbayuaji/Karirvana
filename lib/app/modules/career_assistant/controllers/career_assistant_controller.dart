import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../../../services/groq_service.dart';
import '../../../services/groq_roadmap_service.dart';
import '../../../services/groq_schedule_service.dart';
import '../../../services/speech_service.dart';
import '../../../services/firebase_roadmap_service.dart';
import '../../roadmap_manage/models/roadmap_models.dart';
import '../../roadmap_manage/controllers/roadmap_manage_controller.dart';
import '../../jadwal_manage/models/task_model.dart';
import '../../jadwal_manage/controllers/jadwal_manage_controller.dart';

class CareerAssistantController extends GetxController {
  // View state management
  final RxBool isWelcomeView = true.obs;
  final RxBool isRoadmapMode = false.obs;
  final RxBool isScheduleMode = false.obs;
  
  // Chat functionality
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode inputFocusNode = FocusNode();

  // Speech recognition functionality
  final RxBool isListening = false.obs;
  final RxBool isSpeechAvailable = false.obs;
  final RxString partialSpeechResult = ''.obs;

  // Roadmap functionality
  final RxBool hasGeneratedRoadmap = false.obs;
  final RxString roadmapTitle = ''.obs;
  final RxString roadmapDescription = ''.obs;
  final RxList<RoadmapMainStep> roadmapSteps = <RoadmapMainStep>[].obs;
  final RxList<String> expandedSteps = <String>[].obs;
  final RxList<String> expandedSubSteps = <String>[].obs;

  // Schedule functionality
  final RxBool hasGeneratedSchedule = false.obs;
  final RxString scheduleTitle = ''.obs;
  final RxString scheduleDescription = ''.obs;
  final RxString scheduleDuration = ''.obs;
  final RxList<TaskModel> scheduleTasks = <TaskModel>[].obs;

  // Quick action topics
  final List<String> quickActions = [
    '💼 Panduan Karir',
    '📄 Review CV',
    '🎯 Interview Tips',
    '📊 Skill Assessment',
    '💰 Negosiasi Gaji',
    '🚀 Career Switch',
    '📅 Jadwal Belajar',
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
    final args = Get.arguments;
    
    // Check for roadmap mode
    if (args is Map && args['mode'] == 'roadmap') {
      isRoadmapMode.value = true;
      // Auto-start with roadmap generation prompt
      WidgetsBinding.instance.addPostFrameCallback((_) {
        sendMessage('Buatkan saya roadmap karir yang sesuai dengan minat dan kemampuan saya');
      });
    }
    
    final bool shouldAutofocus = args is Map && (args['autofocus'] == true);
    if (shouldAutofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        inputFocusNode.requestFocus();
      });
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    inputFocusNode.dispose();
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

    // Clear previous roadmap when user continues conversation
    if (hasGeneratedRoadmap.value) {
      print('🔄 Clearing previous roadmap for new conversation');
      _clearRoadmapData();
    }

    // Clear previous schedule when user continues conversation
    if (hasGeneratedSchedule.value) {
      print('🔄 Clearing previous schedule for new conversation');
      _clearScheduleData();
    }

    // Add user message
    final userMessage = ChatMessage.user(text.trim());
    messages.add(userMessage);
    messageController.clear();

    // Show typing indicator
    isTyping.value = true;
    _scrollToBottom();

    try {
      String modeString = isRoadmapMode.value ? "ROADMAP" : (isScheduleMode.value ? "SCHEDULE" : "NORMAL");
      print('🚀 SENDING MESSAGE - Mode: $modeString');
      print('📝 Message count: ${messages.length}');
      
      String response;
      if (isScheduleMode.value) {
        // In schedule mode, always use schedule service
        response = await GroqScheduleService.sendMessage(messages.toList());
      } else {
        // Detect if user is asking for schedule generation (only in normal mode)
        final isScheduleRequest = _isScheduleRequest(text.trim());
        print('📅 Is schedule request: $isScheduleRequest');
        
        if (isScheduleRequest) {
          // Use schedule service for schedule generation
          response = await GroqScheduleService.sendMessage(messages.toList());
        } else {
          // Choose service based on mode
          response = isRoadmapMode.value 
              ? await GroqRoadmapService.sendMessage(messages.toList())
              : await GroqService.sendMessage(messages.toList());
        }
      }
      
      print('✅ RESPONSE RECEIVED');
      print('📄 Response length: ${response.length}');
      print('🔍 First 200 chars: ${response.length > 200 ? response.substring(0, 200) + "..." : response}');
      
      // Process response based on mode
      if (isScheduleMode.value) {
        // In schedule mode, always try to process as schedule
        if (GroqScheduleService.isScheduleResponse(response)) {
          print('📅 Processing as schedule...');
          _processScheduleResponse(response);
        } else {
          print('💬 Processing as normal chat in schedule mode...');
          // Add bot response as normal chat message
          messages.add(ChatMessage.bot(response));
        }
      }
      // Check if response contains a roadmap (only in roadmap mode)
      else if (isRoadmapMode.value) {
        final isRoadmap = GroqRoadmapService.isRoadmapResponse(response);
        print('🗺️ Is roadmap response: $isRoadmap');
        
        if (isRoadmap) {
          print('🎯 Processing as roadmap...');
          _processRoadmapResponse(response);
        } else {
          print('💬 Processing as normal chat...');
          // Add bot response as normal chat message
          messages.add(ChatMessage.bot(response));
        }
      } else {
        // Normal mode - check if it was a schedule request
        final isScheduleRequest = _isScheduleRequest(text.trim());
        if (isScheduleRequest && GroqScheduleService.isScheduleResponse(response)) {
          print('📅 Processing as schedule in normal mode...');
          _processScheduleResponse(response);
        } else {
          // Add bot response as normal chat message
          messages.add(ChatMessage.bot(response));
        }
      }
    } catch (e) {
      print('❌ ERROR in sendMessage: ${e.toString()}');
      print('📍 Error type: ${e.runtimeType}');
      
      // Add error message
      messages.add(ChatMessage.bot(
        'Maaf, terjadi kesalahan saat memproses pesan Anda. Silakan coba lagi.\n\nDEBUG: ${e.toString()}'
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
      case '📅 Jadwal Belajar':
        message = 'Buatkan saya jadwal belajar untuk 3 hari ke depan yang terstruktur dan efektif';
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
    isRoadmapMode.value = false;
    isScheduleMode.value = false;
    hasGeneratedRoadmap.value = false;
    hasGeneratedSchedule.value = false;
    messages.clear();
    messageController.clear();
    _clearRoadmapData();
    _clearScheduleData();
  }

  void startRoadmapMode() {
    isRoadmapMode.value = true;
    isWelcomeView.value = false;
    messages.clear();
    _clearRoadmapData(); // Clear any previous roadmap
    
    // Add initial roadmap greeting
    final initialMessage = ChatMessage(
      content: "Halo! Saya Roadmap Assistant, siap membantu membuat roadmap karir yang tepat untuk Anda! 🚀\n\nSebelum saya buatkan roadmap yang detail, saya perlu memahami situasi Anda terlebih dahulu. Mari kita mulai:\n\n**Apa tujuan karir yang ingin Anda capai?** \nMisalnya: posisi tertentu, industri yang diminati, atau perubahan karir yang diinginkan.",
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    messages.add(initialMessage);
    _scrollToBottom();
  }

  void startScheduleMode() {
    isScheduleMode.value = true;
    isWelcomeView.value = false;
    messages.clear();
    _clearScheduleData(); // Clear any previous schedule
    
    // Add initial schedule greeting
    final initialMessage = ChatMessage(
      content: "📅 **Mode Jadwal Belajar Aktif**\n\nHalo! Saya Schedule Assistant, siap membantu membuat jadwal belajar yang efektif untuk Anda! 🎯",
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    messages.add(initialMessage);
    _scrollToBottom();
  }


  // Initialize speech recognition
  Future<void> _initializeSpeech() async {
    try {
      final available = await SpeechService.initialize();
      isSpeechAvailable.value = available;
    } catch (e) {
      // Error initializing speech: $e
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

  // Process roadmap response from Groq
  void _processRoadmapResponse(String response) {
    try {
      print('🔄 PROCESSING ROADMAP RESPONSE');
      
      final roadmapJson = GroqRoadmapService.extractRoadmapJson(response);
      print('📊 Extracted JSON: ${roadmapJson != null ? "SUCCESS" : "FAILED"}');
      
      if (roadmapJson != null) {
        print('🏗️ JSON Keys: ${roadmapJson.keys.toList()}');
        
        // Extract roadmap info
        final roadmapInfo = GroqRoadmapService.getRoadmapInfo(response);
        roadmapTitle.value = roadmapInfo['title'] ?? 'Roadmap Karir';
        roadmapDescription.value = roadmapInfo['description'] ?? '';
        
        print('📋 Title: ${roadmapTitle.value}');
        print('📝 Description: ${roadmapDescription.value}');
        
        // Parse roadmap steps
        roadmapSteps.value = GroqRoadmapService.parseRoadmapSteps(roadmapJson);
        print('🪜 Steps parsed: ${roadmapSteps.length}');
        
        // Set roadmap generated flag
        hasGeneratedRoadmap.value = true;
        print('✅ Roadmap generation flag set to true');
        
        // Add confirmation message
        messages.add(ChatMessage.bot(
          "Roadmap karir Anda telah berhasil dibuat! 🎉\n\nSilakan lihat roadmap di bawah ini dan tentukan apakah sesuai dengan kebutuhan Anda. Anda dapat menyimpannya atau meminta saya untuk membuat ulang dengan penyesuaian."
        ));
      } else {
        print('⚠️ JSON extraction failed, treating as normal message');
        messages.add(ChatMessage.bot(response));
      }
    } catch (e) {
      print('❌ ERROR in _processRoadmapResponse: ${e.toString()}');
      print('📍 Error type: ${e.runtimeType}');
      
      // If parsing fails, treat as normal message
      messages.add(ChatMessage.bot(response));
    }
  }

  // Clear roadmap data
  void _clearRoadmapData() {
    print('🧹 Clearing roadmap data...');
    hasGeneratedRoadmap.value = false;
    roadmapTitle.value = '';
    roadmapDescription.value = '';
    roadmapSteps.clear();
    expandedSteps.clear();
    expandedSubSteps.clear();
    print('✅ Roadmap data cleared');
  }

  // Save roadmap to roadmap_manage system and Firebase
  Future<void> saveRoadmap() async {
    try {
      print('🔄 Starting roadmap save process...');
      print('📋 Roadmap Title: ${roadmapTitle.value}');
      print('🪜 Steps Count: ${roadmapSteps.length}');
      
      // Validate roadmap data
      if (roadmapTitle.value.isEmpty) {
        throw Exception('Roadmap title is empty');
      }
      
      if (roadmapSteps.isEmpty) {
        throw Exception('Roadmap has no steps');
      }
      
      // Ensure RoadmapManageController exists
      if (!Get.isRegistered<RoadmapManageController>()) {
        print('📦 Registering RoadmapManageController...');
        Get.put(RoadmapManageController(), permanent: true);
      }
      
      // Get controller
      final roadmapManageController = Get.find<RoadmapManageController>();
      print('✅ Got RoadmapManageController');
      
      // Update roadmap_manage with new data
      print('📊 Updating roadmap data...');
      roadmapManageController.roadmapTitle.value = roadmapTitle.value;
      roadmapManageController.roadmapSteps.value = roadmapSteps.toList();
      
      print('✅ Roadmap data updated successfully');
      
      // Verify data transfer
      print('🔍 Verification:');
      print('   - RoadmapManage Title: ${roadmapManageController.roadmapTitle.value}');
      print('   - RoadmapManage Steps: ${roadmapManageController.roadmapSteps.length}');
      print('   - Data Match: ${roadmapManageController.roadmapTitle.value == roadmapTitle.value}');
      
      // Save to Firebase
      print('🔥 Saving to Firebase...');
      await FirebaseRoadmapService.saveRoadmap(
        title: roadmapTitle.value,
        description: roadmapDescription.value,
        steps: roadmapSteps.toList(),
      );
      print('✅ Firebase save completed');
      Get.snackbar(
        'Berhasil',
        'Roadmap berhasil disimpan! Anda dapat mengelolanya di halaman Roadmap Management.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        titleText: Text(
          'Berhasil',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Roadmap berhasil disimpan! Anda dapat mengelolanya di halaman Roadmap Management.',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
      );
      
      // Notify RoadmapManageController if it exists
      if (Get.isRegistered<RoadmapManageController>()) {
        final roadmapController = Get.find<RoadmapManageController>();
        roadmapController.refreshRoadmap();
        print('🔄 Notified RoadmapManageController to refresh');
      }
      
      // Clear roadmap and return to welcome
      _clearRoadmapData();
      backToWelcome();
    } catch (e) {
      print('❌ Error saving roadmap: ${e.toString()}');
      print('📍 Error type: ${e.runtimeType}');
      
      Get.snackbar(
        'Error',
        'Gagal menyimpan roadmap: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }

  // Regenerate roadmap
  void regenerateRoadmap() {
    // Clear current roadmap
    _clearRoadmapData();
    
    // Send regeneration request
    sendMessage("Saya kurang puas dengan roadmap yang dibuat. Bisakah Anda membuat roadmap yang lebih sesuai dengan kebutuhan saya? Mohon pertimbangkan kembali detail yang sudah saya berikan sebelumnya.");
  }

  // Check if user message is requesting schedule generation
  bool _isScheduleRequest(String message) {
    final lowerMessage = message.toLowerCase();
    final scheduleKeywords = [
      'jadwal',
      'schedule',
      'buatkan jadwal',
      'generate schedule',
      'jadwal belajar',
      'study schedule',
      'rencana belajar',
      'planning belajar',
    ];
    
    return scheduleKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  // Process schedule response from Groq
  void _processScheduleResponse(String response) {
    try {
      print('🔄 PROCESSING SCHEDULE RESPONSE');
      print('📄 Raw response: ${response.substring(0, response.length > 500 ? 500 : response.length)}...');
      
      // Parse schedule tasks
      scheduleTasks.value = GroqScheduleService.parseScheduleResponse(response);
      print('📅 Tasks parsed: ${scheduleTasks.length}');
      
      // Get schedule metadata
      final metadata = GroqScheduleService.getScheduleMetadata(response);
      scheduleTitle.value = metadata['title'] ?? 'Jadwal Belajar';
      scheduleDescription.value = metadata['description'] ?? '';
      scheduleDuration.value = metadata['duration'] ?? '3 hari';
      
      print('📋 Title: ${scheduleTitle.value}');
      print('📝 Description: ${scheduleDescription.value}');
      print('⏱️ Duration: ${scheduleDuration.value}');
      
      // Set schedule generated flag
      hasGeneratedSchedule.value = true;
      print('✅ Schedule generation flag set to true');
      
      // Add confirmation message
      messages.add(ChatMessage.bot(
        "Jadwal belajar Anda telah berhasil dibuat! 📅\n\nSilakan lihat jadwal di bawah ini dan tentukan apakah sesuai dengan kebutuhan Anda. Anda dapat menyimpannya atau meminta saya untuk membuat ulang dengan penyesuaian."
      ));
      
    } catch (e) {
      print('❌ ERROR in _processScheduleResponse: ${e.toString()}');
      print('📍 Error type: ${e.runtimeType}');
      
      // If parsing fails, treat as normal message
      messages.add(ChatMessage.bot(response));
    }
  }

  // Clear schedule data
  void _clearScheduleData() {
    print('🧹 Clearing schedule data...');
    hasGeneratedSchedule.value = false;
    scheduleTitle.value = '';
    scheduleDescription.value = '';
    scheduleDuration.value = '';
    scheduleTasks.clear();
    print('✅ Schedule data cleared');
  }

  // Save schedule to jadwal_manage system
  Future<void> saveSchedule() async {
    try {
      print('🔄 Starting schedule save process...');
      print('📋 Schedule Title: ${scheduleTitle.value}');
      print('📅 Tasks Count: ${scheduleTasks.length}');
      
      // Validate schedule data
      if (scheduleTitle.value.isEmpty) {
        throw Exception('Schedule title is empty');
      }
      
      if (scheduleTasks.isEmpty) {
        throw Exception('Schedule has no tasks');
      }
      
      // Ensure JadwalManageController exists
      if (!Get.isRegistered<JadwalManageController>()) {
        print('📦 Registering JadwalManageController...');
        Get.put(JadwalManageController(), permanent: true);
      }
      
      // Get controller
      final jadwalController = Get.find<JadwalManageController>();
      print('✅ Got JadwalManageController');
      
      // Add tasks to jadwal_manage
      print('📊 Adding tasks to jadwal_manage...');
      for (final task in scheduleTasks) {
        jadwalController.addTask(task);
      }
      
      print('✅ Schedule tasks added successfully');
      
      Get.snackbar(
        'Berhasil',
        'Jadwal belajar berhasil disimpan! Anda dapat mengelolanya di halaman Jadwal Management.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        titleText: Text(
          'Berhasil',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Jadwal belajar berhasil disimpan! Anda dapat mengelolanya di halaman Jadwal Management.',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
      );
      
      // Clear schedule and return to welcome
      _clearScheduleData();
      backToWelcome();
    } catch (e) {
      print('❌ Error saving schedule: ${e.toString()}');
      print('📍 Error type: ${e.runtimeType}');
      
      Get.snackbar(
        'Error',
        'Gagal menyimpan jadwal: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }

  // Regenerate schedule
  void regenerateSchedule() {
    // Clear current schedule
    _clearScheduleData();
    
    // Send regeneration request
    sendMessage("Saya kurang puas dengan jadwal yang dibuat. Bisakah Anda membuat jadwal belajar yang lebih sesuai dengan kebutuhan saya?");
  }
}
