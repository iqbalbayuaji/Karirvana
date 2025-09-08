import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';

import '../../../routes/app_pages.dart';

class RekomendasiContainer extends StatelessWidget {
  final int index;

  const RekomendasiContainer({
    super.key,
    required this.index,
  });

  static final List<Map<String, dynamic>> _recommendations = [
    {
      'title': 'Microsoft Excel Beginner Course',
      'instructor': 'Dr. Ahmad Wijaya',
      'category': 'Programming',
      'description': 'Belajar Microsoft Excel dari dasar hingga mahir dengan project nyata',
      'originalPrice': 200000,
      'discountedPrice': 140000,
      'imageUrl': 'assets/images/hero.jpg',
      'rating': 4.8,
      'totalStudents': 1250,
      'totalLessons': 32,
      'duration': '8 jam',
      'isFree': false,
      'level': 'Pemula',
      'discount': '30% Off',
      'showDiscount': true,
    },
    {
      'title': 'Flutter Development Bootcamp',
      'instructor': 'Sarah Putri',
      'category': 'Mobile Development',
      'description': 'Membangun aplikasi mobile dengan Flutter dari dasar hingga mahir',
      'originalPrice': 350000,
      'discountedPrice': 175000,
      'imageUrl': 'assets/images/hero.jpg',
      'rating': 4.9,
      'totalStudents': 890,
      'totalLessons': 45,
      'duration': '12 jam',
      'isFree': false,
      'level': 'Pemula',
      'discount': '50% Off',
      'showDiscount': true,
    },
    {
      'title': 'Digital Marketing Fundamentals',
      'instructor': 'Budi Santoso',
      'category': 'Marketing',
      'description': 'Strategi pemasaran digital yang terbukti efektif',
      'originalPrice': 180000,
      'discountedPrice': 135000,
      'imageUrl': 'assets/images/hero.jpg',
      'rating': 4.7,
      'totalStudents': 2100,
      'totalLessons': 28,
      'duration': '6 jam',
      'isFree': false,
      'level': 'Menengah',
      'discount': '25% Off',
      'showDiscount': true,
    },
    {
      'title': 'Data Science with Python',
      'instructor': 'Prof. Lisa Chen',
      'category': 'Data Science',
      'description': 'Analisis data menggunakan Python dan library populer',
      'originalPrice': 250000,
      'discountedPrice': 0,
      'imageUrl': 'assets/images/hero.jpg',
      'rating': 4.6,
      'totalStudents': 1580,
      'totalLessons': 38,
      'duration': '15 jam',
      'isFree': false,
      'level': 'Menengah',
      'discount': '',
      'showDiscount': false,
    },
    {
      'title': 'UI/UX Design Masterclass',
      'instructor': 'Michael Johnson',
      'category': 'Design',
      'description': 'Pelajari prinsip desain UI/UX yang efektif dan modern',
      'originalPrice': 300000,
      'discountedPrice': 180000,
      'imageUrl': 'assets/images/hero.jpg',
      'rating': 4.5,
      'totalStudents': 750,
      'totalLessons': 25,
      'duration': '10 jam',
      'isFree': false,
      'level': 'Lanjutan',
      'discount': '40% Off',
      'showDiscount': true,
    },
  ];

  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final recommendation = _recommendations[index % _recommendations.length];
    final String title = recommendation['title'];
    final int originalPrice = recommendation['originalPrice'];
    final int discountedPrice = recommendation['discountedPrice'];
    final String imageUrl = recommendation['imageUrl'];
    final String discount = recommendation['discount'];
    final bool showDiscount = recommendation['showDiscount'];
    
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.COURSE_STORE);
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 15, 20),
            width: 220,
            decoration: BoxDecoration(
              boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.10),
                                              blurRadius: 10,
                                              offset: const Offset(0, 8),
                                            )
                                          ],
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                children: [
                  Expanded(
                    flex: 30,
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "Montserrat",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (showDiscount && discountedPrice > 0) ...[
                            Row(
                              children: [
                                Text(
                                  _formatPrice(discountedPrice),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  _formatPrice(originalPrice),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: "Montserrat",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ] else
                            Text(
                              _formatPrice(originalPrice),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontFamily: "Montserrat",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showDiscount)
            Container(
              height: 24,
              width: 70,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(9),
                  bottomLeft: Radius.circular(9),
                ),
                gradient: LinearGradient(
                    colors: AppColors.heroGradientSecondary,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
              ),
              child: Text(
                discount,
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontFamily: "Montserrat",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
        ],
      ),
    );
  }
}