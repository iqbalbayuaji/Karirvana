import 'dart:async';
import 'package:get/get.dart';
import '../models/roadmap_models.dart';

class RoadmapManageController extends GetxController {
  // Roadmap data
  final isLoading = false.obs;
  final roadmapTitle = 'Frontend Developer Career Path'.obs;
  final roadmapSteps = <RoadmapMainStep>[].obs;
  final expandedSteps = <String>{}.obs;
  final expandedSubSteps = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSampleData();
    
    // Periodically check for completion updates
    _startAutoCompletionCheck();
  }
  
  void _startAutoCompletionCheck() {
    // Check completion status every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      _recheckAllCompletions();
    });
  }

  void _recheckAllCompletions() {
    for (final mainStep in roadmapSteps) {
      checkStepCompletion(mainStep.id);
    }
  }

  void _initializeSampleData() {
    isLoading.value = true;
    // Sample hierarchical roadmap data
    roadmapSteps.value = [
      RoadmapMainStep(
        id: '1',
        title: 'Mempelajari Frontend Development',
        description: 'Kuasai teknologi dasar untuk pengembangan web frontend',
        isCompleted: false,
        estimatedDuration: '3-4 bulan',
        subSteps: [
          RoadmapSubStep(
            id: '1-1',
            title: 'Belajar HTML & CSS',
            description: 'Pelajari struktur dan styling dasar website',
            isCompleted: true,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'course',
                title: 'HTML & CSS Fundamentals',
                provider: 'Karirvana Academy',
                status: ResourceStatus.completed,
              ),
              RoadmapResource(
                type: 'certificate',
                title: 'Web Development Certificate',
                provider: 'Karirvana',
                status: ResourceStatus.inProgress,
              ),
              RoadmapResource(
                type: 'certificate',
                title: 'HTML5 & CSS3 Certificate',
                provider: 'TechCert',
                status: ResourceStatus.added,
              ),
              RoadmapResource(
                type: 'certificate',
                title: 'Web Design Fundamentals',
                provider: 'DesignPro',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '1-2',
            title: 'Belajar JavaScript',
            description: 'Kuasai bahasa pemrograman untuk interaktivitas web',
            isCompleted: false,
            estimatedDuration: '4-6 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'JavaScript Essentials', 
                provider: 'CodeAcademy',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'course', 
                title: 'Modern JavaScript ES6+', 
                provider: 'DevSkills',
                status: ResourceStatus.added,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '1-3',
            title: 'Belajar React.js',
            description: 'Pelajari framework React untuk aplikasi web modern',
            isCompleted: false,
            estimatedDuration: '6-8 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'React.js Complete Guide', 
                provider: 'ReactMasters',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'course', 
                title: 'React Hooks & Context', 
                provider: 'ModernReact',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'certificate', 
                title: 'React Developer Certificate', 
                provider: 'ReactCert',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'certificate', 
                title: 'Frontend Framework Mastery', 
                provider: 'FrameworkPro',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
        ],
      ),
      RoadmapMainStep(
        id: '2',
        title: 'Create Portfolio',
        description: 'Bangun portfolio yang menarik dan dapatkan sertifikasi',
        isCompleted: false,
        estimatedDuration: '1-2 bulan',
        subSteps: [
          RoadmapSubStep(
            id: '2-1',
            title: 'Mengikuti Sertifikasi',
            description: 'Dapatkan sertifikasi untuk meningkatkan kredibilitas',
            isCompleted: false,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'certificate', 
                title: 'Frontend Developer Professional', 
                provider: 'TechCert',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'certificate', 
                title: 'React.js Specialist', 
                provider: 'ReactCert',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '2-2',
            title: 'Membuat CV',
            description: 'Buat CV yang menarik dan profesional',
            isCompleted: false,
            estimatedDuration: '1 minggu',
            resources: [
              RoadmapResource(
                type: 'tool', 
                title: 'CV Assistant', 
                provider: 'Karirvana',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '2-3',
            title: 'Bangun Portfolio Website',
            description: 'Buat website portfolio untuk showcase project',
            isCompleted: false,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'Portfolio Website Development', 
                provider: 'WebAcademy',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
        ],
      ),
      RoadmapMainStep(
        id: '3',
        title: 'Melamar Pekerjaan',
        description: 'Mulai melamar pekerjaan sebagai Frontend Developer',
        isCompleted: false,
        estimatedDuration: '1-3 bulan',
        subSteps: [
          RoadmapSubStep(
            id: '3-1',
            title: 'Persiapan Interview',
            description: 'Siapkan diri untuk proses interview',
            isCompleted: false,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'Technical Interview Mastery', 
                provider: 'InterviewAce',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'tool', 
                title: 'Interview Practice', 
                provider: 'Karirvana',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '3-2',
            title: 'Apply to Companies',
            description: 'Mulai melamar ke perusahaan target',
            isCompleted: false,
            estimatedDuration: '4-8 minggu',
            resources: [
              RoadmapResource(
                type: 'job', 
                title: 'Frontend Developer - Tokopedia', 
                provider: 'Tokopedia', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.applied,
              ),
              RoadmapResource(
                type: 'job', 
                title: 'React Developer - Gojek', 
                provider: 'Gojek', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.accepted,
              ),
              RoadmapResource(
                type: 'job', 
                title: 'Web Developer - Shopee', 
                provider: 'Shopee', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.notApplied,
              ),
              RoadmapResource(
                type: 'job', 
                title: 'Frontend Engineer - Traveloka', 
                provider: 'Traveloka', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.notApplied,
              ),
            ],
          ),
        ],
      ),
    ];
    
    isLoading.value = false;
  }

  void toggleMainStep(String stepId) {
    if (expandedSteps.contains(stepId)) {
      expandedSteps.remove(stepId);
      // Also collapse all sub-steps when main step is collapsed
      final mainStep = roadmapSteps.firstWhere((step) => step.id == stepId);
      for (final subStep in mainStep.subSteps) {
        expandedSubSteps.remove(subStep.id);
      }
    } else {
      expandedSteps.add(stepId);
    }
    expandedSteps.refresh();
    expandedSubSteps.refresh();
  }

  void toggleSubStep(String subStepId) {
    if (expandedSubSteps.contains(subStepId)) {
      expandedSubSteps.remove(subStepId);
    } else {
      expandedSubSteps.add(subStepId);
    }
    expandedSubSteps.refresh();
  }

  // Auto-detect step completion based on system criteria
  void checkStepCompletion(String stepId, {bool isSubStep = false}) {
    if (isSubStep) {
      // Auto-detect sub-step completion
      for (final mainStep in roadmapSteps) {
        final subStepIndex = mainStep.subSteps.indexWhere((s) => s.id == stepId);
        if (subStepIndex != -1) {
          final subStep = mainStep.subSteps[subStepIndex];
          
          // Auto-completion logic based on step type
          bool shouldBeCompleted = _detectSubStepCompletion(subStep);
          
          if (subStep.isCompleted != shouldBeCompleted) {
            subStep.isCompleted = shouldBeCompleted;
            roadmapSteps.refresh();
          }
          break;
        }
      }
    } else {
      // Auto-detect main step completion
      final stepIndex = roadmapSteps.indexWhere((s) => s.id == stepId);
      if (stepIndex != -1) {
        final mainStep = roadmapSteps[stepIndex];
        
        // Main step is completed when all sub-steps are completed
        bool allSubStepsCompleted = mainStep.subSteps.every((subStep) => subStep.isCompleted);
        
        if (mainStep.isCompleted != allSubStepsCompleted) {
          mainStep.isCompleted = allSubStepsCompleted;
          roadmapSteps.refresh();
        }
      }
    }
  }
  
  // Logic to detect if a sub-step should be marked as completed
  bool _detectSubStepCompletion(RoadmapSubStep subStep) {
    // Example completion criteria - you can customize this based on your needs
    switch (subStep.id) {
      case 'html_css':
        // Check if user has completed HTML/CSS courses or assessments
        return _hasCompletedCourses(['html_basics', 'css_basics']);
      
      case 'javascript':
        // Check if user has completed JavaScript courses
        return _hasCompletedCourses(['js_fundamentals', 'js_dom']);
      
      case 'react':
        // Check if user has completed React courses
        return _hasCompletedCourses(['react_basics', 'react_hooks']);
      
      case 'portfolio':
        // Check if user has uploaded portfolio projects
        return _hasUploadedPortfolio();
      
      case 'cv_building':
        // Check if user has created and saved CV
        return _hasSavedCV();
      
      case 'job_applications':
        // Check if user has applied to jobs through the platform
        return _hasAppliedToJobs();
      
      default:
        // Default: manual completion or time-based
        return false;
    }
  }
  
  // Helper methods for checking completion criteria
  bool _hasCompletedCourses(List<String> courseIds) {
    // TODO: Integrate with your course completion system
    // For now, return false - implement based on your course tracking
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
  
  // Method to manually trigger completion check for all steps
  void recheckAllCompletions() {
    for (final mainStep in roadmapSteps) {
      for (final subStep in mainStep.subSteps) {
        checkStepCompletion(subStep.id, isSubStep: true);
      }
      checkStepCompletion(mainStep.id, isSubStep: false);
    }
  }

  void generateNewRoadmap() {
    // Navigate to career assistant for AI roadmap generation
    Get.toNamed('/career-assistant', arguments: {'mode': 'roadmap'});
  }

  void generateSchedule() {
    Get.toNamed('/jadwal-manage');
  }

  double get overallProgress {
    if (roadmapSteps.isEmpty) return 0.0;
    
    int totalSteps = 0;
    int completedSteps = 0;
    
    for (final mainStep in roadmapSteps) {
      totalSteps += 1 + mainStep.subSteps.length;
      if (mainStep.isCompleted) completedSteps++;
      for (final subStep in mainStep.subSteps) {
        if (subStep.isCompleted) completedSteps++;
      }
    }
    
    return totalSteps > 0 ? completedSteps / totalSteps : 0.0;
  }
}
