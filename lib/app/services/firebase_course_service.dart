import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/course_model.dart';
import '../data/models/certification_model.dart';

class FirebaseCourseService {
  static final FirebaseCourseService _instance = FirebaseCourseService._internal();
  factory FirebaseCourseService() => _instance;
  FirebaseCourseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String coursesCollection = 'courses';
  static const String certificationsCollection = 'certifications';
  static const String courseCategoriesCollection = 'course_categories';
  static const String certificationCategoriesCollection = 'certification_categories';

  // ==================== COURSE METHODS ====================

  /// Get all courses
  Future<List<Course>> getAllCourses() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(coursesCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting courses: $e');
      return [];
    }
  }

  /// Get courses by category
  Future<List<Course>> getCoursesByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(coursesCollection)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting courses by category: $e');
      return [];
    }
  }

  /// Get course by ID
  Future<Course?> getCourseById(String courseId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(coursesCollection)
          .doc(courseId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting course by ID: $e');
      return null;
    }
  }

  /// Add new course
  Future<String?> addCourse(Course course) async {
    try {
      final docRef = await _firestore
          .collection(coursesCollection)
          .add(course.toJson());
      return docRef.id;
    } catch (e) {
      print('Error adding course: $e');
      return null;
    }
  }

  /// Update course
  Future<bool> updateCourse(String courseId, Course course) async {
    try {
      await _firestore
          .collection(coursesCollection)
          .doc(courseId)
          .update(course.toJson());
      return true;
    } catch (e) {
      print('Error updating course: $e');
      return false;
    }
  }

  /// Delete course
  Future<bool> deleteCourse(String courseId) async {
    try {
      await _firestore
          .collection(coursesCollection)
          .doc(courseId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting course: $e');
      return false;
    }
  }

  /// Search courses
  Future<List<Course>> searchCourses(String query) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(coursesCollection)
          .get();

      final courses = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }).toList();

      // Filter courses based on search query
      return courses.where((course) {
        return course.title.toLowerCase().contains(query.toLowerCase()) ||
               course.instructor.toLowerCase().contains(query.toLowerCase()) ||
               course.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print('Error searching courses: $e');
      return [];
    }
  }

  // ==================== CERTIFICATION METHODS ====================

  /// Get all certifications
  Future<List<Certification>> getAllCertifications() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(certificationsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Certification.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting certifications: $e');
      return [];
    }
  }

  /// Get certifications by category
  Future<List<Certification>> getCertificationsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(certificationsCollection)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Certification.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting certifications by category: $e');
      return [];
    }
  }

  /// Get certification by ID
  Future<Certification?> getCertificationById(String certificationId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(certificationsCollection)
          .doc(certificationId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Certification.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting certification by ID: $e');
      return null;
    }
  }

  /// Add new certification
  Future<String?> addCertification(Certification certification) async {
    try {
      final docRef = await _firestore
          .collection(certificationsCollection)
          .add(certification.toJson());
      return docRef.id;
    } catch (e) {
      print('Error adding certification: $e');
      return null;
    }
  }

  /// Add new certification with custom ID
  Future<bool> addCertificationWithId(String id, Certification certification) async {
    try {
      await _firestore
          .collection(certificationsCollection)
          .doc(id)
          .set(certification.toJson());
      return true;
    } catch (e) {
      print('Error adding certification with ID: $e');
      return false;
    }
  }

  /// Update certification
  Future<bool> updateCertification(String certificationId, Certification certification) async {
    try {
      await _firestore
          .collection(certificationsCollection)
          .doc(certificationId)
          .update(certification.toJson());
      return true;
    } catch (e) {
      print('Error updating certification: $e');
      return false;
    }
  }

  /// Delete certification
  Future<bool> deleteCertification(String certificationId) async {
    try {
      await _firestore
          .collection(certificationsCollection)
          .doc(certificationId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting certification: $e');
      return false;
    }
  }

  /// Search certifications
  Future<List<Certification>> searchCertifications(String query) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(certificationsCollection)
          .get();

      final certifications = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Certification.fromJson(data);
      }).toList();

      // Filter certifications based on search query
      return certifications.where((cert) {
        return cert.title.toLowerCase().contains(query.toLowerCase()) ||
               cert.provider.toLowerCase().contains(query.toLowerCase()) ||
               cert.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print('Error searching certifications: $e');
      return [];
    }
  }

  // ==================== CATEGORY METHODS ====================

  /// Get course categories
  Future<List<String>> getCourseCategories() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(courseCategoriesCollection)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'] as String;
      }).toList();
    } catch (e) {
      print('Error getting course categories: $e');
      return ['Semua', 'Programming', 'Design', 'Marketing', 'Data Science', 'Business'];
    }
  }

  /// Get certification categories
  Future<List<String>> getCertificationCategories() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(certificationCategoriesCollection)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'] as String;
      }).toList();
    } catch (e) {
      print('Error getting certification categories: $e');
      return ['Semua', 'IT & Programming', 'Digital Marketing', 'Data Analytics', 'Business', 'Design'];
    }
  }

  // ==================== BATCH OPERATIONS ====================

  /// Initialize default data (run once to populate Firebase)
  Future<void> initializeDefaultData() async {
    try {
      // Check if data already exists
      final coursesSnapshot = await _firestore.collection(coursesCollection).limit(1).get();
      final certificationsSnapshot = await _firestore.collection(certificationsCollection).limit(1).get();

      if (coursesSnapshot.docs.isEmpty) {
        await _initializeCourseData();
        print('Course data initialized successfully');
      }

      if (certificationsSnapshot.docs.isEmpty) {
        await _initializeCertificationData();
        print('Certification data initialized successfully');
      }

      await _initializeCategoryData();
      print('Category data initialized successfully');

    } catch (e) {
      print('Error initializing default data: $e');
    }
  }

  /// Initialize course data
  Future<void> _initializeCourseData() async {
    final courses = _getDefaultCourses();
    
    for (final course in courses) {
      await addCourse(course);
    }
  }

  /// Initialize certification data
  Future<void> _initializeCertificationData() async {
    final certifications = _getDefaultCertifications();
    
    for (final certification in certifications) {
      await addCertification(certification);
    }
  }

  /// Initialize category data
  Future<void> _initializeCategoryData() async {
    // Course categories
    final courseCategories = ['Programming', 'Design', 'Marketing', 'Data Science', 'Business'];
    for (final category in courseCategories) {
      await _firestore.collection(courseCategoriesCollection).add({
        'name': category,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // Certification categories
    final certificationCategories = ['IT & Programming', 'Digital Marketing', 'Data Analytics', 'Business', 'Design'];
    for (final category in certificationCategories) {
      await _firestore.collection(certificationCategoriesCollection).add({
        'name': category,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Get default courses data
  List<Course> _getDefaultCourses() {
    return [
      Course(
        id: '',
        title: 'Flutter Development Masterclass',
        instructor: 'Dr. Ahmad Wijaya',
        description: 'Pelajari Flutter dari dasar hingga mahir. Kursus lengkap untuk membuat aplikasi mobile cross-platform yang profesional.',
        price: 350000,
        originalPrice: 350000,
        discountPercentage: 50,
        rating: 4.8,
        totalReviews: 1250,
        duration: '40 jam',
        level: 'Pemula',
        category: 'Programming',
        imageUrl: 'assets/course/course-frontend-1.jpg',
        isFree: false,
        isPopular: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Course(
        id: '',
        title: 'UI/UX Design Fundamentals',
        instructor: 'Sarah Putri',
        description: 'Kuasai prinsip-prinsip desain UI/UX modern. Dari wireframing hingga prototyping dengan tools profesional.',
        price: 250000,
        originalPrice: 250000,
        discountPercentage: 50,
        rating: 4.7,
        totalReviews: 890,
        duration: '30 jam',
        level: 'Pemula',
        category: 'Design',
        imageUrl: 'assets/course/course-uiux-1.jpg',
        isFree: false,
        isPopular: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Course(
        id: '',
        title: 'Digital Marketing Strategy',
        instructor: 'Budi Santoso',
        description: 'Strategi pemasaran digital terkini. Pelajari SEO, SEM, Social Media Marketing, dan Content Marketing.',
        price: 0,
        originalPrice: 299000,
        discountPercentage: 0,
        rating: 4.6,
        totalReviews: 654,
        duration: '25 jam',
        level: 'Pemula',
        category: 'Marketing',
        imageUrl: 'assets/course/course-marketing-1.png',
        isFree: true,
        isPopular: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Course(
        id: '',
        title: 'Python for Data Science',
        instructor: 'Prof. Lisa Chen',
        description: 'Analisis data dengan Python. Pandas, NumPy, Matplotlib, dan machine learning untuk data scientist.',
        price: 399000,
        originalPrice: 399000,
        discountPercentage: 0,
        rating: 4.9,
        totalReviews: 2100,
        duration: '50 jam',
        level: 'Menengah',
        category: 'Data Science',
        imageUrl: 'assets/course/course-python.jpg',
        isFree: false,
        isPopular: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Course(
        id: '',
        title: 'Business Strategy & Planning',
        instructor: 'Michael Johnson',
        description: 'Perencanaan strategis bisnis modern. Market analysis, competitive strategy, dan business model canvas.',
        price: 300000,
        originalPrice: 300000,
        discountPercentage: 40,
        rating: 4.5,
        totalReviews: 432,
        duration: '35 jam',
        level: 'Menengah',
        category: 'Business',
        imageUrl: 'assets/course/course-akuntansi-1.jpg',
        isFree: false,
        isPopular: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Course(
        id: '',
        title: 'React Native Development',
        instructor: 'Kevin Pratama',
        description: 'Bangun aplikasi mobile dengan React Native. JavaScript, Redux, Navigation, dan deployment ke App Store.',
        price: 349000,
        originalPrice: 349000,
        discountPercentage: 0,
        rating: 4.7,
        totalReviews: 876,
        duration: '45 jam',
        level: 'Menengah',
        category: 'Programming',
        imageUrl: 'assets/course/course-programming-1.jpg',
        isFree: false,
        isPopular: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Get default certifications data
  List<Certification> _getDefaultCertifications() {
    return [
      Certification(
        id: '',
        title: 'Certified Flutter Developer',
        provider: 'Google Developer Certification',
        description: 'Sertifikasi resmi Google untuk Flutter Developer. Validasi kemampuan Anda dalam pengembangan aplikasi mobile cross-platform.',
        price: 1500000,
        originalPrice: 1500000,
        discountPercentage: 0,
        rating: 4.9,
        totalReviews: 450,
        duration: '3 bulan',
        level: 'Menengah',
        category: 'IT & Programming',
        imageUrl: 'assets/course/course-frontend-1.jpg',
        isFree: false,
        validityPeriod: '2 tahun',
        benefits: [
          'Sertifikat resmi Google',
          'Badge LinkedIn',
          'Akses komunitas eksklusif',
          'Job placement assistance'
        ],
        requirements: [
          'Pengalaman Flutter min 6 bulan',
          'Portfolio 3 aplikasi',
          'Lulus pre-assessment'
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Certification(
        id: '',
        title: 'UI/UX Design Professional',
        provider: 'Adobe Certified Expert',
        description: 'Sertifikasi profesional UI/UX Design dari Adobe. Buktikan keahlian Anda dalam design thinking dan user experience.',
        price: 1200000,
        originalPrice: 1500000,
        discountPercentage: 20,
        rating: 4.8,
        totalReviews: 320,
        duration: '2 bulan',
        level: 'Menengah',
        category: 'Design',
        imageUrl: 'assets/course/course-uiux-1.jpg',
        isFree: false,
        validityPeriod: '3 tahun',
        benefits: [
          'Sertifikat Adobe resmi',
          'Portfolio review',
          'Mentoring session',
          'Industry networking'
        ],
        requirements: [
          'Basic design knowledge',
          'Adobe Creative Suite',
          'Design portfolio'
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Certification(
        id: '',
        title: 'Digital Marketing Specialist',
        provider: 'Google Digital Marketing',
        description: 'Sertifikasi Google untuk Digital Marketing. Kuasai Google Ads, Analytics, dan strategi pemasaran digital terkini.',
        price: 0,
        originalPrice: 800000,
        discountPercentage: 0,
        rating: 4.7,
        totalReviews: 890,
        duration: '1 bulan',
        level: 'Pemula',
        category: 'Digital Marketing',
        imageUrl: 'assets/course/course-marketing-1.png',
        isFree: true,
        validityPeriod: '1 tahun',
        benefits: [
          'Google certification',
          'Career support',
          'Industry recognition',
          'Free resources'
        ],
        requirements: [
          'Basic marketing knowledge',
          'Google account',
          'Complete coursework'
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Certification(
        id: '',
        title: 'Data Analytics Professional',
        provider: 'IBM Data Science',
        description: 'Sertifikasi IBM untuk Data Analytics. Python, SQL, machine learning, dan data visualization untuk karir data analyst.',
        price: 2000000,
        originalPrice: 2000000,
        discountPercentage: 0,
        rating: 4.9,
        totalReviews: 650,
        duration: '4 bulan',
        level: 'Menengah',
        category: 'Data Analytics',
        imageUrl: 'assets/course/course-python.jpg',
        isFree: false,
        validityPeriod: '2 tahun',
        benefits: [
          'IBM certification',
          'Capstone project',
          'Job placement',
          'Alumni network'
        ],
        requirements: [
          'Basic programming',
          'Statistics knowledge',
          'Commitment 10 jam/minggu'
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Certification(
        id: '',
        title: 'Business Analysis Fundamentals',
        provider: 'Microsoft Business',
        description: 'Sertifikasi Microsoft untuk Business Analyst. Process improvement, requirements gathering, dan stakeholder management.',
        price: 1800000,
        originalPrice: 2200000,
        discountPercentage: 18,
        rating: 4.6,
        totalReviews: 280,
        duration: '3 bulan',
        level: 'Pemula',
        category: 'Business',
        imageUrl: 'assets/course/course-akuntansi-1.jpg',
        isFree: false,
        validityPeriod: '2 tahun',
        benefits: [
          'Microsoft certification',
          'Case study projects',
          'Mentor guidance',
          'Career coaching'
        ],
        requirements: [
          'Business experience',
          'Analytical thinking',
          'Communication skills'
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Certification(
        id: '',
        title: 'Cloud Computing AWS',
        provider: 'Amazon Web Services',
        description: 'Sertifikasi AWS Cloud Practitioner. Dasar-dasar cloud computing, AWS services, dan best practices untuk cloud architecture.',
        price: 1650000,
        originalPrice: 1650000,
        discountPercentage: 0,
        rating: 4.8,
        totalReviews: 1200,
        duration: '2 bulan',
        level: 'Pemula',
        category: 'IT & Programming',
        imageUrl: 'assets/course/course-backend-1.webp',
        isFree: false,
        validityPeriod: '3 tahun',
        benefits: [
          'AWS certification',
          'Hands-on labs',
          'Cloud credits',
          'Job opportunities'
        ],
        requirements: [
          'Basic IT knowledge',
          'AWS account',
          'Study commitment'
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
