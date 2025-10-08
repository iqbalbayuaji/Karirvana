import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';
import '../../../data/models/course_model.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: 90,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(_getCourseImage(course.category, course.title)),
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
                          course.rating.toString(),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.title,
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
                        course.instructor,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
          
                      SizedBox(height: 10),
          
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          course.isFree
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
                                    if (course.showDiscount && course.discountedPrice > 0) ...[
                                      Text(
                                        _formatPrice(course.discountedPrice),
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        _formatPrice(course.originalPrice),
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
                                        _formatPrice(course.originalPrice),
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
          if (course.showDiscount)
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
                  course.discount,
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

  String _getCourseImage(String category, String title) {
    // Map course images based on category and title
    switch (category) {
      case 'Programming':
        if (title.toLowerCase().contains('flutter')) {
          return 'assets/course/course-frontend-1.jpg';
        } else if (title.toLowerCase().contains('python')) {
          return 'assets/course/course-python.jpg';
        } else if (title.toLowerCase().contains('react')) {
          return 'assets/course/course-programming-1.jpg';
        }
        return 'assets/course/course-programming-1.jpg';
      
      case 'Design':
        if (title.toLowerCase().contains('ui') || title.toLowerCase().contains('ux')) {
          return 'assets/course/course-uiux-1.jpg';
        }
        return 'assets/course/course-uiux-2.jpg';
      
      case 'Marketing':
        return 'assets/course/course-marketing-1.png';
      
      case 'Data Science':
        return 'assets/course/course-python.jpg';
      
      case 'Business':
        return 'assets/course/course-akuntansi-1.jpg';
      
      case 'Mobile Development':
        return 'assets/course/course-frontend-1.jpg';
      
      default:
        return 'assets/course/course-programming-1.jpg'; // Fallback image
    }
  }

  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
