import 'package:cloud_firestore/cloud_firestore.dart';

class Certification {
  final String id;
  final String title;
  final String provider;
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
  final String validityPeriod;
  final List<String> benefits;
  final List<String> requirements;
  final DateTime createdAt;
  final DateTime updatedAt;

  Certification({
    required this.id,
    required this.title,
    required this.provider,
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
    required this.validityPeriod,
    required this.benefits,
    required this.requirements,
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

  // Check if certification has discount
  bool get hasDiscount => discountPercentage > 0;

  // Get discount text
  String get discountText => hasDiscount ? '$discountPercentage% Off' : '';

  // Backward compatibility getters
  int get totalParticipants => totalReviews; // For UI compatibility
  int get totalModules => 10; // Default value for UI compatibility
  String get discount => discountText;
  bool get showDiscount => hasDiscount;

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'provider': provider,
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
      'validityPeriod': validityPeriod,
      'benefits': benefits,
      'requirements': requirements,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from JSON (Firebase)
  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      provider: json['provider'] ?? '',
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
      validityPeriod: json['validityPeriod'] ?? '',
      benefits: List<String>.from(json['benefits'] ?? []),
      requirements: List<String>.from(json['requirements'] ?? []),
      createdAt: json['createdAt'] is Timestamp 
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp 
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Copy with method for updates
  Certification copyWith({
    String? id,
    String? title,
    String? provider,
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
    String? validityPeriod,
    List<String>? benefits,
    List<String>? requirements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Certification(
      id: id ?? this.id,
      title: title ?? this.title,
      provider: provider ?? this.provider,
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
      validityPeriod: validityPeriod ?? this.validityPeriod,
      benefits: benefits ?? this.benefits,
      requirements: requirements ?? this.requirements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Certification(id: $id, title: $title, provider: $provider, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Certification && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
