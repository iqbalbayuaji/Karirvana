import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';

Widget buildGridItem(int index) {
    final items = [
      {
        'title': 'Roadmap',
        'icon': Icons.map_outlined,
      },
      {
        'title': 'Jadwal',
        'icon': Icons.schedule_outlined,
      },
      {
        'title': 'Interview\nPractice',
        'icon': Icons.psychology_outlined,
      },
      {
        'title': 'Course',
        'icon': Icons.school_outlined,
      },
      {
        'title': 'Certification',
        'icon': Icons.verified_outlined,
      },
    ];

    // Consistent color and gradient for all items


    final item = items[index];
    
    return GestureDetector(
      onTap: () {
        // Handle navigation based on index
        switch (index) {
          case 0:
            // Navigate to Roadmap
            if (Get.context != null) {
              Get.toNamed(Routes.ROADMAP_MANAGE);
            }            
            break;
          case 1:
            // Navigate to Jadwal
            if (Get.context != null) {
              Get.toNamed(Routes.JADWAL_MANAGE);
            }
            break;
          case 2:
            // Navigate to Interview Practice History
            if (Get.context != null) {
              Get.toNamed(Routes.INTERVIEW_PRACTICE_HISTORY);
            }
            break;
          case 3:
            // Navigate to Course
            if (Get.context != null) {
              Get.toNamed(Routes.COURSE_MANAGE);
            }
            break;
          case 4:
            // Navigate to Certification
            if (Get.context != null) {
              Get.toNamed(Routes.CERTIFICATION_MANAGE);
            }
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.textOnPrimary,
                        size: 30,
                      ),
                    ),
                  ),
                  Text(
                    item['title'] as String,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.textSecondary,
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }