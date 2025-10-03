import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Certification {
  final String id;
  final String title;
  final String provider;
  final String category;
  final String description;
  final String imageUrl;
  final double rating;
  final int totalParticipants;
  final int totalModules;
  final String duration;
  final int originalPrice;
  final int discountedPrice;
  final bool isFree;
  final String level;
  final String discount;
  final bool showDiscount;
  final String validityPeriod;
  final int totalReviews;
  final List<String> benefits;
  final List<String> requirements;

  Certification({
    required this.id,
    required this.title,
    required this.provider,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.totalParticipants,
    required this.totalModules,
    required this.duration,
    required this.originalPrice,
    required this.discountedPrice,
    required this.isFree,
    required this.level,
    required this.discount,
    required this.showDiscount,
    required this.validityPeriod,
    required this.totalReviews,
    required this.benefits,
    required this.requirements,
  });

  // Getter for backward compatibility
  int get price => showDiscount && discountedPrice > 0 ? discountedPrice : originalPrice;
}

class CertificationStoreMainController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'Semua'.obs;
  final isLoading = false.obs;
  
  final allCertifications = <Certification>[].obs;
  final filteredCertifications = <Certification>[].obs;

  final filters = [
    'Semua',
    'IT & Programming',
    'Digital Marketing',
    'Data Analytics',
    'Project Management',
    'Cyber Security',
    'Cloud Computing'
  ];

  @override
  void onInit() {
    super.onInit();
    loadCertifications();
    
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

  void loadCertifications() {
    isLoading.value = true;
    
    // Sample certification data
    allCertifications.value = [
      Certification(
        id: '1',
        title: 'Certified Flutter Developer',
        provider: 'Google Developers',
        category: 'IT & Programming',
        description: 'Sertifikasi resmi pengembangan aplikasi mobile dengan Flutter',
        imageUrl: 'https://via.placeholder.com/300x200/4F46E5/FFFFFF?text=Flutter',
        rating: 4.9,
        totalParticipants: 2500,
        totalModules: 12,
        duration: '3 bulan',
        originalPrice: 1500000,
        discountedPrice: 750000,
        isFree: false,
        level: 'Menengah',
        discount: '50% Off',
        showDiscount: true,
        validityPeriod: '2 tahun',
        totalReviews: 1850,
        benefits: [
          'Sertifikat resmi dari Google Developers',
          'Pengakuan industri internasional',
          'Akses ke komunitas Flutter developer',
          'Portfolio project yang dapat dipamerkan',
          'Peningkatan peluang karir sebagai mobile developer'
        ],
        requirements: [
          'Pengalaman dasar pemrograman Dart',
          'Pemahaman konsep OOP',
          'Akses komputer dengan spesifikasi memadai',
          'Koneksi internet stabil untuk ujian online'
        ],
      ),
      Certification(
        id: '2',
        title: 'Digital Marketing Professional',
        provider: 'Meta Blueprint',
        category: 'Digital Marketing',
        description: 'Sertifikasi profesional pemasaran digital dari Meta',
        imageUrl: 'https://via.placeholder.com/300x200/3B82F6/FFFFFF?text=Marketing',
        rating: 4.8,
        totalParticipants: 3200,
        totalModules: 8,
        duration: '2 bulan',
        originalPrice: 800000,
        discountedPrice: 400000,
        isFree: false,
        level: 'Pemula',
        discount: '50% Off',
        showDiscount: true,
        validityPeriod: '1 tahun',
        totalReviews: 2450,
        benefits: [
          'Sertifikat resmi Meta Blueprint',
          'Kredibilitas dalam digital marketing',
          'Akses ke tools dan resource eksklusif',
          'Networking dengan profesional marketing',
          'Update terbaru tentang platform Meta'
        ],
        requirements: [
          'Pengalaman dasar marketing',
          'Pemahaman media sosial',
          'Akses ke platform Meta (Facebook/Instagram)',
          'Kemampuan analisis data dasar'
        ],
      ),
      Certification(
        id: '3',
        title: 'Google Analytics Certified',
        provider: 'Google Analytics',
        category: 'Data Analytics',
        description: 'Sertifikasi analisis data dengan Google Analytics',
        imageUrl: 'https://via.placeholder.com/300x200/10B981/FFFFFF?text=Analytics',
        rating: 4.7,
        totalParticipants: 5600,
        totalModules: 6,
        duration: '1 bulan',
        originalPrice: 0,
        discountedPrice: 0,
        isFree: true,
        level: 'Pemula',
        discount: '',
        showDiscount: false,
        validityPeriod: '1 tahun',
        totalReviews: 4200,
        benefits: [
          'Sertifikat gratis dari Google',
          'Pemahaman mendalam Google Analytics',
          'Skill analisis data website',
          'Peningkatan value sebagai digital marketer',
          'Akses ke Google Analytics Academy'
        ],
        requirements: [
          'Akun Google',
          'Pemahaman dasar website',
          'Kemampuan berpikir analitis',
          'Tidak ada biaya pendaftaran'
        ],
      ),
      Certification(
        id: '4',
        title: 'PMP Certification',
        provider: 'Project Management Institute',
        category: 'Project Management',
        description: 'Sertifikasi manajemen proyek profesional internasional',
        imageUrl: 'https://via.placeholder.com/300x200/F59E0B/FFFFFF?text=PMP',
        rating: 4.9,
        totalParticipants: 1800,
        totalModules: 15,
        duration: '4 bulan',
        originalPrice: 2500000,
        discountedPrice: 0,
        isFree: false,
        level: 'Lanjutan',
        discount: '',
        showDiscount: false,
        validityPeriod: '3 tahun',
        totalReviews: 1320,
        benefits: [
          'Sertifikat PMP yang diakui global',
          'Peningkatan salary hingga 25%',
          'Kredibilitas sebagai project manager',
          'Akses ke PMI community',
          'Continuing education opportunities'
        ],
        requirements: [
          'Pengalaman project management 3+ tahun',
          'Pendidikan minimal S1',
          '35 jam training project management',
          'Biaya ujian dan maintenance'
        ],
      ),
      Certification(
        id: '5',
        title: 'AWS Cloud Practitioner',
        provider: 'Amazon Web Services',
        category: 'Cloud Computing',
        description: 'Sertifikasi dasar layanan cloud computing AWS',
        imageUrl: 'https://via.placeholder.com/300x200/EF4444/FFFFFF?text=AWS',
        rating: 4.6,
        totalParticipants: 4200,
        totalModules: 10,
        duration: '2 bulan',
        originalPrice: 1200000,
        discountedPrice: 840000,
        isFree: false,
        level: 'Pemula',
        discount: '30% Off',
        showDiscount: true,
        validityPeriod: '3 tahun',
        totalReviews: 3150,
        benefits: [
          'Sertifikat AWS resmi',
          'Pemahaman cloud computing fundamentals',
          'Peluang karir di cloud technology',
          'Akses ke AWS training resources',
          'Foundation untuk sertifikasi AWS lanjutan'
        ],
        requirements: [
          'Pemahaman dasar IT',
          'Pengalaman dengan teknologi cloud (opsional)',
          'Kemampuan bahasa Inggris',
          'Akses komputer untuk ujian online'
        ],
      ),
      Certification(
        id: '6',
        title: 'Certified Ethical Hacker',
        provider: 'EC-Council',
        category: 'Cyber Security',
        description: 'Sertifikasi keamanan siber dan ethical hacking',
        imageUrl: 'https://via.placeholder.com/300x200/A855F7/FFFFFF?text=Security',
        rating: 4.8,
        totalParticipants: 1500,
        totalModules: 18,
        duration: '6 bulan',
        originalPrice: 3500000,
        discountedPrice: 2800000,
        isFree: false,
        level: 'Lanjutan',
        discount: '20% Off',
        showDiscount: true,
        validityPeriod: '3 tahun',
        totalReviews: 1180,
        benefits: [
          'Sertifikat CEH yang diakui industri',
          'Expertise dalam ethical hacking',
          'Peluang karir cybersecurity specialist',
          'Akses ke EC-Council community',
          'Continuing education credits'
        ],
        requirements: [
          'Pengalaman IT/Security minimal 2 tahun',
          'Pemahaman networking dan sistem operasi',
          'Background teknis yang kuat',
          'Komitmen untuk etika hacking'
        ],
      ),
    ];
    
    filteredCertifications.value = allCertifications;
    isLoading.value = false;
  }

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

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }
}
