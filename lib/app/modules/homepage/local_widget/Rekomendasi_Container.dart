import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';

import '../../../routes/app_pages.dart';
import '../../course_store_main/controllers/course_store_main_controller.dart';

class RekomendasiContainer extends StatefulWidget {
  final int index;

  const RekomendasiContainer({
    super.key,
    required this.index,
  });

  @override
  State<RekomendasiContainer> createState() => _RekomendasiContainerState();
}

class _RekomendasiContainerState extends State<RekomendasiContainer> {
  CourseStoreMainController? _courseController;
  bool _isInitialized = false;

  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
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

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (_isInitialized) return;
    
    try {
      _courseController = Get.find<CourseStoreMainController>();
    } catch (e) {
      _courseController = Get.put(CourseStoreMainController());
    }
    
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_courseController == null) {
      _initializeController();
    }
    
    return Obx(() {
      // Get course from the controller
      final course = _courseController!.allCourses.isNotEmpty 
          ? _courseController!.allCourses[widget.index % _courseController!.allCourses.length]
          : null;
    
      // If no course data available, show loading or empty state
      if (course == null) {
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 15, 20),
          width: 220,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        );
      }
    
    final String title = course.title;
    final int originalPrice = course.originalPrice;
    final int discountedPrice = course.discountedPrice;
    final String imageUrl = _getCourseImage(course.category, course.title);
    final String discount = course.discount;
    final bool showDiscount = course.showDiscount;
    final bool isFree = course.isFree;
    
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.COURSE_STORE, arguments: {'courseId': course.id});
        },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 15, 20),
            width: 220,
            decoration: BoxDecoration(
              boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 8),
                                            )
                                          ],
              color: AppColors.surface,
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
                          ] else if (isFree)
                            Text(
                              'GRATIS',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontFamily: "Montserrat",
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          else
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
              constraints: BoxConstraints(
                minWidth: 70,
                maxWidth: 85,
              ),
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
    });
  }
}