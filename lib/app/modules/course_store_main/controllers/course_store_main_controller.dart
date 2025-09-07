import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Course {
  final String id;
  final String title;
  final String instructor;
  final String category;
  final String description;
  final String imageUrl;
  final double rating;
  final int totalStudents;
  final int totalLessons;
  final String duration;
  final double price;
  final bool isFree;
  final String level;

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.totalStudents,
    required this.totalLessons,
    required this.duration,
    required this.price,
    required this.isFree,
    required this.level,
  });
}

class CourseStoreMainController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'Semua'.obs;
  final isLoading = false.obs;
  
  final allCourses = <Course>[].obs;
  final filteredCourses = <Course>[].obs;

  final filters = [
    'Semua',
    'Programming',
    'Design',
    'Business',
    'Marketing',
    'Data Science',
    'Mobile Development'
  ];

  @override
  void onInit() {
    super.onInit();
    loadCourses();
    
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

  void loadCourses() {
    isLoading.value = true;
    
    // Sample course data
    allCourses.value = [
      Course(
        id: '1',
        title: 'Flutter Development Masterclass',
        instructor: 'Dr. Ahmad Wijaya',
        category: 'Programming',
        description: 'Belajar Flutter dari dasar hingga mahir dengan project nyata',
        imageUrl: 'https://via.placeholder.com/300x200/4F46E5/FFFFFF?text=Flutter',
        rating: 4.8,
        totalStudents: 1250,
        totalLessons: 45,
        duration: '12 jam',
        price: 299000,
        isFree: false,
        level: 'Pemula',
      ),
      Course(
        id: '2',
        title: 'UI/UX Design Fundamentals',
        instructor: 'Sarah Putri',
        category: 'Design',
        description: 'Pelajari prinsip desain UI/UX yang efektif dan modern',
        imageUrl: 'https://via.placeholder.com/300x200/3B82F6/FFFFFF?text=UI%2FUX',
        rating: 4.9,
        totalStudents: 890,
        totalLessons: 32,
        duration: '8 jam',
        price: 199000,
        isFree: false,
        level: 'Pemula',
      ),
      Course(
        id: '3',
        title: 'Digital Marketing Strategy',
        instructor: 'Budi Santoso',
        category: 'Marketing',
        description: 'Strategi pemasaran digital yang terbukti efektif',
        imageUrl: 'https://via.placeholder.com/300x200/A855F7/FFFFFF?text=Marketing',
        rating: 4.7,
        totalStudents: 2100,
        totalLessons: 28,
        duration: '6 jam',
        price: 0,
        isFree: true,
        level: 'Menengah',
      ),
      Course(
        id: '4',
        title: 'Python for Data Science',
        instructor: 'Prof. Lisa Chen',
        category: 'Data Science',
        description: 'Analisis data menggunakan Python dan library populer',
        imageUrl: 'https://via.placeholder.com/300x200/10B981/FFFFFF?text=Python',
        rating: 4.6,
        totalStudents: 1580,
        totalLessons: 38,
        duration: '15 jam',
        price: 399000,
        isFree: false,
        level: 'Menengah',
      ),
      Course(
        id: '5',
        title: 'Business Strategy & Planning',
        instructor: 'Michael Johnson',
        category: 'Business',
        description: 'Strategi bisnis untuk startup dan perusahaan kecil',
        imageUrl: 'https://via.placeholder.com/300x200/F59E0B/FFFFFF?text=Business',
        rating: 4.5,
        totalStudents: 750,
        totalLessons: 25,
        duration: '10 jam',
        price: 249000,
        isFree: false,
        level: 'Lanjutan',
      ),
      Course(
        id: '6',
        title: 'React Native Development',
        instructor: 'Kevin Pratama',
        category: 'Mobile Development',
        description: 'Membangun aplikasi mobile dengan React Native',
        imageUrl: 'https://via.placeholder.com/300x200/EF4444/FFFFFF?text=React',
        rating: 4.7,
        totalStudents: 920,
        totalLessons: 42,
        duration: '14 jam',
        price: 349000,
        isFree: false,
        level: 'Menengah',
      ),
    ];
    
    filteredCourses.value = allCourses;
    isLoading.value = false;
  }

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

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }
}
