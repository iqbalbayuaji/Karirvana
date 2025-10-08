import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/course_model.dart';
import '../../../services/firebase_course_service.dart';

// Note: Course model is now imported from course_model.dart

class CourseStoreMainController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'Semua'.obs;
  final isLoading = false.obs;
  
  final allCourses = <Course>[].obs;
  final filteredCourses = <Course>[].obs;
  final filters = <String>[].obs;
  
  final FirebaseCourseService _courseService = FirebaseCourseService();

  @override
  void onInit() {
    super.onInit();
    
    // Set categories immediately to prevent duplication
    filters.value = [
      'Semua',
      'Business',
      'Data Analytics',
      'Digital Marketing',
      'IT & Programming'
    ];
    
    loadCourses();
    // Skip loadCategories to prevent override and duplication
    // loadCategories();
    
    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterCourses();
    });
    
    // Listen to filter changes
    ever(selectedFilter, (_) => filterCourses());
    ever(searchQuery, (_) => filterCourses());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Load courses from Firebase
  Future<void> loadCourses() async {
    // Prevent multiple simultaneous loads
    if (isLoading.value) return;
    
    try {
      isLoading.value = true;
      
      final courses = await _courseService.getAllCourses();
      
      allCourses.value = courses;
      filteredCourses.value = courses;
      
      print('✅ Loaded ${courses.length} courses from Firebase');
      
    } catch (e) {
      print('❌ Error loading courses: $e');
      
      // Show error message
      Get.snackbar(
        'Error',
        'Gagal memuat data course: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: const Color(0xFFFFFFFF),
      );
      
      // Keep empty list on error
      allCourses.value = [];
      filteredCourses.value = [];
      
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Load categories from Firebase (optional override)
  Future<void> loadCategories() async {
    try {
      final categories = await _courseService.getCourseCategories();
      
      if (categories.isNotEmpty) {
        filters.value = ['Semua', ...categories];
        print('✅ Loaded ${categories.length} course categories from Firebase');
      }
      
    } catch (e) {
      print('❌ Error loading categories: $e');
      // Keep existing categories to prevent duplication
    }
  }

  /// Filter courses based on category and search query
  void filterCourses() {
    List<Course> filtered = allCourses;
    
    // Filter by category
    if (selectedFilter.value != 'Semua') {
      filtered = filtered.where((course) => 
        course.category == selectedFilter.value).toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((course) =>
        course.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        course.instructor.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        course.description.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    filteredCourses.value = filtered;
  }
  
  /// Search courses using Firebase service
  Future<void> searchCourses(String query) async {
    try {
      isLoading.value = true;
      
      final courses = await _courseService.searchCourses(query);
      filteredCourses.value = courses;
      
    } catch (e) {
      print('❌ Error searching courses: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Get courses by category from Firebase
  Future<void> getCoursesByCategory(String category) async {
    if (category == 'Semua') {
      await loadCourses();
      return;
    }
    
    try {
      isLoading.value = true;
      
      final courses = await _courseService.getCoursesByCategory(category);
      filteredCourses.value = courses;
      
    } catch (e) {
      print('❌ Error getting courses by category: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Refresh courses data
  Future<void> refreshCourses() async {
    await loadCourses();
    await loadCategories();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }
}
