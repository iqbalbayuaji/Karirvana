import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseLesson {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final int durationMinutes;
  final bool isCompleted;
  final bool isLocked;

  CourseLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.durationMinutes,
    this.isCompleted = false,
    this.isLocked = false,
  });
}

class CourseModule {
  final String id;
  final String title;
  final String description;
  final List<CourseLesson> lessons;
  final bool isCompleted;
  final int totalDurationMinutes;

  CourseModule({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    this.isCompleted = false,
  }) : totalDurationMinutes = lessons.fold(0, (sum, lesson) => sum + lesson.durationMinutes);

  int get completedLessons => lessons.where((lesson) => lesson.isCompleted).length;
  double get progressPercentage => lessons.isEmpty ? 0.0 : (completedLessons / lessons.length) * 100;
}

class Course {
  final String id;
  final String title;
  final String instructor;
  final String instructorBio;
  final String instructorImage;
  final String category;
  final String description;
  final String imageUrl;
  final double rating;
  final int totalStudents;
  final int totalLessons;
  final String duration;
  final int originalPrice;
  final int discountedPrice;
  final bool isFree;
  final String level;
  final String discount;
  final bool showDiscount;
  final List<CourseModule> modules;
  final List<String> requirements;
  final List<String> whatYouWillLearn;
  final String language;
  final bool hasCertificate;
  final int totalReviews;

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.instructorBio,
    required this.instructorImage,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.totalStudents,
    required this.totalLessons,
    required this.duration,
    required this.originalPrice,
    required this.discountedPrice,
    required this.isFree,
    required this.level,
    required this.discount,
    required this.showDiscount,
    required this.modules,
    required this.requirements,
    required this.whatYouWillLearn,
    required this.language,
    required this.hasCertificate,
    required this.totalReviews,
  });

  // Getter for backward compatibility
  int get price => showDiscount && discountedPrice > 0 ? discountedPrice : originalPrice;
  
  // Calculate total duration from modules
  int get totalDurationMinutes => modules.fold(0, (sum, module) => sum + module.totalDurationMinutes);
  
  // Calculate progress percentage
  double get progressPercentage {
    if (modules.isEmpty) return 0.0;
    int totalLessons = modules.fold(0, (sum, module) => sum + module.lessons.length);
    int completedLessons = modules.fold(0, (sum, module) => sum + module.completedLessons);
    return totalLessons == 0 ? 0.0 : (completedLessons / totalLessons) * 100;
  }
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
    
    // Sample course data with modules
    allCourses.value = [
      Course(
        id: '1',
        title: 'Flutter Development Masterclass',
        instructor: 'Dr. Ahmad Wijaya',
        instructorBio: 'Senior Flutter Developer dengan 8+ tahun pengalaman. Telah mengembangkan 50+ aplikasi mobile dan mengajar 10,000+ siswa.',
        instructorImage: 'assets/images/instructor_ahmad.jpg',
        category: 'Programming',
        description: 'Belajar Flutter dari dasar hingga mahir dengan project nyata. Kursus komprehensif yang mencakup semua aspek pengembangan aplikasi mobile dengan Flutter.',
        imageUrl: 'https://via.placeholder.com/300x200/4F46E5/FFFFFF?text=Flutter',
        rating: 4.8,
        totalStudents: 1250,
        totalLessons: 45,
        duration: '12 jam',
        originalPrice: 350000,
        discountedPrice: 175000,
        isFree: false,
        level: 'Pemula',
        discount: '40% Off',
        showDiscount: true,
        language: 'Bahasa Indonesia',
        hasCertificate: true,
        totalReviews: 892,
        requirements: [
          'Komputer dengan RAM minimal 8GB',
          'Koneksi internet stabil',
          'Dasar pemrograman (opsional)',
          'Android Studio atau VS Code'
        ],
        whatYouWillLearn: [
          'Membangun aplikasi Flutter dari nol',
          'State management dengan Provider dan Bloc',
          'Integrasi API dan database',
          'Deployment ke Play Store dan App Store',
          'Best practices dalam pengembangan Flutter'
        ],
        modules: [
          CourseModule(
            id: 'mod1',
            title: 'Pengenalan Flutter',
            description: 'Dasar-dasar Flutter dan setup environment',
            lessons: [
              CourseLesson(
                id: 'les1',
                title: 'Apa itu Flutter?',
                description: 'Pengenalan framework Flutter dan keunggulannya',
                videoUrl: 'https://example.com/video1.mp4',
                durationMinutes: 15,
              ),
              CourseLesson(
                id: 'les2',
                title: 'Setup Development Environment',
                description: 'Instalasi Flutter SDK dan IDE',
                videoUrl: 'https://example.com/video2.mp4',
                durationMinutes: 25,
              ),
              CourseLesson(
                id: 'les3',
                title: 'Membuat Project Pertama',
                description: 'Membuat dan menjalankan aplikasi Flutter pertama',
                videoUrl: 'https://example.com/video3.mp4',
                durationMinutes: 20,
              ),
            ],
          ),
          CourseModule(
            id: 'mod2',
            title: 'Widget Dasar',
            description: 'Mempelajari widget-widget fundamental Flutter',
            lessons: [
              CourseLesson(
                id: 'les4',
                title: 'StatelessWidget vs StatefulWidget',
                description: 'Perbedaan dan penggunaan kedua jenis widget',
                videoUrl: 'https://example.com/video4.mp4',
                durationMinutes: 30,
              ),
              CourseLesson(
                id: 'les5',
                title: 'Layout Widgets',
                description: 'Container, Row, Column, dan Stack',
                videoUrl: 'https://example.com/video5.mp4',
                durationMinutes: 35,
              ),
            ],
          ),
          CourseModule(
            id: 'mod3',
            title: 'State Management',
            description: 'Mengelola state dalam aplikasi Flutter',
            lessons: [
              CourseLesson(
                id: 'les6',
                title: 'Provider Pattern',
                description: 'Implementasi Provider untuk state management',
                videoUrl: 'https://example.com/video6.mp4',
                durationMinutes: 40,
              ),
              CourseLesson(
                id: 'les7',
                title: 'Bloc Pattern',
                description: 'Advanced state management dengan Bloc',
                videoUrl: 'https://example.com/video7.mp4',
                durationMinutes: 45,
                isLocked: true,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '2',
        title: 'UI/UX Design Fundamentals',
        instructor: 'Sarah Putri',
        instructorBio: 'UI/UX Designer berpengalaman 6+ tahun di startup dan korporasi. Spesialis dalam user research dan design thinking.',
        instructorImage: 'assets/images/instructor_sarah.jpg',
        category: 'Design',
        description: 'Pelajari prinsip desain UI/UX yang efektif dan modern. Dari research hingga prototyping.',
        imageUrl: 'https://via.placeholder.com/300x200/3B82F6/FFFFFF?text=UI%2FUX',
        rating: 4.9,
        totalStudents: 890,
        totalLessons: 32,
        duration: '8 jam',
        originalPrice: 250000,
        discountedPrice: 125000,
        isFree: false,
        level: 'Pemula',
        discount: '50% Off',
        showDiscount: true,
        language: 'Bahasa Indonesia',
        hasCertificate: true,
        totalReviews: 743,
        requirements: [
          'Figma atau Adobe XD',
          'Kreativitas dan minat pada design',
          'Tidak perlu pengalaman sebelumnya'
        ],
        whatYouWillLearn: [
          'Prinsip dasar UI/UX Design',
          'User research dan persona',
          'Wireframing dan prototyping',
          'Design system dan style guide'
        ],
        modules: [
          CourseModule(
            id: 'mod1',
            title: 'Design Thinking',
            description: 'Metodologi design thinking dalam UI/UX',
            lessons: [
              CourseLesson(
                id: 'les1',
                title: 'Pengenalan Design Thinking',
                description: 'Konsep dan tahapan design thinking',
                videoUrl: 'https://example.com/video1.mp4',
                durationMinutes: 20,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '3',
        title: 'Digital Marketing Strategy',
        instructor: 'Budi Santoso',
        instructorBio: 'Digital Marketing Expert dengan track record mengelola campaign senilai miliaran rupiah.',
        instructorImage: 'assets/images/instructor_budi.jpg',
        category: 'Marketing',
        description: 'Strategi pemasaran digital yang terbukti efektif untuk bisnis modern',
        imageUrl: 'https://via.placeholder.com/300x200/A855F7/FFFFFF?text=Marketing',
        rating: 4.7,
        totalStudents: 2100,
        totalLessons: 28,
        duration: '6 jam',
        originalPrice: 0,
        discountedPrice: 0,
        isFree: true,
        level: 'Menengah',
        discount: '',
        showDiscount: false,
        language: 'Bahasa Indonesia',
        hasCertificate: false,
        totalReviews: 1456,
        requirements: [
          'Pemahaman dasar bisnis',
          'Akses ke platform media sosial'
        ],
        whatYouWillLearn: [
          'Strategi content marketing',
          'Social media advertising',
          'Email marketing automation',
          'Analytics dan ROI measurement'
        ],
        modules: [
          CourseModule(
            id: 'mod1',
            title: 'Digital Marketing Basics',
            description: 'Fundamental digital marketing',
            lessons: [
              CourseLesson(
                id: 'les1',
                title: 'Pengenalan Digital Marketing',
                description: 'Overview ekosistem digital marketing',
                videoUrl: 'https://example.com/video1.mp4',
                durationMinutes: 25,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '4',
        title: 'Python for Data Science',
        instructor: 'Prof. Lisa Chen',
        instructorBio: 'Professor Data Science dengan PhD dari Stanford. Peneliti AI dan Machine Learning.',
        instructorImage: 'assets/images/instructor_lisa.jpg',
        category: 'Data Science',
        description: 'Analisis data menggunakan Python dan library populer seperti Pandas, NumPy, dan Matplotlib',
        imageUrl: 'https://via.placeholder.com/300x200/10B981/FFFFFF?text=Python',
        rating: 4.6,
        totalStudents: 1580,
        totalLessons: 38,
        duration: '15 jam',
        originalPrice: 399000,
        discountedPrice: 0,
        isFree: false,
        level: 'Menengah',
        discount: '',
        showDiscount: false,
        language: 'Bahasa Indonesia',
        hasCertificate: true,
        totalReviews: 1203,
        requirements: [
          'Dasar pemrograman Python',
          'Matematika dasar (statistik)',
          'Jupyter Notebook'
        ],
        whatYouWillLearn: [
          'Data manipulation dengan Pandas',
          'Visualisasi data dengan Matplotlib',
          'Statistical analysis',
          'Machine learning basics'
        ],
        modules: [
          CourseModule(
            id: 'mod1',
            title: 'Python Basics for Data Science',
            description: 'Fundamental Python untuk data science',
            lessons: [
              CourseLesson(
                id: 'les1',
                title: 'Python Environment Setup',
                description: 'Setup Anaconda dan Jupyter Notebook',
                videoUrl: 'https://example.com/video1.mp4',
                durationMinutes: 30,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '5',
        title: 'Business Strategy & Planning',
        instructor: 'Michael Johnson',
        instructorBio: 'Business Consultant dan ex-McKinsey dengan pengalaman 12+ tahun membantu startup dan korporasi.',
        instructorImage: 'assets/images/instructor_michael.jpg',
        category: 'Business',
        description: 'Strategi bisnis untuk startup dan perusahaan kecil. Dari business model hingga execution.',
        imageUrl: 'https://via.placeholder.com/300x200/F59E0B/FFFFFF?text=Business',
        rating: 4.5,
        totalStudents: 750,
        totalLessons: 25,
        duration: '10 jam',
        originalPrice: 300000,
        discountedPrice: 180000,
        isFree: false,
        level: 'Lanjutan',
        discount: '40% Off',
        showDiscount: true,
        language: 'Bahasa Indonesia',
        hasCertificate: true,
        totalReviews: 567,
        requirements: [
          'Pengalaman bisnis minimal 2 tahun',
          'Pemahaman dasar keuangan',
          'Mindset entrepreneurial'
        ],
        whatYouWillLearn: [
          'Business model canvas',
          'Market analysis dan competitive intelligence',
          'Financial planning dan budgeting',
          'Strategic execution dan monitoring'
        ],
        modules: [
          CourseModule(
            id: 'mod1',
            title: 'Strategic Thinking',
            description: 'Framework berpikir strategis dalam bisnis',
            lessons: [
              CourseLesson(
                id: 'les1',
                title: 'Introduction to Strategy',
                description: 'Konsep dasar strategi bisnis',
                videoUrl: 'https://example.com/video1.mp4',
                durationMinutes: 35,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '6',
        title: 'React Native Development',
        instructor: 'Kevin Pratama',
        instructorBio: 'Senior Mobile Developer dengan expertise React Native. Telah mengembangkan 30+ aplikasi mobile.',
        instructorImage: 'assets/images/instructor_kevin.jpg',
        category: 'Mobile Development',
        description: 'Membangun aplikasi mobile dengan React Native. Cross-platform development yang efisien.',
        imageUrl: 'https://via.placeholder.com/300x200/EF4444/FFFFFF?text=React',
        rating: 4.7,
        totalStudents: 920,
        totalLessons: 42,
        duration: '14 jam',
        originalPrice: 349000,
        discountedPrice: 0,
        isFree: false,
        level: 'Menengah',
        discount: '',
        showDiscount: false,
        language: 'Bahasa Indonesia',
        hasCertificate: true,
        totalReviews: 678,
        requirements: [
          'Dasar JavaScript dan React',
          'Node.js dan npm',
          'Android Studio atau Xcode'
        ],
        whatYouWillLearn: [
          'React Native fundamentals',
          'Navigation dan state management',
          'Native modules integration',
          'App deployment dan distribution'
        ],
        modules: [
          CourseModule(
            id: 'mod1',
            title: 'React Native Basics',
            description: 'Fundamental React Native development',
            lessons: [
              CourseLesson(
                id: 'les1',
                title: 'Setup React Native Environment',
                description: 'Instalasi dan konfigurasi development environment',
                videoUrl: 'https://example.com/video1.mp4',
                durationMinutes: 25,
              ),
            ],
          ),
        ],
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
