import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';
import '../../../data/models/certification_model.dart';

class CertificationCard extends StatelessWidget {
  final Certification certification;
  final VoidCallback? onTap;

  const CertificationCard({
    super.key,
    required this.certification,
    this.onTap,
  });

  String _getCertificationImage(String category, String title) {
    // Map certification categories to images
    switch (category.toLowerCase()) {
      case 'it & programming':
      case 'programming':
        return 'assets/course/course-programming-1.jpg';
      case 'digital marketing':
      case 'marketing':
        return 'assets/course/course-marketing-1.png';
      case 'data analytics':
      case 'data science':
        return 'assets/course/course-python.jpg';
      case 'design':
      case 'ui/ux':
        return 'assets/course/course-uiux-1.jpg';
      case 'business':
      case 'project management':
        return 'assets/course/course-akuntansi-1.jpg';
      case 'finance':
        return 'assets/course/course-akuntansi-2.jpg';
      case 'cloud computing':
        return 'assets/course/course-backend-1.webp';
      case 'cyber security':
        return 'assets/course/course-programming-1.jpg';
      default:
        return 'assets/course/course-programming-1.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 13, 0, 10),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.outline.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: 90,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(_getCertificationImage(certification.category, certification.title)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          certification.rating.toString(),
                          style: TextStyle(
                            color: AppColors.textOnPrimary,
                            fontFamily: "Montserrat",
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              
                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certification.title,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        certification.provider,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      
                      SizedBox(height: 4),
                      
                      // Validity Period
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Berlaku ${certification.validityPeriod}',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
          
                      SizedBox(height: 6),
          
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          certification.isFree
                              ? Container(
                                  child: Text(
                                    'GRATIS',
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (certification.showDiscount && certification.discountedPrice > 0) ...[
                                      Text(
                                        _formatPrice(certification.discountedPrice),
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        _formatPrice(certification.originalPrice),
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textSecondary,
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: AppColors.textSecondary,
                                        ),
                                      ),
                                    ] else
                                      Text(
                                        _formatPrice(certification.originalPrice),
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                  ],
                                ),
          
                          Container(
                            child: Text(
                              certification.level,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getLevelColor(certification.level),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (certification.showDiscount)
            Container(
              height: 22,
              width: 70,
              decoration: BoxDecoration(
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
              child: Center(
                child: Text(
                  certification.discount,
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontFamily: "Montserrat",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


  Color _getLevelColor(String level) {
    switch (level) {
      case 'Pemula':
        return Color(0xFF10B981);
      case 'Menengah':
        return Color(0xFFF59E0B);
      case 'Lanjutan':
        return Color(0xFFEF4444);
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
