import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  ManagedCourse({
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
  final courses = <ManagedCourse>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('🔍 CourseManageController onInit - courses count: ${courses.length}');
    _loadCourses();
  }

  // Load courses (placeholder for future implementation)
  Future<void> _loadCourses() async {
    try {
      isLoading.value = true;
      
      // TODO: Load from Firebase/API
      // For now, keep existing courses (don't reset to empty)
      await Future.delayed(Duration(seconds: 1)); // Simulate loading
      
      // Don't add sample courses - only show enrolled courses
      
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

  // Enroll in a course (add to managed courses)
  Future<bool> enrollCourse(dynamic courseData) async {
    try {
      isLoading.value = true;
      
      // Check if course is already enrolled
      bool alreadyEnrolled = courses.any((course) => course.id == courseData.id);
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
      
      // Create managed course from course data
      final managedCourse = ManagedCourse(
        id: courseData.id,
        title: courseData.title,
        provider: courseData.instructor,
        description: courseData.description,
        progress: 0.0,
        isCompleted: false,
        enrolledDate: DateTime.now(),
      );
      
      // Add to courses list
      courses.add(managedCourse);
      print('✅ Course added to list. Total courses: ${courses.length}');
      print('📋 Current courses: ${courses.map((c) => c.title).toList()}');
      
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 1));
      
      return true;
      
    } catch (e) {
      print('Error enrolling course: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh courses
  Future<void> refreshCourses() async {
    await _loadCourses();
  }

}
