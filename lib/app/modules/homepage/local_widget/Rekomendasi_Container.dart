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
      'originalPrice': 200000,
      'discountedPrice': 140000,
      'imageUrl': 'assets/images/hero.jpg',
      'discount': '30% Off',
      'showDiscount': true,
    },
    {
      'title': 'Flutter Development Bootcamp',
      'originalPrice': 350000,
      'discountedPrice': 175000,
      'imageUrl': 'assets/images/hero.jpg',
      'discount': '50% Off',
      'showDiscount': true,
    },
    {
      'title': 'Digital Marketing Fundamentals',
      'originalPrice': 180000,
      'discountedPrice': 135000,
      'imageUrl': 'assets/images/hero.jpg',
      'discount': '25% Off',
      'showDiscount': true,
    },
    {
      'title': 'Data Science with Python',
      'originalPrice': 250000,
      'discountedPrice': 0,
      'imageUrl': 'assets/images/hero.jpg',
      'discount': '',
      'showDiscount': false,
    },
    {
      'title': 'UI/UX Design Masterclass',
      'originalPrice': 300000,
      'discountedPrice': 180000,
      'imageUrl': 'assets/images/hero.jpg',
      'discount': '40% Off',
      'showDiscount': true,
    },
  ];

  String _formatPrice(int price) {
    return 'Rp. ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
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
                            // Show discounted price
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
                            // Show original price with strikethrough
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
                          ] else
                            // Show regular price when no discount
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