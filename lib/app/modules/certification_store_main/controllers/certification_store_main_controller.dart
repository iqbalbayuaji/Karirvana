import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/certification_model.dart';
import '../../../services/firebase_course_service.dart';

// Note: Certification model is now imported from certification_model.dart

class CertificationStoreMainController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'Semua'.obs;
  final isLoading = false.obs;
  
  final allCertifications = <Certification>[].obs;
  final filteredCertifications = <Certification>[].obs;
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
    
    
    // Initialize Firebase with custom IDs first
    _initializeFirebaseWithCustomIds();
    
    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterCertifications();
    });
    
    // Listen to filter changes
    ever(selectedFilter, (_) => filterCertifications());
    ever(searchQuery, (_) => filterCertifications());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Load certifications from Firebase
  Future<void> loadCertifications() async {
    // Prevent multiple simultaneous loads
    if (isLoading.value) return;
    
    try {
      isLoading.value = true;
      
      final certifications = await _courseService.getAllCertifications();
      
      allCertifications.value = certifications;
      filteredCertifications.value = certifications;
      
      print('✅ Loaded ${certifications.length} certifications from Firebase');
      
    } catch (e) {
      print('❌ Error loading certifications: $e');
      
      // Show error message
      Get.snackbar(
        'Error',
        'Gagal memuat data sertifikasi: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: const Color(0xFFFFFFFF),
      );
      
      // Keep empty list on error
      allCertifications.value = [];
      filteredCertifications.value = [];
      
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Load categories from Firebase
  Future<void> loadCategories() async {
    try {
      final categories = await _courseService.getCertificationCategories();
      
      if (categories.isNotEmpty) {
        filters.value = ['Semua', ...categories];
        print('✅ Loaded ${categories.length} certification categories from Firebase');
      }
      
    } catch (e) {
      print('❌ Error loading categories: $e');
      // Keep existing categories to prevent duplication
    }
  }


  /// Filter certifications based on category and search query
  void filterCertifications() {
    List<Certification> filtered = allCertifications;
    
    // Filter by category
    if (selectedFilter.value != 'Semua') {
      filtered = filtered.where((certification) => 
        certification.category == selectedFilter.value).toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((certification) =>
        certification.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        certification.provider.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        certification.description.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    filteredCertifications.value = filtered;
  }
  
  /// Search certifications using Firebase service
  Future<void> searchCertifications(String query) async {
    try {
      isLoading.value = true;
      
      final certifications = await _courseService.searchCertifications(query);
      filteredCertifications.value = certifications;
      
    } catch (e) {
      print('❌ Error searching certifications: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Get certifications by category from Firebase
  Future<void> getCertificationsByCategory(String category) async {
    if (category == 'Semua') {
      await loadCertifications();
      return;
    }
    
    try {
      isLoading.value = true;
      
      final certifications = await _courseService.getCertificationsByCategory(category);
      filteredCertifications.value = certifications;
      
    } catch (e) {
      print('❌ Error getting certifications by category: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Refresh certifications data
  Future<void> refreshCertifications() async {
    await loadCertifications();
    await loadCategories();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  /// Initialize Firebase with custom IDs (cert_1, cert_2, etc.)
  Future<void> _initializeFirebaseWithCustomIds() async {
    try {
      // Check if Firebase already has certification data
      final existingCertifications = await _courseService.getAllCertifications();
      
      if (existingCertifications.isEmpty) {
        print('🔥 Firebase empty, initializing with custom IDs...');
        
        // Add each sample certification to Firebase with custom IDs
        final sampleCertifications = _getSampleCertifications();
        for (var cert in sampleCertifications) {
          // Use addCertificationWithId to set custom document ID
          await _courseService.addCertificationWithId(cert.id, cert);
        }
        
        print('✅ Firebase initialized with ${sampleCertifications.length} certifications using custom IDs');
      } else {
        print('✅ Firebase already has ${existingCertifications.length} certifications');
      }
      
      // Load certifications after initialization
      await loadCertifications();
      
      // Skip categories loading to prevent duplication
      // await loadCategories();
      
    } catch (e) {
      print('❌ Error initializing Firebase: $e');
      
      // Fallback to sample data
      final sampleData = _getSampleCertifications();
      allCertifications.value = sampleData;
      filteredCertifications.value = sampleData;
    }
  }

  /// Get sample certifications with custom IDs
  List<Certification> _getSampleCertifications() {
    final now = DateTime.now();
    return [
      Certification(
        id: 'cert_1',
        title: 'Flutter Developer Certification',
        provider: 'Google',
        category: 'IT & Programming',
        description: 'Sertifikasi resmi untuk pengembang Flutter dari Google. Memvalidasi kemampuan dalam membangun aplikasi mobile cross-platform.',
        price: 1250000,
        originalPrice: 2500000,
        discountPercentage: 50,
        rating: 4.8,
        totalReviews: 15420,
        duration: '3 bulan',
        level: 'Intermediate',
        imageUrl: 'assets/course/course-frontend-1.jpg',
        isFree: false,
        validityPeriod: '2 tahun',
        benefits: [
          'Sertifikat resmi dari Google',
          'Akses ke komunitas developer Flutter',
          'Materi pembelajaran terkini',
          'Project portfolio guidance',
          'Job placement assistance'
        ],
        requirements: [
          'Pengalaman dasar programming',
          'Familiar dengan Dart language',
          'Memiliki laptop/PC untuk development'
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Certification(
        id: 'cert_2',
        title: 'Digital Marketing Professional',
        provider: 'Meta',
        category: 'Digital Marketing',
        description: 'Sertifikasi digital marketing komprehensif yang mencakup social media, content marketing, dan advertising strategy.',
        price: 1800000,
        originalPrice: 1800000,
        discountPercentage: 0,
        rating: 4.7,
        totalReviews: 28350,
        duration: '2 bulan',
        level: 'Beginner',
        imageUrl: 'assets/course/course-marketing-1.png',
        isFree: false,
        validityPeriod: '1 tahun',
        benefits: [
          'Sertifikat dari Meta (Facebook)',
          'Akses ke Meta Business tools',
          'Campaign management training',
          'Analytics dan reporting skills',
          'Industry networking opportunities'
        ],
        requirements: [
          'Tidak ada pengalaman khusus diperlukan',
          'Akses internet stabil',
          'Motivasi untuk belajar digital marketing'
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Certification(
        id: 'cert_3',
        title: 'Google Analytics Certified',
        provider: 'Google',
        category: 'Data Analytics',
        description: 'Sertifikasi resmi Google Analytics untuk menguasai web analytics, data interpretation, dan digital marketing insights.',
        price: 0,
        originalPrice: 0,
        discountPercentage: 0,
        rating: 4.9,
        totalReviews: 45670,
        duration: '1 bulan',
        level: 'Beginner',
        imageUrl: 'assets/course/course-python.jpg',
        isFree: true,
        validityPeriod: '1 tahun',
        benefits: [
          'Sertifikat gratis dari Google',
          'Skill web analytics profesional',
          'Understanding customer behavior',
          'Data-driven decision making',
          'Career advancement opportunities'
        ],
        requirements: [
          'Basic computer skills',
          'Interest in data analysis',
          'Google account'
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Certification(
        id: 'cert_4',
        title: 'Project Management Professional (PMP)',
        provider: 'PMI',
        category: 'Business',
        description: 'Sertifikasi manajemen proyek paling bergengsi di dunia. Diakui secara global untuk project manager profesional.',
        price: 6800000,
        originalPrice: 8500000,
        discountPercentage: 20,
        rating: 4.6,
        totalReviews: 12890,
        duration: '6 bulan',
        level: 'Advanced',
        imageUrl: 'assets/course/course-akuntansi-1.jpg',
        isFree: false,
        validityPeriod: '3 tahun',
        benefits: [
          'Sertifikasi global PMI',
          'Peningkatan salary potential',
          'Professional credibility',
          'Networking dengan PM professionals',
          'Continuing education support'
        ],
        requirements: [
          'Bachelor degree atau equivalent',
          '3+ tahun pengalaman project management',
          '35 jam formal project management education'
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Certification(
        id: 'cert_5',
        title: 'AWS Cloud Practitioner',
        provider: 'Amazon Web Services',
        category: 'IT & Programming',
        description: 'Sertifikasi entry-level AWS untuk memahami cloud computing fundamentals dan AWS core services.',
        price: 1200000,
        originalPrice: 1500000,
        discountPercentage: 20,
        rating: 4.5,
        totalReviews: 32150,
        duration: '2 bulan',
        level: 'Beginner',
        imageUrl: 'assets/course/course-frontend-1.jpg',
        isFree: false,
        validityPeriod: '3 tahun',
        benefits: [
          'AWS official certification',
          'Cloud computing expertise',
          'Industry-recognized credential',
          'Career opportunities in cloud',
          'Access to AWS community'
        ],
        requirements: [
          'Basic IT knowledge',
          'Interest in cloud technology',
          'No prior AWS experience needed'
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Certification(
        id: 'cert_6',
        title: 'Certified Ethical Hacker (CEH)',
        provider: 'EC-Council',
        category: 'Cyber Security',
        description: 'Sertifikasi cybersecurity untuk ethical hacking dan penetration testing. Diakui industri untuk security professionals.',
        price: 9600000,
        originalPrice: 12000000,
        discountPercentage: 20,
        rating: 4.7,
        totalReviews: 8750,
        duration: '4 bulan',
        level: 'Advanced',
        imageUrl: 'assets/course/course-programming-1.jpg',
        isFree: false,
        validityPeriod: '3 tahun',
        benefits: [
          'EC-Council official certification',
          'Ethical hacking expertise',
          'Penetration testing skills',
          'High-demand security career',
          'Professional recognition'
        ],
        requirements: [
          'Networking fundamentals',
          'Basic security knowledge',
          '2+ tahun IT experience recommended'
        ],
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

}
