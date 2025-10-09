import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/routes/app_pages.dart';
import 'package:karirvana/app/styles/app_colors.dart';
import '../local_widget/pie_chart.dart';
import '../../course_manage/controllers/course_manage_controller.dart';
import '../../certification_manage/controllers/certification_manage_controller.dart';

class CourseProgressCarousel extends StatefulWidget {
  const CourseProgressCarousel({Key? key}) : super(key: key);

  @override
  State<CourseProgressCarousel> createState() => _CourseProgressCarouselState();
}

class _CourseProgressCarouselState extends State<CourseProgressCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  
  // Controllers for data
  CourseManageController? _courseController;
  CertificationManageController? _certificationController;
  
  // Combined progress items
  List<ProgressItem> _progressItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProgressData();
  }

  void _initializeControllers() {
    // Initialize controllers
    try {
      _courseController = Get.find<CourseManageController>();
    } catch (e) {
      _courseController = Get.put(CourseManageController());
    }
    
    try {
      _certificationController = Get.find<CertificationManageController>();
    } catch (e) {
      _certificationController = Get.put(CertificationManageController());
    }

    // Add listeners for reactive updates
    _courseController?.courses.listen((_) {
      if (mounted) {
        _loadProgressData();
      }
    });

    _certificationController?.certifications.listen((_) {
      if (mounted) {
        _loadProgressData();
      }
    });
  }

  void _loadProgressData() {
    // Combine course and certification data
    final List<ProgressItem> items = [];
    
    // Add courses
    if (_courseController != null) {
      print('🔍 DEBUG: Found ${_courseController!.courses.length} courses');
      for (final course in _courseController!.courses) {
        print('🔍 DEBUG: Course: ${course.title}');
        print('🔍 DEBUG: Last Activity Module: ${course.lastActivityModule}');
        print('🔍 DEBUG: Last Activity Display: ${course.lastActivityDisplay}');
        print('🔍 DEBUG: Modules count: ${course.modules.length}');
        if (course.modules.isNotEmpty) {
          print('🔍 DEBUG: First module: ${course.modules.first.title}');
          print('🔍 DEBUG: First module lastAccessed: ${course.modules.first.lastAccessed}');
        }
        items.add(ProgressItem.fromCourse(course));
      }
    }
    
    // Add certifications
    if (_certificationController != null) {
      print('🔍 DEBUG: Found ${_certificationController!.certifications.length} certifications');
      for (final certification in _certificationController!.certifications) {
        items.add(ProgressItem.fromCertification(certification));
      }
    }
    
    // Sort by enrolled date (most recent first)
    items.sort((a, b) {
      if (a.enrolledDate == null && b.enrolledDate == null) return 0;
      if (a.enrolledDate == null) return 1;
      if (b.enrolledDate == null) return -1;
      return b.enrolledDate!.compareTo(a.enrolledDate!);
    });
    
    setState(() {
      _progressItems = items;
      _isLoading = false;
      
      // Initialize page controller based on items count if not already initialized
      if (!mounted) return;
      
      _pageController = PageController(
        viewportFraction: _progressItems.length > 1 ? 0.78 : 1.0,
      );
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
    });
  }

  // Public method to refresh data (can be called from parent widgets)
  void refreshData() {
    if (mounted) {
      _loadProgressData();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading) {
      return Container(
        height: 230,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show empty state when no progress items
    if (_progressItems.isEmpty) {
      return _buildEmptyState();
    }

    // Convert ProgressItems to CourseData for compatibility
    final courses = _progressItems.map((item) => CourseData.fromProgressItem(item)).toList();

    if (courses.length == 1) {
      // Single course - no scrolling, centered
      return Align(
        alignment: Alignment.center,
        child: _buildCourseContainer(
          courses[0],
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
        itemCount: courses.length,
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
                  courses[index],
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

  Widget _buildEmptyState() {
    return Container(
      height: 230,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Align(
        alignment: Alignment.center,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                width: 320,
                height: 180,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header with animated icon
                    Row(
                      children: [
                        // Animated icon container
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 1200),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.elasticOut,
                          builder: (context, iconValue, child) {
                            return Transform.scale(
                              scale: iconValue,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primary.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.school_rounded,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        // Title and description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mulai Perjalanan Belajar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Jelajahi course dan sertifikat\nuntuk mengembangkan skill Anda',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // DEBUG: Add refresh button
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        print('🔄 DEBUG: Manual refresh triggered');
                        await _courseController?.forceRefresh();
                        _loadProgressData();
                      },
                      child: const Text('DEBUG: Refresh Data'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isPrimary 
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
              )
            : null,
          color: isPrimary ? null : AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: isPrimary 
            ? null 
            : Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1,
              ),
          boxShadow: isPrimary 
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isPrimary ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
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

// Unified model for both courses and certifications
class ProgressItem {
  final String id;
  final String title;
  final String type; // 'course' or 'certification'
  final String lastActivity;
  final String lastTime;
  final double progress; // 0-100 for course, 0/100 for certification
  final DateTime? enrolledDate;

  ProgressItem({
    required this.id,
    required this.title,
    required this.type,
    required this.lastActivity,
    required this.lastTime,
    required this.progress,
    this.enrolledDate,
  });

  // Create from ManagedCourse
  factory ProgressItem.fromCourse(dynamic course) {
    final lastActivity = course.lastActivityDisplay;
    print('🔍 DEBUG ProgressItem: Course ${course.title} -> Last Activity: $lastActivity');
    
    return ProgressItem(
      id: course.id,
      title: course.title,
      type: 'course',
      lastActivity: lastActivity,
      lastTime: course.lastActivityTimeFormatted,
      progress: course.calculatedProgress,
      enrolledDate: course.enrolledDate,
    );
  }

  // Create from ManagedCertification
  factory ProgressItem.fromCertification(dynamic certification) {
    // Format time from enrolledDate
    String timeFormatted = '00:00';
    if (certification.enrolledDate != null) {
      final date = certification.enrolledDate!;
      timeFormatted = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return ProgressItem(
      id: certification.id,
      title: certification.title,
      type: 'certification',
      lastActivity: 'Memulai sertifikasi',
      lastTime: timeFormatted,
      progress: certification.isCompleted ? 100.0 : 0.0,
      enrolledDate: certification.enrolledDate,
    );
  }
}

// Legacy CourseData for backward compatibility
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

  // Convert from ProgressItem
  factory CourseData.fromProgressItem(ProgressItem item) {
    return CourseData(
      id: item.id,
      title: item.title,
      lastActivity: item.lastActivity,
      lastTime: item.lastTime,
      progress: item.progress,
    );
  }
}
