import 'dart:async';
import 'package:get/get.dart';
import '../models/roadmap_models.dart';
import '../../../services/firebase_roadmap_service.dart';
import '../../career_assistant/controllers/career_assistant_controller.dart';

class RoadmapManageController extends GetxController {
  // Roadmap data
  final isLoading = false.obs;
  final roadmapTitle = 'My Career Roadmap'.obs;
  final roadmapSteps = <RoadmapMainStep>[].obs;
  final expandedSteps = <String>{}.obs;
  final expandedSubSteps = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    
    print('🚀 RoadmapManageController initialized');
    
    // Try to load roadmap from Firebase first
    _loadRoadmapFromFirebase();
    
    // Periodically check for completion updates
    _startAutoCompletionCheck();
  }

  @override
  void onReady() {
    super.onReady();
    print('📱 RoadmapManageController ready');
    
    // Also try to get data from CareerAssistantController if available
    _tryLoadFromCareerAssistant();
  }

  // Try to load data from CareerAssistantController
  void _tryLoadFromCareerAssistant() {
    try {
      if (Get.isRegistered<CareerAssistantController>()) {
        final careerController = Get.find<CareerAssistantController>();
        
        if (careerController.hasGeneratedRoadmap.value && 
            careerController.roadmapSteps.isNotEmpty) {
          
          print('🔄 Found roadmap data in CareerAssistantController');
          print('📋 Title: ${careerController.roadmapTitle.value}');
          print('🪜 Steps: ${careerController.roadmapSteps.length}');
          
          // Update with data from Career Assistant
          roadmapTitle.value = careerController.roadmapTitle.value;
          roadmapSteps.value = careerController.roadmapSteps.toList();
          
          print('✅ Roadmap data loaded from CareerAssistantController');
        }
      }
    } catch (e) {
      print('⚠️ Could not load from CareerAssistantController: $e');
    }
  }

  // Load roadmap from Firebase
  Future<void> _loadRoadmapFromFirebase() async {
    try {
      isLoading.value = true;
      print('🔥 Loading roadmap from Firebase...');
      
      final roadmapData = await FirebaseRoadmapService.loadRoadmap();
      
      if (roadmapData != null) {
        // Load data from Firebase
        roadmapTitle.value = roadmapData['title'] as String? ?? 'My Roadmap';
        roadmapSteps.value = FirebaseRoadmapService.parseRoadmapFromFirebase(roadmapData);
        
        print('✅ Roadmap loaded from Firebase');
        print('📋 Title: ${roadmapTitle.value}');
        print('🪜 Steps: ${roadmapSteps.length}');
      } else {
        // No roadmap in Firebase, use sample data
        print('📭 No roadmap in Firebase, using sample data');
        _initializeSampleData();
      }
    } catch (e) {
      print('❌ Error loading from Firebase: $e');
      // Fallback to sample data
      _initializeSampleData();
    } finally {
      isLoading.value = false;
    }
  }
  
  void _startAutoCompletionCheck() {
    // Check completion status every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      _recheckAllCompletions();
    });
  }

  void _recheckAllCompletions() {
    for (final mainStep in roadmapSteps) {
      for (final subStep in mainStep.subSteps) {
        _checkSubStepCompletion(subStep);
      }
      _checkMainStepCompletion(mainStep);
    }
  }

  // Calculate overall progress
  double get overallProgress {
    if (roadmapSteps.isEmpty) return 0.0;
    
    int completedSteps = 0;
    int totalSteps = 0;
    
    for (final mainStep in roadmapSteps) {
      for (final subStep in mainStep.subSteps) {
        totalSteps++;
        if (subStep.isCompleted) completedSteps++;
      }
    }
    
    return totalSteps > 0 ? completedSteps / totalSteps : 0.0;
  }

  // Toggle main step expansion
  void toggleMainStep(String stepId) {
    if (expandedSteps.contains(stepId)) {
      expandedSteps.remove(stepId);
    } else {
      expandedSteps.add(stepId);
    }
  }

  // Toggle sub step expansion
  void toggleSubStep(String subStepId) {
    if (expandedSubSteps.contains(subStepId)) {
      expandedSubSteps.remove(subStepId);
    } else {
      expandedSubSteps.add(subStepId);
    }
  }

  // Toggle sub step completion
  void toggleSubStepCompletion(String subStepId) {
    for (final mainStep in roadmapSteps) {
      for (final subStep in mainStep.subSteps) {
        if (subStep.id == subStepId) {
          subStep.isCompleted = !subStep.isCompleted;
          _checkMainStepCompletion(mainStep);
          
          // Save changes to Firebase
          _saveToFirebase();
          break;
        }
      }
    }
  }

  // Check step completion based on sub-steps
  void checkStepCompletion(String stepId) {
    final step = roadmapSteps.firstWhereOrNull((s) => s.id == stepId);
    if (step != null) {
      _checkMainStepCompletion(step);
    }
  }

  // Check if main step should be completed based on sub-steps
  void _checkMainStepCompletion(RoadmapMainStep mainStep) {
    if (mainStep.subSteps.isEmpty) return;
    
    bool allCompleted = mainStep.subSteps.every((subStep) => subStep.isCompleted);
    mainStep.isCompleted = allCompleted;
  }

  // Check individual sub-step completion
  void _checkSubStepCompletion(RoadmapSubStep subStep) {
    // Auto-completion logic based on step type
    bool shouldBeCompleted = _detectSubStepCompletion(subStep);
    
    if (subStep.isCompleted != shouldBeCompleted) {
      subStep.isCompleted = shouldBeCompleted;
    }
  }

  // Detect if sub-step should be auto-completed
  bool _detectSubStepCompletion(RoadmapSubStep subStep) {
    // Basic detection logic - can be enhanced
    switch (subStep.id) {
      case 'html_css_basics':
        return _hasCompletedCourses();
      case 'javascript_fundamentals':
        return _hasCompletedCourses();
      case 'react_basics':
        return _hasCompletedCourses();
      case 'portfolio_creation':
        return _hasUploadedPortfolio();
      case 'cv_preparation':
        return _hasSavedCV();
      case 'job_applications':
        return _hasAppliedToJobs();
      default:
        return false;
    }
  }

  // Placeholder methods for external integrations
  bool _hasCompletedCourses() {
    // TODO: Check if user has completed relevant courses
    return false;
  }
  
  bool _hasUploadedPortfolio() {
    // TODO: Check if user has uploaded portfolio projects
    return false;
  }
  
  bool _hasSavedCV() {
    // TODO: Check if user has created and saved CV
    return false;
  }
  
  bool _hasAppliedToJobs() {
    // TODO: Check if user has applied to jobs
    return false;
  }

  // Save current roadmap state to Firebase
  Future<void> _saveToFirebase() async {
    try {
      print('💾 Auto-saving roadmap changes to Firebase...');
      
      await FirebaseRoadmapService.saveRoadmap(
        title: roadmapTitle.value,
        description: 'Updated roadmap from roadmap management',
        steps: roadmapSteps.toList(),
      );
      
      print('✅ Auto-save completed');
    } catch (e) {
      print('❌ Auto-save failed: $e');
      // Don't show error to user for auto-save failures
    }
  }

  // Manual save method (can be called from UI)
  Future<void> saveRoadmap() async {
    try {
      await FirebaseRoadmapService.saveRoadmap(
        title: roadmapTitle.value,
        description: 'Roadmap saved from roadmap management',
        steps: roadmapSteps.toList(),
      );
      
      Get.snackbar('Berhasil', 'Roadmap berhasil disimpan!');
    } catch (e) {
      print('❌ Manual save failed: $e');
      Get.snackbar('Error', 'Gagal menyimpan roadmap: $e');
    }
  }

  // Generate new roadmap (navigate to career assistant)
  void generateNewRoadmap() {
    Get.toNamed('/career-assistant');
  }

  // Generate schedule from roadmap
  void generateSchedule() {
    // TODO: Integrate with jadwal_manage system
    Get.snackbar('Info', 'Fitur generate schedule akan segera tersedia!');
  }

  // Manual refresh method (can be called from UI)
  Future<void> refreshRoadmap() async {
    print('🔄 Manual refresh triggered');
    
    // Try to load from Career Assistant first
    _tryLoadFromCareerAssistant();
    
    // Then try Firebase
    await _loadRoadmapFromFirebase();
  }

  // Initialize sample data (fallback)
  void _initializeSampleData() {
    roadmapTitle.value = 'Frontend Developer Career Path';
    roadmapSteps.value = [
      RoadmapMainStep(
        id: 'step_1',
        title: 'Foundation Learning',
        description: 'Master the basics of web development',
        isCompleted: false,
        estimatedDuration: '2-3 months',
        subSteps: [
          RoadmapSubStep(
            id: 'html_css_basics',
            title: 'HTML & CSS Fundamentals',
            description: 'Learn basic structure and styling of websites',
            isCompleted: false,
            estimatedDuration: '2-3 weeks',
            resources: [
              RoadmapResource(
                type: 'course',
                title: 'HTML & CSS Complete Course',
                provider: 'Karirvana Academy',
              ),
            ],
          ),
        ],
      ),
      RoadmapMainStep(
        id: 'step_2',
        title: 'JavaScript Mastery',
        description: 'Learn programming for web interactivity',
        isCompleted: false,
        estimatedDuration: '1-2 months',
        subSteps: [
          RoadmapSubStep(
            id: 'javascript_fundamentals',
            title: 'JavaScript Essentials',
            description: 'Master JavaScript programming language',
            isCompleted: false,
            estimatedDuration: '4-6 weeks',
            resources: [
              RoadmapResource(
                type: 'course',
                title: 'JavaScript Complete Guide',
                provider: 'Karirvana Academy',
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
