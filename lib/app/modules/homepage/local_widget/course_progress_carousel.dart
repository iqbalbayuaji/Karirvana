import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/routes/app_pages.dart';
import 'package:karirvana/app/styles/app_colors.dart';
import '../local_widget/pie_chart.dart';

class CourseProgressCarousel extends StatefulWidget {
  final List<CourseData> courses;
  
  const CourseProgressCarousel({
    Key? key,
    required this.courses,
  }) : super(key: key);

  @override
  State<CourseProgressCarousel> createState() => _CourseProgressCarouselState();
}

class _CourseProgressCarouselState extends State<CourseProgressCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.courses.length > 1 ? 0.78 : 1.0,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.courses.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.courses.length == 1) {
      // Single course - no scrolling, centered
      return Align(
        alignment: Alignment.center,
        child: _buildCourseContainer(
          widget.courses[0],
          0,
          isActive: true,
          isSingle: true,
        ),
      );
    }

    // Multiple courses - scrollable with preview effect
    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.none, // Allow shadows to extend beyond container bounds
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.courses.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.12)).clamp(0.82, 1.0);
              } else {
                // Initial state - simulate the same behavior as when scrolling
                double simulatedPage = _currentIndex.toDouble();
                value = simulatedPage - index;
                value = (1 - (value.abs() * 0.12)).clamp(0.82, 1.0);
              }
              
              return Transform.scale(
                scale: value,
                child: _buildCourseContainer(
                  widget.courses[index],
                  index,
                  isActive: index == _currentIndex,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCourseContainer(
    CourseData course,
    int index, {
    bool isActive = false,
    bool isSingle = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.COURSE_USER, arguments: course);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isSingle ? 0 : 8,
          vertical: 30,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isSingle ? 320 : null,
          height: 180,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isActive ? 0.12 : 0.08),
                blurRadius: isActive ? 24 : 16,
                offset: Offset(0, isActive ? 8 : 4),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Last Activity",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  course.lastActivity,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Text(
                                " - ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                course.lastTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Chart_Pie(progress: course.progress),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseData {
  final String id;
  final String title;
  final String lastActivity;
  final String lastTime;
  final double progress;

  CourseData({
    required this.id,
    required this.title,
    required this.lastActivity,
    required this.lastTime,
    required this.progress,
  });
}
