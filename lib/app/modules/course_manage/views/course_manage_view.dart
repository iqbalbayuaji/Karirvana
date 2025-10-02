import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/course_manage_controller.dart';
import '../../course_store_main/local_widgets/course_card.dart';
import '../../course_store_main/controllers/course_store_main_controller.dart' as store;

class CourseManageView extends GetView<CourseManageController> {
  const CourseManageView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: controller.hasCourses
                    ? _buildCoursesList()
                    : _buildEmptyState(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          const Text(
            'Course Manage',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(
            width: 24,
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              child: const Icon(
                Icons.school,
                size: 60,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum Ada Kursus',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Anda belum mengikuti kursus apapun.\nMulai tambahkan kursus untuk meningkatkan skill Anda!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.courses.length,
      itemBuilder: (context, index) {
        final course = controller.courses[index];
        // Convert to store course model
        final storeCourse = _convertToStoreCourse(course);
        return _buildCustomCourseCard(course, storeCourse);
      },
    );
  }

  // Convert manage course to store course model
  store.Course _convertToStoreCourse(Course course) {
    return store.Course(
      id: course.id,
      title: course.title,
      instructor: course.provider, // Use provider as instructor
      instructorBio: 'Instructor berpengalaman dalam bidang ${course.title}',
      instructorImage: 'assets/images/default_instructor.jpg',
      category: 'Programming', // Default category
      description: course.description,
      imageUrl: '', // No image for managed courses
      rating: 4.5, // Default rating
      totalStudents: 0, // Default students
      totalLessons: 10, // Default lessons
      duration: '4 minggu', // Default duration
      originalPrice: 0, // Free for managed courses
      discountedPrice: 0,
      isFree: true,
      level: '', // Empty level to hide default text
      discount: '',
      showDiscount: false,
      language: 'Bahasa Indonesia',
      hasCertificate: false,
      totalReviews: 0,
      requirements: ['Tidak ada persyaratan khusus'],
      whatYouWillLearn: ['Materi akan disesuaikan dengan kebutuhan'],
      modules: [], // Empty modules for managed courses
    );
  }

  // Build custom course card with proper status display
  Widget _buildCustomCourseCard(Course course, store.Course storeCourse) {
    return Stack(
      children: [
        CourseCard(
          course: storeCourse,
          onTap: () {
            // Handle course tap - no popup
          },
        ),
        // Override status text
        Positioned(
          right: 22,
          bottom: 26,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              _getStatusText(course),
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(course),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Get status text for display
  String _getStatusText(Course course) {
    if (course.isCompleted) {
      return 'Completed';
    } else if (course.progress > 0) {
      return 'On Progress';
    } else {
      return 'Added';
    }
  }

  // Get status color
  Color _getStatusColor(Course course) {
    if (course.isCompleted) {
      return const Color(0xFF10B981); // Green for completed
    } else if (course.progress > 0) {
      return const Color(0xFFEF4444); // Red for on progress
    } else {
      return const Color(0xFFF59E0B); // Orange for added
    }
  }
}
