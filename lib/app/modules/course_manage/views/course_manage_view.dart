import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/course_manage_controller.dart';
import '../local_widgets/course_card.dart';

class CourseManageView extends GetView<CourseManageController> {
  const CourseManageView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        print('🔍 CourseManageView rebuild - courses count: ${controller.courses.length}');
        print('📋 Courses: ${controller.courses.map((c) => c.title).toList()}');
        
        return SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: controller.isLoading.value
                    ? _buildLoadingState()
                    : controller.hasCourses
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
            'Kelola Course',
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading circle similar to Interview Practice
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Memuat Course...',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.courses.length,
      itemBuilder: (context, index) {
        final course = controller.courses[index];
        return ManagedCourseCard(
          course: course,
          onTap: () {
            // No action - just display course info
            print('Tapped course: ${course.title}');
          },
        );
      },
    );
  }

}
