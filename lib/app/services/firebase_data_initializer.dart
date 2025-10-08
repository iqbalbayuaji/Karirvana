import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_course_service.dart';

class FirebaseDataInitializer {
  static final FirebaseCourseService _courseService = FirebaseCourseService();

  /// Initialize all default data in Firebase
  /// Call this method once to populate Firebase with course and certification data
  static Future<void> initializeAllData() async {
    try {
      print('🚀 Starting Firebase data initialization...');
      
      // Show loading dialog
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Menginisialisasi data Firebase...'),
                  Text('Mohon tunggu sebentar'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Initialize default data
      await _courseService.initializeDefaultData();
      
      // Close loading dialog
      Get.back();
      
      // Show success message
      Get.snackbar(
        'Berhasil',
        'Data course dan certification berhasil diinisialisasi ke Firebase',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF10B981),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
      );
      
      print('✅ Firebase data initialization completed successfully!');
      
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      // Show error message
      Get.snackbar(
        'Error',
        'Gagal menginisialisasi data: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 5),
      );
      
      print('❌ Error initializing Firebase data: $e');
    }
  }

  /// Check if data already exists in Firebase
  static Future<bool> isDataInitialized() async {
    try {
      final courses = await _courseService.getAllCourses();
      final certifications = await _courseService.getAllCertifications();
      
      return courses.isNotEmpty && certifications.isNotEmpty;
    } catch (e) {
      print('Error checking data initialization: $e');
      return false;
    }
  }

  /// Reset all data (use with caution)
  static Future<void> resetAllData() async {
    try {
      print('⚠️ Resetting all Firebase data...');
      
      // Get all courses and certifications
      final courses = await _courseService.getAllCourses();
      final certifications = await _courseService.getAllCertifications();
      
      // Delete all courses
      for (final course in courses) {
        await _courseService.deleteCourse(course.id);
      }
      
      // Delete all certifications
      for (final certification in certifications) {
        await _courseService.deleteCertification(certification.id);
      }
      
      print('✅ All data reset completed');
      
    } catch (e) {
      print('❌ Error resetting data: $e');
    }
  }
}
