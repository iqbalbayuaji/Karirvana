import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String title;
  final String instructor;
  final String description;
  final int price;
  final int originalPrice;
  final int discountPercentage;
  final double rating;
  final int totalReviews;
  final String duration;
  final String level;
  final String category;
  final String imageUrl;
  final bool isFree;
  final bool isPopular;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.rating,
    required this.totalReviews,
    required this.duration,
    required this.level,
    required this.category,
    required this.imageUrl,
    required this.isFree,
    required this.isPopular,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate discounted price
  int get discountedPrice {
    if (discountPercentage > 0) {
      return price - (price * discountPercentage ~/ 100);
    }
    return price;
  }

  // Check if course has discount
  bool get hasDiscount => discountPercentage > 0;

  // Get discount text
  String get discountText => hasDiscount ? '$discountPercentage% Off' : '';

  // Backward compatibility getters
  String get discount => discountText;
  bool get showDiscount => hasDiscount;
  
  // Additional properties for course store compatibility
  int get totalStudents => totalReviews; // Use totalReviews as totalStudents
  List<String> get whatYouWillLearn => [
    'Menguasai ${title} dari dasar hingga mahir',
    'Membangun project nyata',
    'Best practices dalam pengembangan',
    'Sertifikat completion'
  ];
  List<dynamic> get modules {
    // Generate modules based on course category and title
    return _generateModulesForCourse(category, title);
  }

  // Generate specific modules based on course category and title
  List<Map<String, dynamic>> _generateModulesForCourse(String category, String title) {
    // Flutter/Mobile Development
    if (title.toLowerCase().contains('flutter') || title.toLowerCase().contains('mobile')) {
      return [
        {'title': 'Setup & Environment'},
        {'title': 'Widget & Layout'},
        {'title': 'State Management'},
        {'title': 'API Integration'},
        {'title': 'Deployment & Testing'},
      ];
    }
    
    // UI/UX Design
    if (title.toLowerCase().contains('ui') || title.toLowerCase().contains('ux') || title.toLowerCase().contains('design')) {
      return [
        {'title': 'Design Principles'},
        {'title': 'User Research'},
        {'title': 'Wireframing & Prototyping'},
        {'title': 'Visual Design'},
        {'title': 'Usability Testing'},
      ];
    }
    
    // Digital Marketing
    if (title.toLowerCase().contains('marketing') || title.toLowerCase().contains('digital')) {
      return [
        {'title': 'Marketing Fundamentals'},
        {'title': 'SEO & Content Strategy'},
        {'title': 'Social Media Marketing'},
        {'title': 'Paid Advertising'},
        {'title': 'Analytics & Optimization'},
      ];
    }
    
    // Python/Data Science
    if (title.toLowerCase().contains('python') || title.toLowerCase().contains('data')) {
      return [
        {'title': 'Python Basics'},
        {'title': 'Data Manipulation'},
        {'title': 'Data Visualization'},
        {'title': 'Machine Learning'},
        {'title': 'Real-world Projects'},
      ];
    }
    
    // Business/Strategy
    if (title.toLowerCase().contains('business') || title.toLowerCase().contains('strategy')) {
      return [
        {'title': 'Business Fundamentals'},
        {'title': 'Strategic Planning'},
        {'title': 'Market Analysis'},
        {'title': 'Financial Planning'},
        {'title': 'Implementation & Growth'},
      ];
    }
    
    // React/React Native
    if (title.toLowerCase().contains('react')) {
      return [
        {'title': 'React Fundamentals'},
        {'title': 'Component Architecture'},
        {'title': 'State & Props Management'},
        {'title': 'Navigation & Routing'},
        {'title': 'App Store Deployment'},
      ];
    }
    
    // Default modules for other courses
    return [
      {'title': 'Pengenalan Dasar'},
      {'title': 'Konsep Lanjutan'},
      {'title': 'Praktik & Implementasi'},
      {'title': 'Studi Kasus'},
    ];
  }
  bool get hasCertificate => true; // Default true

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'instructor': instructor,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'totalReviews': totalReviews,
      'duration': duration,
      'level': level,
      'category': category,
      'imageUrl': imageUrl,
      'isFree': isFree,
      'isPopular': isPopular,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from JSON (Firebase)
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      instructor: json['instructor'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      originalPrice: json['originalPrice'] ?? 0,
      discountPercentage: json['discountPercentage'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      duration: json['duration'] ?? '',
      level: json['level'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isFree: json['isFree'] ?? false,
      isPopular: json['isPopular'] ?? false,
      createdAt: json['createdAt'] is Timestamp 
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp 
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Copy with method for updates
  Course copyWith({
    String? id,
    String? title,
    String? instructor,
    String? description,
    int? price,
    int? originalPrice,
    int? discountPercentage,
    double? rating,
    int? totalReviews,
    String? duration,
    String? level,
    String? category,
    String? imageUrl,
    bool? isFree,
    bool? isPopular,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFree: isFree ?? this.isFree,
      isPopular: isPopular ?? this.isPopular,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Course(id: $id, title: $title, instructor: $instructor, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
