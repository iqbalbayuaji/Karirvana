import 'package:get/get.dart';

// Model for course
class Course {
  final String id;
  final String title;
  final String provider;
  final String description;
  final double progress;
  final bool isCompleted;
  final DateTime? enrolledDate;
  final DateTime? completedDate;

  Course({
    required this.id,
    required this.title,
    required this.provider,
    required this.description,
    this.progress = 0.0,
    this.isCompleted = false,
    this.enrolledDate,
    this.completedDate,
  });
}

class CourseManageController extends GetxController {
  // Course data
  final isLoading = false.obs;
  final courses = <Course>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCourses();
  }

  // Load courses (placeholder for future implementation)
  Future<void> _loadCourses() async {
    try {
      isLoading.value = true;
      
      // TODO: Load from Firebase/API
      // For now, empty list to show empty state
      await Future.delayed(Duration(seconds: 1)); // Simulate loading
      
      courses.value = [];
      
    } catch (e) {
      print('Error loading courses: $e');
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

  // Refresh courses
  Future<void> refreshCourses() async {
    await _loadCourses();
  }
}
