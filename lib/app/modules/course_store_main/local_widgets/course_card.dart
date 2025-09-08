import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';
import '../controllers/course_store_main_controller.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
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
          border: Border.all(
            color: AppColors.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: _getCategoryGradient(course.category),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(course.category),
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    course.instructor,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.star_fill,
                        size: 14,
                        color: Color(0xFFFBBF24),
                      ),
                      SizedBox(width: 4),
                      Text(
                        course.rating.toString(),
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        CupertinoIcons.person_2_fill,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _formatNumber(course.totalStudents),
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        CupertinoIcons.clock_fill,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        course.duration,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      course.isFree
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
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
                                if (course.showDiscount && course.discountedPrice > 0) ...[
                                  // Show discounted price
                                  Text(
                                    'Rp.${_formatPrice(course.discountedPrice)}',
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  // Show original price with strikethrough
                                  Text(
                                    'Rp.${_formatPrice(course.originalPrice)}',
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
                                  // Show regular price when no discount
                                  Text(
                                    'Rp.${_formatPrice(course.originalPrice)}',
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getLevelColor(course.level).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          course.level,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getLevelColor(course.level),
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
    );
  }

  List<Color> _getCategoryGradient(String category) {
    switch (category) {
      case 'Programming':
        return [AppColors.primary, Color(0xFF6366F1)];
      case 'Design':
        return [AppColors.secondary, Color(0xFF06B6D4)];
      case 'Marketing':
        return [AppColors.tertiary, Color(0xFFEC4899)];
      case 'Business':
        return [Color(0xFFF59E0B), Color(0xFFEF4444)];
      case 'Data Science':
        return [Color(0xFF10B981), Color(0xFF059669)];
      case 'Mobile Development':
        return [Color(0xFFEF4444), Color(0xFFDC2626)];
      default:
        return AppColors.heroGradient;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Programming':
        return CupertinoIcons.device_laptop;
      case 'Design':
        return CupertinoIcons.paintbrush_fill;
      case 'Marketing':
        return CupertinoIcons.chart_bar_fill;
      case 'Business':
        return CupertinoIcons.briefcase_fill;
      case 'Data Science':
        return CupertinoIcons.graph_circle_fill;
      case 'Mobile Development':
        return CupertinoIcons.device_phone_portrait;
      default:
        return CupertinoIcons.book_fill;
    }
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

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
