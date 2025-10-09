import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/firestore_service.dart';

// Model for course module
class CourseModule {
  final String title;
  final bool isCompleted;
  final DateTime? completedDate;
  final DateTime? lastAccessed;

  CourseModule({
    required this.title,
    this.isCompleted = false,
    this.completedDate,
    this.lastAccessed,
  });

  // Create from Firebase data
  factory CourseModule.fromFirestore(Map<String, dynamic> data) {
    return CourseModule(
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      completedDate: data['completedDate']?.toDate(),
      lastAccessed: data['lastAccessed']?.toDate(),
    );
  }

  // Convert to Firebase data
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'completedDate': completedDate,
      'lastAccessed': lastAccessed,
    };
  }

  // Copy with method for updates
  CourseModule copyWith({
    String? title,
    bool? isCompleted,
    DateTime? completedDate,
    DateTime? lastAccessed,
  }) {
    return CourseModule(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }
}

// Model for managed course (user's enrolled courses)
class ManagedCourse {
  final String id;
  final String title;
  final String provider;
  final String description;
  final double progress;
  final bool isCompleted;
  final DateTime? enrolledDate;
  final DateTime? completedDate;
  final List<CourseModule> modules;
  final String? lastActivityModule;
  final DateTime? lastActivityTime;

  ManagedCourse({
    required this.id,
    required this.title,
    required this.provider,
    required this.description,
    this.progress = 0.0,
    this.isCompleted = false,
    this.enrolledDate,
    this.completedDate,
    this.modules = const [],
    this.lastActivityModule,
    this.lastActivityTime,
  });

  // Create from Firebase data
  factory ManagedCourse.fromFirestore(Map<String, dynamic> data) {
    List<CourseModule> modulesList = [];
    if (data['modules'] != null) {
      modulesList = (data['modules'] as List)
          .map((moduleData) => CourseModule.fromFirestore(moduleData))
          .toList();
    }

    // Handle legacy data - generate modules if not present
    String? lastActivityModule = data['lastActivityModule'];
    if (modulesList.isEmpty && data['title'] != null) {
      // Generate modules for legacy data
      modulesList = _generateLegacyModules(data['title']);
      // Set first module as last activity if not present
      if (lastActivityModule == null && modulesList.isNotEmpty) {
        lastActivityModule = modulesList.first.title;
      }
    }

    return ManagedCourse(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      provider: data['provider'] ?? '',
      description: data['description'] ?? '',
      progress: (data['progress'] ?? 0.0).toDouble(),
      isCompleted: data['isCompleted'] ?? false,
      enrolledDate: data['enrolledDate']?.toDate(),
      completedDate: data['completedDate']?.toDate(),
      modules: modulesList,
      lastActivityModule: lastActivityModule,
      lastActivityTime: data['lastActivityTime']?.toDate() ?? data['enrolledDate']?.toDate(),
    );
  }

  // Static method to generate modules for legacy data
  static List<CourseModule> _generateLegacyModules(String title) {
    final now = DateTime.now();
    
    // Flutter/Mobile Development
    if (title.toLowerCase().contains('flutter') || title.toLowerCase().contains('mobile')) {
      return [
        CourseModule(title: 'Setup & Environment', lastAccessed: now),
        CourseModule(title: 'Widget & Layout'),
        CourseModule(title: 'State Management'),
        CourseModule(title: 'API Integration'),
        CourseModule(title: 'Deployment & Testing'),
      ];
    }
    
    // UI/UX Design
    if (title.toLowerCase().contains('ui') || title.toLowerCase().contains('ux') || title.toLowerCase().contains('design')) {
      return [
        CourseModule(title: 'Design Principles', lastAccessed: now),
        CourseModule(title: 'User Research'),
        CourseModule(title: 'Wireframing & Prototyping'),
        CourseModule(title: 'Visual Design'),
        CourseModule(title: 'Usability Testing'),
      ];
    }
    
    // Digital Marketing
    if (title.toLowerCase().contains('marketing') || title.toLowerCase().contains('digital')) {
      return [
        CourseModule(title: 'Marketing Fundamentals', lastAccessed: now),
        CourseModule(title: 'SEO & Content Strategy'),
        CourseModule(title: 'Social Media Marketing'),
        CourseModule(title: 'Paid Advertising'),
        CourseModule(title: 'Analytics & Optimization'),
      ];
    }
    
    // Python/Data Science
    if (title.toLowerCase().contains('python') || title.toLowerCase().contains('data')) {
      return [
        CourseModule(title: 'Python Basics', lastAccessed: now),
        CourseModule(title: 'Data Manipulation'),
        CourseModule(title: 'Data Visualization'),
        CourseModule(title: 'Machine Learning'),
        CourseModule(title: 'Real-world Projects'),
      ];
    }
    
    // Business/Strategy
    if (title.toLowerCase().contains('business') || title.toLowerCase().contains('strategy')) {
      return [
        CourseModule(title: 'Business Fundamentals', lastAccessed: now),
        CourseModule(title: 'Strategic Planning'),
        CourseModule(title: 'Market Analysis'),
        CourseModule(title: 'Financial Planning'),
        CourseModule(title: 'Implementation & Growth'),
      ];
    }
    
    // React/React Native
    if (title.toLowerCase().contains('react')) {
      return [
        CourseModule(title: 'React Fundamentals', lastAccessed: now),
        CourseModule(title: 'Component Architecture'),
        CourseModule(title: 'State & Props Management'),
        CourseModule(title: 'Navigation & Routing'),
        CourseModule(title: 'App Store Deployment'),
      ];
    }
    
    // Default modules for other courses
    return [
      CourseModule(title: 'Pengenalan Dasar', lastAccessed: now),
      CourseModule(title: 'Konsep Lanjutan'),
      CourseModule(title: 'Praktik & Implementasi'),
      CourseModule(title: 'Studi Kasus'),
    ];
  }

  // Convert to Firebase data
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'provider': provider,
      'description': description,
      'progress': progress,
      'isCompleted': isCompleted,
      'enrolledDate': enrolledDate,
      'completedDate': completedDate,
      'modules': modules.map((module) => module.toFirestore()).toList(),
      'lastActivityModule': lastActivityModule,
      'lastActivityTime': lastActivityTime,
    };
  }

  // Calculate progress based on completed modules
  double get calculatedProgress {
    if (modules.isEmpty) return progress;
    final completedCount = modules.where((module) => module.isCompleted).length;
    return (completedCount / modules.length) * 100;
  }

  // Get last activity info for display
  String get lastActivityDisplay {
    // If there's a specific last activity module, use it
    if (lastActivityModule != null && lastActivityModule!.isNotEmpty) {
      return lastActivityModule!;
    }
    
    // If there are modules, show the first module (which should be accessed)
    if (modules.isNotEmpty) {
      // Find the first module that was accessed, or just use the first module
      final accessedModule = modules.firstWhere(
        (module) => module.lastAccessed != null,
        orElse: () => modules.first,
      );
      return accessedModule.title;
    }
    
    // Fallback
    return 'Memulai pembelajaran';
  }

  // Get last activity time formatted
  String get lastActivityTimeFormatted {
    if (lastActivityTime != null) {
      return '${lastActivityTime!.hour.toString().padLeft(2, '0')}:${lastActivityTime!.minute.toString().padLeft(2, '0')}';
    }
    if (enrolledDate != null) {
      return '${enrolledDate!.hour.toString().padLeft(2, '0')}:${enrolledDate!.minute.toString().padLeft(2, '0')}';
    }
    return '00:00';
  }
}

class CourseManageController extends GetxController {
  // Course data
  final isLoading = false.obs;
  final courses = <ManagedCourse>[].obs;
  final FirestoreService _firestoreService = FirestoreService.instance;

  // Generate modules based on course title (copied from course_model.dart)
  List<CourseModule> _generateModulesForCourse(String title) {
    final now = DateTime.now();
    
    // Flutter/Mobile Development
    if (title.toLowerCase().contains('flutter') || title.toLowerCase().contains('mobile')) {
      return [
        CourseModule(title: 'Setup & Environment', lastAccessed: now),
        CourseModule(title: 'Widget & Layout'),
        CourseModule(title: 'State Management'),
        CourseModule(title: 'API Integration'),
        CourseModule(title: 'Deployment & Testing'),
      ];
    }
    
    // UI/UX Design
    if (title.toLowerCase().contains('ui') || title.toLowerCase().contains('ux') || title.toLowerCase().contains('design')) {
      return [
        CourseModule(title: 'Design Principles', lastAccessed: now),
        CourseModule(title: 'User Research'),
        CourseModule(title: 'Wireframing & Prototyping'),
        CourseModule(title: 'Visual Design'),
        CourseModule(title: 'Usability Testing'),
      ];
    }
    
    // Digital Marketing
    if (title.toLowerCase().contains('marketing') || title.toLowerCase().contains('digital')) {
      return [
        CourseModule(title: 'Marketing Fundamentals', lastAccessed: now),
        CourseModule(title: 'SEO & Content Strategy'),
        CourseModule(title: 'Social Media Marketing'),
        CourseModule(title: 'Paid Advertising'),
        CourseModule(title: 'Analytics & Optimization'),
      ];
    }
    
    // Python/Data Science
    if (title.toLowerCase().contains('python') || title.toLowerCase().contains('data')) {
      return [
        CourseModule(title: 'Python Basics', lastAccessed: now),
        CourseModule(title: 'Data Manipulation'),
        CourseModule(title: 'Data Visualization'),
        CourseModule(title: 'Machine Learning'),
        CourseModule(title: 'Real-world Projects'),
      ];
    }
    
    // Business/Strategy
    if (title.toLowerCase().contains('business') || title.toLowerCase().contains('strategy')) {
      return [
        CourseModule(title: 'Business Fundamentals', lastAccessed: now),
        CourseModule(title: 'Strategic Planning'),
        CourseModule(title: 'Market Analysis'),
        CourseModule(title: 'Financial Planning'),
        CourseModule(title: 'Implementation & Growth'),
      ];
    }
    
    // React/React Native
    if (title.toLowerCase().contains('react')) {
      return [
        CourseModule(title: 'React Fundamentals', lastAccessed: now),
        CourseModule(title: 'Component Architecture'),
        CourseModule(title: 'State & Props Management'),
        CourseModule(title: 'Navigation & Routing'),
        CourseModule(title: 'App Store Deployment'),
      ];
    }
    
    // Default modules for other courses
    return [
      CourseModule(title: 'Pengenalan Dasar', lastAccessed: now),
      CourseModule(title: 'Konsep Lanjutan'),
      CourseModule(title: 'Praktik & Implementasi'),
      CourseModule(title: 'Studi Kasus'),
    ];
  }

  @override
  void onInit() {
    super.onInit();
    print('🔍 CourseManageController onInit - courses count: ${courses.length}');
    _loadCourses();
  }

  // Force refresh courses (for debugging)
  Future<void> forceRefresh() async {
    print('🔄 Force refreshing courses...');
    courses.clear();
    await _loadCourses();
  }

  // Load courses from Firebase
  Future<void> _loadCourses() async {
    try {
      isLoading.value = true;
      
      // Load enrolled courses from Firebase
      final coursesData = await _firestoreService.getEnrolledCourses();
      
      // Convert Firebase data to ManagedCourse objects
      final loadedCourses = coursesData
          .map((data) {
            print('🔍 DEBUG Firebase data: $data');
            final course = ManagedCourse.fromFirestore(data);
            print('🔍 DEBUG Loaded course: ${course.title}');
            print('🔍 DEBUG - lastActivityModule: ${course.lastActivityModule}');
            print('🔍 DEBUG - modules count: ${course.modules.length}');
            print('🔍 DEBUG - lastActivityDisplay: ${course.lastActivityDisplay}');
            return course;
          })
          .toList();
      
      courses.assignAll(loadedCourses);
      print('✅ Loaded ${courses.length} courses from Firebase');
      
    } catch (e) {
      print('❌ Error loading courses: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data kursus',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }


  // Check if has courses
  bool get hasCourses => courses.isNotEmpty;

  // Add course (placeholder)
  void addCourse() {
    // TODO: Navigate to add course page
    Get.snackbar('Info', 'Fitur tambah kursus akan segera tersedia!');
  }

  // Enroll in a course (add to managed courses)
  Future<bool> enrollCourse(dynamic courseData) async {
    try {
      isLoading.value = true;
      
      // Check if course is already enrolled in Firebase
      bool alreadyEnrolled = await _firestoreService.isCourseAlreadyEnrolled(courseData.id);
      if (alreadyEnrolled) {
        Get.snackbar(
          'Info', 
          'Anda sudah terdaftar dalam course ini!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFF59E0B),
          colorText: const Color(0xFFFFFFFF),
        );
        return false;
      }
      
      // Generate modules for the course
      final modules = _generateModulesForCourse(courseData.title);
      final enrolledDate = DateTime.now();
      
      // Create enhanced course data with modules
      final enhancedCourseData = ManagedCourse(
        id: courseData.id,
        title: courseData.title,
        provider: courseData.instructor,
        description: courseData.description,
        progress: 0.0,
        isCompleted: false,
        enrolledDate: enrolledDate,
        modules: modules,
        lastActivityModule: modules.isNotEmpty ? modules.first.title : null,
        lastActivityTime: enrolledDate,
      );
      
      // Save to Firebase with enhanced structure
      final success = await _firestoreService.saveEnrolledCourseWithModules(enhancedCourseData);
      
      if (success) {
        // Instead of adding to local list, reload from Firebase to ensure consistency
        await _loadCourses();
        
        print('✅ Course saved to Firebase and data reloaded. Total courses: ${courses.length}');
        
        Get.snackbar(
          'Berhasil', 
          'Course berhasil ditambahkan!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: const Color(0xFFFFFFFF),
        );
        
        return true;
      } else {
        Get.snackbar(
          'Error', 
          'Gagal menyimpan course',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: const Color(0xFFFFFFFF),
        );
        return false;
      }
      
    } catch (e) {
      print('❌ Error enrolling course: $e');
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan saat mendaftar course',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: const Color(0xFFFFFFFF),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update course progress
  Future<bool> updateCourseProgress(String courseId, double progress) async {
    try {
      isLoading.value = true;
      
      final isCompleted = progress >= 100.0;
      final completedDate = isCompleted ? DateTime.now() : null;
      
      // Update in Firebase
      final success = await _firestoreService.updateCourseProgress(
        courseId: courseId,
        progress: progress,
        isCompleted: isCompleted,
        completedDate: completedDate,
      );
      
      if (success) {
        // Update local data
        final courseIndex = courses.indexWhere((course) => course.id == courseId);
        if (courseIndex != -1) {
          final updatedCourse = ManagedCourse(
            id: courses[courseIndex].id,
            title: courses[courseIndex].title,
            provider: courses[courseIndex].provider,
            description: courses[courseIndex].description,
            progress: progress,
            isCompleted: isCompleted,
            enrolledDate: courses[courseIndex].enrolledDate,
            completedDate: completedDate,
          );
          courses[courseIndex] = updatedCourse;
        }
        
        Get.snackbar(
          'Berhasil', 
          'Progress course berhasil diupdate!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: const Color(0xFFFFFFFF),
        );
        
        return true;
      } else {
        Get.snackbar(
          'Error', 
          'Gagal mengupdate progress course',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: const Color(0xFFFFFFFF),
        );
        return false;
      }
      
    } catch (e) {
      print('❌ Error updating course progress: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Remove course
  Future<bool> removeCourse(String courseId) async {
    try {
      isLoading.value = true;
      
      // Remove from Firebase
      final success = await _firestoreService.removeEnrolledCourse(courseId);
      
      if (success) {
        // Remove from local list
        courses.removeWhere((course) => course.id == courseId);
        
        Get.snackbar(
          'Berhasil', 
          'Course berhasil dihapus!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: const Color(0xFFFFFFFF),
        );
        
        return true;
      } else {
        Get.snackbar(
          'Error', 
          'Gagal menghapus course',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: const Color(0xFFFFFFFF),
        );
        return false;
      }
      
    } catch (e) {
      print('❌ Error removing course: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }


}
