import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/course_model.dart';
import '../../../routes/app_pages.dart';
import '../../course_store_main/controllers/course_store_main_controller.dart';
import '../../course_manage/controllers/course_manage_controller.dart';

class CourseStoreController extends GetxController {
  final Rx<Course?> selectedCourse = Rx<Course?>(null);
  final isLoading = false.obs;
  late CourseStoreMainController courseStoreMainController;

  @override
  void onInit() {
    super.onInit();
    
    // Get or create CourseStoreMainController
    try {
      courseStoreMainController = Get.find<CourseStoreMainController>();
    } catch (e) {
      courseStoreMainController = Get.put(CourseStoreMainController());
    }
    
    // Get course data from arguments
    final arguments = Get.arguments;
    String? courseId;
    
    if (arguments is Map<String, dynamic>) {
      courseId = arguments['courseId'] as String?;
    } else if (arguments is String) {
      courseId = arguments;
    }
    
    loadCourse(courseId);
  }

  void loadCourse(String? courseId) {
    isLoading.value = true;
    
    // Ensure courses are loaded
    if (courseStoreMainController.allCourses.isEmpty) {
      courseStoreMainController.loadCourses();
    }
    
    // Find course by ID or use first course
    if (courseId != null && courseStoreMainController.allCourses.isNotEmpty) {
      selectedCourse.value = courseStoreMainController.allCourses.firstWhere(
        (course) => course.id == courseId,
        orElse: () => courseStoreMainController.allCourses.first,
      );
    } else if (courseStoreMainController.allCourses.isNotEmpty) {
      selectedCourse.value = courseStoreMainController.allCourses.first;
    }
    
    isLoading.value = false;
  }

  // Get course image based on category and title
  String getCourseImage(String category, String title) {
    switch (category) {
      case 'Programming':
        if (title.toLowerCase().contains('flutter')) {
          return 'assets/course/course-frontend-1.jpg';
        } else if (title.toLowerCase().contains('python')) {
          return 'assets/course/course-python.jpg';
        } else if (title.toLowerCase().contains('react')) {
          return 'assets/course/course-programming-1.jpg';
        }
        return 'assets/course/course-programming-1.jpg';
      
      case 'Design':
        if (title.toLowerCase().contains('ui') || title.toLowerCase().contains('ux')) {
          return 'assets/course/course-uiux-1.jpg';
        }
        return 'assets/course/course-uiux-2.jpg';
      
      case 'Marketing':
        return 'assets/course/course-marketing-1.png';
      
      case 'Data Science':
        return 'assets/course/course-python.jpg';
      
      case 'Business':
        return 'assets/course/course-akuntansi-1.jpg';
      
      case 'Mobile Development':
        return 'assets/course/course-frontend-1.jpg';
      
      default:
        return 'assets/course/course-programming-1.jpg';
    }
  }

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  // Enroll in current course
  Future<void> enrollCourse() async {
    if (selectedCourse.value == null) return;
    
    try {
      // Get or create CourseManageController (permanent)
      CourseManageController courseManageController;
      try {
        courseManageController = Get.find<CourseManageController>();
      } catch (e) {
        courseManageController = Get.put(CourseManageController(), permanent: true);
      }
      
      // Enroll in the course
      bool success = await courseManageController.enrollCourse(selectedCourse.value!);
      
      Get.toNamed(Routes.COURSE_MANAGE);
      if (success) {
        // Optionally navigate back or show additional UI
        // Get.back(); // Uncomment if you want to go back after enrollment
      }
      
    } catch (e) {
      print('Error enrolling course: $e');
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan saat mendaftar course.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }
}
